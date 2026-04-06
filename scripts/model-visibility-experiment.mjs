#!/usr/bin/env node

/**
 * Model visibility experiment harness.
 *
 * This script is intentionally self-contained so we can run the experiment
 * without booting the full CLI, mutating user config, or depending on login.
 * The logic mirrors these source files:
 * - src/utils/privacyLevel.ts
 * - src/services/analytics/config.ts
 * - src/services/analytics/firstPartyEventLogger.ts
 * - src/services/analytics/growthbook.ts
 * - src/services/api/bootstrap.ts
 * - src/utils/model/check1mAccess.ts
 * - src/utils/model/model.ts
 * - src/utils/model/modelOptions.ts
 * - src/utils/model/configs.ts
 */

import { existsSync, readFileSync } from 'node:fs'
import { resolve } from 'node:path'

const SOURCE_PATHS = [
  'src/utils/privacyLevel.ts',
  'src/services/analytics/config.ts',
  'src/services/analytics/firstPartyEventLogger.ts',
  'src/services/analytics/growthbook.ts',
  'src/services/api/bootstrap.ts',
  'src/utils/model/check1mAccess.ts',
  'src/utils/model/model.ts',
  'src/utils/model/modelOptions.ts',
  'src/utils/model/configs.ts',
]

const MODEL_STRINGS = {
  firstParty: {
    haiku45: 'claude-haiku-4-5-20251001',
    sonnet45: 'claude-sonnet-4-5-20250929',
    sonnet46: 'claude-sonnet-4-6',
    opus41: 'claude-opus-4-1-20250805',
    opus46: 'claude-opus-4-6',
  },
  bedrock: {
    haiku45: 'us.anthropic.claude-haiku-4-5-20251001-v1:0',
    sonnet45: 'us.anthropic.claude-sonnet-4-5-20250929-v1:0',
    sonnet46: 'us.anthropic.claude-sonnet-4-6',
    opus41: 'us.anthropic.claude-opus-4-1-20250805-v1:0',
    opus46: 'us.anthropic.claude-opus-4-6-v1',
  },
  vertex: {
    haiku45: 'claude-haiku-4-5@20251001',
    sonnet45: 'claude-sonnet-4-5@20250929',
    sonnet46: 'claude-sonnet-4-6',
    opus41: 'claude-opus-4-1@20250805',
    opus46: 'claude-opus-4-6',
  },
  foundry: {
    haiku45: 'claude-haiku-4-5',
    sonnet45: 'claude-sonnet-4-5',
    sonnet46: 'claude-sonnet-4-6',
    opus41: 'claude-opus-4-1',
    opus46: 'claude-opus-4-6',
  },
}

const EXTRA_USAGE_FALSE_REASONS = new Set([
  'overage_not_provisioned',
  'org_level_disabled',
  'org_level_disabled_until',
  'seat_tier_level_disabled',
  'member_level_disabled',
  'seat_tier_zero_credit_limit',
  'group_zero_credit_limit',
  'member_zero_credit_limit',
  'org_service_level_disabled',
  'org_service_zero_credit_limit',
  'no_limits_configured',
  'unknown',
])

const EXTRA_USAGE_TRUE_REASONS = new Set(['out_of_credits'])

const USER_PROFILES = {
  payg: {
    label: 'PAYG/API',
    isClaudeAISubscriber: false,
    subscriptionType: null,
    rateLimitTier: null,
    defaultBootstrapAuth: 'api-key',
    defaultExtraUsageState: 'missing',
  },
  pro: {
    label: 'Claude Pro',
    isClaudeAISubscriber: true,
    subscriptionType: 'pro',
    rateLimitTier: null,
    defaultBootstrapAuth: 'oauth-profile',
    defaultExtraUsageState: 'enabled',
  },
  max: {
    label: 'Claude Max',
    isClaudeAISubscriber: true,
    subscriptionType: 'max',
    rateLimitTier: null,
    defaultBootstrapAuth: 'oauth-profile',
    defaultExtraUsageState: 'enabled',
  },
  team: {
    label: 'Claude Team Standard',
    isClaudeAISubscriber: true,
    subscriptionType: 'team',
    rateLimitTier: 'default_claude_team',
    defaultBootstrapAuth: 'oauth-profile',
    defaultExtraUsageState: 'enabled',
  },
  'team-premium': {
    label: 'Claude Team Premium',
    isClaudeAISubscriber: true,
    subscriptionType: 'team',
    rateLimitTier: 'default_claude_max_5x',
    defaultBootstrapAuth: 'oauth-profile',
    defaultExtraUsageState: 'enabled',
  },
  enterprise: {
    label: 'Claude Enterprise',
    isClaudeAISubscriber: true,
    subscriptionType: 'enterprise',
    rateLimitTier: null,
    defaultBootstrapAuth: 'oauth-profile',
    defaultExtraUsageState: 'enabled',
  },
  'subscriber-unknown': {
    label: 'Subscriber (type unknown)',
    isClaudeAISubscriber: true,
    subscriptionType: null,
    rateLimitTier: null,
    defaultBootstrapAuth: 'oauth-profile',
    defaultExtraUsageState: 'enabled',
  },
}

const DEFAULT_MATRIX_USER_KEYS = ['payg', 'pro', 'max']

const PRIVACY_SCENARIOS = [
  { name: 'baseline', flags: {} },
  { name: 'disable-telemetry', flags: { disableTelemetry: true } },
  { name: 'local-only', flags: { localOnly: true } },
  {
    name: 'disable-nonessential-traffic',
    flags: { disableNonessentialTraffic: true },
  },
  {
    name: 'telemetry-plus-nonessential',
    flags: { disableTelemetry: true, disableNonessentialTraffic: true },
  },
]

function printHelp() {
  console.log(`
Usage:
  node scripts/model-visibility-experiment.mjs
  node scripts/model-visibility-experiment.mjs --user pro --disable-telemetry
  node scripts/model-visibility-experiment.mjs --user max --provider bedrock --format json

What it does:
  Simulates how privacy flags influence analytics, GrowthBook, bootstrap, and
  the final model picker options, without touching your real Claude config.

Modes:
  No args               Run the default matrix for payg/pro/max across 5 privacy scenarios.
  Custom args present   Run a single scenario with your overrides.

Useful flags:
  --user <key>          payg | pro | max | team | team-premium | enterprise | subscriber-unknown
  --provider <name>     firstParty | bedrock | vertex | foundry
  --disable-telemetry   Simulate DISABLE_TELEMETRY=1
  --local-only          Simulate CLAUDE_CODE_LOCAL_ONLY=1
  --disable-nonessential-traffic
                        Simulate CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
  --extra-usage <state> missing | enabled | out_of_credits | disabled | <raw disabled reason>
  --bootstrap-auth <mode>
                        auto | none | api-key | oauth-profile
  --additional-model <value;label;description>
                        Repeatable. Simulates cached bootstrap model options.
  --config <path>       Read cachedExtraUsageDisabledReason and additionalModelOptionsCache from a JSON config file.
  --format <name>       table | json
  --all-users           Expand the default matrix to all built-in user profiles.
  --help                Show this help.

Examples:
  node scripts/model-visibility-experiment.mjs --user pro --extra-usage enabled
  node scripts/model-visibility-experiment.mjs --user payg --disable-nonessential-traffic --additional-model 'claude-x;Claude X;Server-injected model'
  node scripts/model-visibility-experiment.mjs --user subscriber-unknown --format json
`.trim())
}

function die(message) {
  console.error(`Error: ${message}`)
  process.exit(1)
}

function parseArgs(argv) {
  const args = {
    format: 'table',
    provider: undefined,
    user: undefined,
    disableTelemetry: undefined,
    localOnly: undefined,
    disableNonessentialTraffic: undefined,
    extraUsage: undefined,
    bootstrapAuth: 'auto',
    additionalModels: [],
    config: undefined,
    allUsers: false,
    help: false,
  }

  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i]
    switch (token) {
      case '--help':
      case '-h':
        args.help = true
        break
      case '--user':
        args.user = argv[++i]
        break
      case '--provider':
        args.provider = argv[++i]
        break
      case '--format':
        args.format = argv[++i]
        break
      case '--extra-usage':
        args.extraUsage = argv[++i]
        break
      case '--bootstrap-auth':
        args.bootstrapAuth = argv[++i]
        break
      case '--additional-model':
        args.additionalModels.push(argv[++i])
        break
      case '--config':
        args.config = argv[++i]
        break
      case '--disable-telemetry':
        args.disableTelemetry = true
        break
      case '--local-only':
        args.localOnly = true
        break
      case '--disable-nonessential-traffic':
        args.disableNonessentialTraffic = true
        break
      case '--all-users':
        args.allUsers = true
        break
      default:
        die(`unknown argument: ${token}`)
    }
  }

  return args
}

function hasCustomScenario(args) {
  return Boolean(
    args.user ||
      args.provider ||
      args.extraUsage ||
      args.additionalModels.length > 0 ||
      args.config ||
      args.disableTelemetry !== undefined ||
      args.localOnly !== undefined ||
      args.disableNonessentialTraffic !== undefined ||
      args.bootstrapAuth !== 'auto',
  )
}

function normalizeProvider(provider) {
  const normalized = provider ?? 'firstParty'
  if (!MODEL_STRINGS[normalized]) {
    die(`unsupported provider: ${provider}`)
  }
  return normalized
}

function normalizeUser(user) {
  const normalized = user ?? 'payg'
  if (!USER_PROFILES[normalized]) {
    die(`unsupported user profile: ${user}`)
  }
  return normalized
}

function resolveFlags(args, overrides = {}) {
  return {
    disableTelemetry:
      overrides.disableTelemetry ?? args.disableTelemetry ?? false,
    localOnly: overrides.localOnly ?? args.localOnly ?? false,
    disableNonessentialTraffic:
      overrides.disableNonessentialTraffic ??
      args.disableNonessentialTraffic ??
      false,
  }
}

function getPrivacyLevel(flags) {
  if (flags.disableNonessentialTraffic) {
    return 'essential-traffic'
  }
  if (flags.disableTelemetry || flags.localOnly) {
    return 'no-telemetry'
  }
  return 'default'
}

function isEssentialTrafficOnly(flags) {
  return getPrivacyLevel(flags) === 'essential-traffic'
}

function isTelemetryDisabled(flags) {
  return getPrivacyLevel(flags) !== 'default'
}

function isAnalyticsDisabled({ provider, flags }) {
  return (
    provider === 'bedrock' ||
    provider === 'vertex' ||
    provider === 'foundry' ||
    isTelemetryDisabled(flags) ||
    flags.localOnly
  )
}

function isGrowthBookEnabled(context) {
  return !isAnalyticsDisabled(context)
}

function parseAdditionalModel(raw) {
  const parts = raw.split(';')
  if (parts.length < 3) {
    die(
      `invalid --additional-model value: ${raw}. Expected "value;label;description"`,
    )
  }
  return {
    value: parts[0],
    label: parts[1],
    description: parts.slice(2).join(';'),
  }
}

function normalizeAdditionalModels(rawList) {
  return rawList.map(parseAdditionalModel)
}

function normalizeExtraUsageState(raw) {
  if (raw === undefined) return undefined
  if (raw === 'missing') return undefined
  if (raw === 'enabled' || raw === 'null') return null
  if (raw === 'disabled') return 'overage_not_provisioned'
  return raw
}

function normalizeExtraUsageReason(reason) {
  if (reason === undefined) return undefined
  if (reason === null) return null
  return String(reason)
}

function isExtraUsageEnabled(reason) {
  if (reason === undefined) {
    return false
  }
  if (reason === null) {
    return true
  }
  if (EXTRA_USAGE_TRUE_REASONS.has(reason)) {
    return true
  }
  if (EXTRA_USAGE_FALSE_REASONS.has(reason)) {
    return false
  }
  return false
}

function getModelStrings(provider) {
  return MODEL_STRINGS[provider]
}

function isMaxSubscriber(user) {
  return user.subscriptionType === 'max'
}

function isProSubscriber(user) {
  return user.subscriptionType === 'pro'
}

function isTeamPremiumSubscriber(user) {
  return (
    user.subscriptionType === 'team' &&
    user.rateLimitTier === 'default_claude_max_5x'
  )
}

function check1mAccess({ user, oneMDisabled, extraUsageDisabledReason }) {
  if (oneMDisabled) {
    return false
  }
  if (user.isClaudeAISubscriber) {
    return isExtraUsageEnabled(extraUsageDisabledReason)
  }
  return true
}

function isOpus1mMergeEnabled({ provider, user, oneMDisabled }) {
  if (oneMDisabled || isProSubscriber(user) || provider !== 'firstParty') {
    return false
  }
  if (user.isClaudeAISubscriber && user.subscriptionType === null) {
    return false
  }
  return true
}

function getDefaultSonnetModel(provider) {
  return provider === 'firstParty'
    ? getModelStrings(provider).sonnet46
    : getModelStrings(provider).sonnet45
}

function getDefaultOpusModel(provider) {
  return getModelStrings(provider).opus46
}

function getDefaultHaikuModel(provider) {
  return getModelStrings(provider).haiku45
}

function getDefaultModelSetting(context) {
  if (
    isMaxSubscriber(context.user) ||
    isTeamPremiumSubscriber(context.user)
  ) {
    return (
      getDefaultOpusModel(context.provider) +
      (context.opus1mMergeEnabled ? '[1m]' : '')
    )
  }
  return getDefaultSonnetModel(context.provider)
}

function makeOption(value, label, description = '') {
  return { value, label, description }
}

function getDefaultOption() {
  return makeOption(null, 'Default (recommended)')
}

function getSonnet46Option(provider) {
  return makeOption(
    provider === 'firstParty' ? 'sonnet' : getModelStrings(provider).sonnet46,
    'Sonnet',
  )
}

function getSonnet46_1MOption(provider) {
  return makeOption(
    provider === 'firstParty'
      ? 'sonnet[1m]'
      : `${getModelStrings(provider).sonnet46}[1m]`,
    'Sonnet (1M context)',
  )
}

function getOpus46Option(provider) {
  return makeOption(
    provider === 'firstParty' ? 'opus' : getModelStrings(provider).opus46,
    'Opus',
  )
}

function getOpus46_1MOption(provider) {
  return makeOption(
    provider === 'firstParty'
      ? 'opus[1m]'
      : `${getModelStrings(provider).opus46}[1m]`,
    'Opus (1M context)',
  )
}

function getMergedOpus1MOption(provider) {
  return getOpus46_1MOption(provider)
}

function getOpus41Option() {
  return makeOption('opus', 'Opus 4.1')
}

function getHaikuOption(provider) {
  return makeOption('haiku', 'Haiku', getDefaultHaikuModel(provider))
}

function getMaxOpusOption() {
  return makeOption('opus', 'Opus')
}

function getMaxSonnet46_1MOption() {
  return makeOption('sonnet[1m]', 'Sonnet (1M context)')
}

function getMaxOpus46_1MOption() {
  return makeOption('opus[1m]', 'Opus (1M context)')
}

function buildBaseOptions(context) {
  const options = [getDefaultOption()]
  const sonnet1mAccess = check1mAccess(context)
  const opus1mAccess = check1mAccess(context)

  if (context.user.isClaudeAISubscriber) {
    if (
      isMaxSubscriber(context.user) ||
      isTeamPremiumSubscriber(context.user)
    ) {
      if (!context.opus1mMergeEnabled && opus1mAccess) {
        options.push(getMaxOpus46_1MOption())
      }
      options.push(makeOption('sonnet', 'Sonnet'))
      if (sonnet1mAccess) {
        options.push(getMaxSonnet46_1MOption())
      }
      options.push(makeOption('haiku', 'Haiku'))
      return options
    }

    if (sonnet1mAccess) {
      options.push(getMaxSonnet46_1MOption())
    }

    if (context.opus1mMergeEnabled) {
      options.push(getMergedOpus1MOption(context.provider))
    } else {
      options.push(getMaxOpusOption())
      if (opus1mAccess) {
        options.push(getMaxOpus46_1MOption())
      }
    }

    options.push(makeOption('haiku', 'Haiku'))
    return options
  }

  if (context.provider === 'firstParty') {
    if (sonnet1mAccess) {
      options.push(getSonnet46_1MOption(context.provider))
    }
    if (context.opus1mMergeEnabled) {
      options.push(getMergedOpus1MOption(context.provider))
    } else {
      options.push(getOpus46Option(context.provider))
      if (opus1mAccess) {
        options.push(getOpus46_1MOption(context.provider))
      }
    }
    options.push(getHaikuOption(context.provider))
    return options
  }

  options.push(getSonnet46Option(context.provider))
  if (sonnet1mAccess) {
    options.push(getSonnet46_1MOption(context.provider))
  }
  options.push(getOpus41Option())
  options.push(getOpus46Option(context.provider))
  if (opus1mAccess) {
    options.push(getOpus46_1MOption(context.provider))
  }
  options.push(getHaikuOption(context.provider))
  return options
}

function appendAdditionalModels(options, additionalModels) {
  const merged = [...options]
  for (const option of additionalModels) {
    if (!merged.some(existing => existing.value === option.value)) {
      merged.push(option)
    }
  }
  return merged
}

function describeBootstrap({ provider, flags, bootstrapAuth }) {
  if (isEssentialTrafficOnly(flags)) {
    return {
      wouldFetch: false,
      reason: 'skipped: nonessential traffic disabled',
    }
  }
  if (provider !== 'firstParty') {
    return {
      wouldFetch: false,
      reason: 'skipped: third-party provider',
    }
  }
  if (bootstrapAuth === 'none') {
    return {
      wouldFetch: false,
      reason: 'skipped: no usable OAuth/API key',
    }
  }
  return {
    wouldFetch: true,
    reason: `would fetch via ${bootstrapAuth}`,
  }
}

function loadConfigSnapshot(configPath) {
  const resolved = resolve(configPath)
  if (!existsSync(resolved)) {
    die(`config file not found: ${resolved}`)
  }

  let parsed
  try {
    parsed = JSON.parse(readFileSync(resolved, 'utf8'))
  } catch (error) {
    die(`failed to parse config JSON: ${error.message}`)
  }

  const additionalModelOptionsCache = Array.isArray(
    parsed.additionalModelOptionsCache,
  )
    ? parsed.additionalModelOptionsCache
        .filter(
          item =>
            item &&
            typeof item.value === 'string' &&
            typeof item.label === 'string' &&
            typeof item.description === 'string',
        )
        .map(item => ({
          value: item.value,
          label: item.label,
          description: item.description,
        }))
    : []

  return {
    path: resolved,
    cachedExtraUsageDisabledReason: normalizeExtraUsageReason(
      parsed.cachedExtraUsageDisabledReason,
    ),
    additionalModelOptionsCache,
  }
}

function buildScenario({
  scenarioName,
  userKey,
  provider,
  flags,
  extraUsageDisabledReason,
  bootstrapAuth,
  additionalModelOptionsCache,
}) {
  const user = USER_PROFILES[userKey]
  const oneMDisabled = false
  const opus1mMergeEnabled = isOpus1mMergeEnabled({
    provider,
    user,
    oneMDisabled,
  })

  const context = {
    provider,
    user,
    oneMDisabled,
    extraUsageDisabledReason,
    opus1mMergeEnabled,
  }

  const baseOptions = buildBaseOptions(context)
  const finalOptions = appendAdditionalModels(
    baseOptions,
    additionalModelOptionsCache,
  )
  const bootstrap = describeBootstrap({ provider, flags, bootstrapAuth })

  return {
    scenarioName,
    userKey,
    userLabel: user.label,
    provider,
    flags,
    privacyLevel: getPrivacyLevel(flags),
    analyticsDisabled: isAnalyticsDisabled({ provider, flags }),
    growthBookEnabled: isGrowthBookEnabled({ provider, flags }),
    bootstrap,
    extraUsageDisabledReason:
      extraUsageDisabledReason === undefined
        ? 'missing-cache'
        : extraUsageDisabledReason,
    defaultModelSetting: getDefaultModelSetting(context),
    additionalModelOptionsCached: additionalModelOptionsCache.length,
    modelOptions: finalOptions,
    sourcePaths: SOURCE_PATHS,
  }
}

function pad(value, width) {
  return String(value).padEnd(width, ' ')
}

function renderTable(results) {
  const rows = results.map(result => ({
    scenario: result.scenarioName,
    privacy: result.privacyLevel,
    analytics: result.analyticsDisabled ? 'off' : 'on',
    growthbook: result.growthBookEnabled ? 'on' : 'off',
    bootstrap: result.bootstrap.reason,
    default: result.defaultModelSetting,
    options: result.modelOptions
      .map(option => (option.value === null ? 'default' : option.value))
      .join(', '),
  }))

  const widths = {
    scenario: Math.max(...rows.map(row => row.scenario.length), 'scenario'.length),
    privacy: Math.max(...rows.map(row => row.privacy.length), 'privacy'.length),
    analytics: Math.max(
      ...rows.map(row => row.analytics.length),
      'analytics'.length,
    ),
    growthbook: Math.max(
      ...rows.map(row => row.growthbook.length),
      'growthbook'.length,
    ),
    bootstrap: Math.max(
      ...rows.map(row => row.bootstrap.length),
      'bootstrap'.length,
    ),
    default: Math.max(...rows.map(row => row.default.length), 'default'.length),
  }

  const header = [
    pad('scenario', widths.scenario),
    pad('privacy', widths.privacy),
    pad('analytics', widths.analytics),
    pad('growthbook', widths.growthbook),
    pad('bootstrap', widths.bootstrap),
    pad('default', widths.default),
    'options',
  ].join(' | ')

  const divider = [
    '-'.repeat(widths.scenario),
    '-'.repeat(widths.privacy),
    '-'.repeat(widths.analytics),
    '-'.repeat(widths.growthbook),
    '-'.repeat(widths.bootstrap),
    '-'.repeat(widths.default),
    '-------',
  ].join('-|-')

  return [header, divider]
    .concat(
      rows.map(row =>
        [
          pad(row.scenario, widths.scenario),
          pad(row.privacy, widths.privacy),
          pad(row.analytics, widths.analytics),
          pad(row.growthbook, widths.growthbook),
          pad(row.bootstrap, widths.bootstrap),
          pad(row.default, widths.default),
          row.options,
        ].join(' | '),
      ),
    )
    .join('\n')
}

function renderMatrix(resultsByUser) {
  const sections = []
  for (const [userKey, results] of Object.entries(resultsByUser)) {
    const first = results[0]
    sections.push(
      `# ${first.userLabel} (${userKey}, provider=${first.provider}, extra_usage=${first.extraUsageDisabledReason})`,
    )
    sections.push(renderTable(results))
    sections.push('')
  }
  sections.push(
    'Notes: bootstrap only governs whether the client refreshes server-side cached additions. Cached additionalModelOptionsCache still remains visible until cleared.',
  )
  return sections.join('\n')
}

function main() {
  const args = parseArgs(process.argv.slice(2))
  if (args.help) {
    printHelp()
    return
  }

  if (!['table', 'json'].includes(args.format)) {
    die(`unsupported format: ${args.format}`)
  }

  const configSnapshot = args.config ? loadConfigSnapshot(args.config) : null
  const customMode = hasCustomScenario(args)

  if (!customMode) {
    const userKeys = args.allUsers
      ? Object.keys(USER_PROFILES)
      : DEFAULT_MATRIX_USER_KEYS
    const resultsByUser = {}

    for (const userKey of userKeys) {
      const user = USER_PROFILES[userKey]
      const provider = 'firstParty'
      const extraUsageDisabledReason =
        configSnapshot?.cachedExtraUsageDisabledReason ??
        normalizeExtraUsageState(user.defaultExtraUsageState)
      const additionalModelOptionsCache = [
        ...(configSnapshot?.additionalModelOptionsCache ?? []),
      ]

      resultsByUser[userKey] = PRIVACY_SCENARIOS.map(scenario =>
        buildScenario({
          scenarioName: scenario.name,
          userKey,
          provider,
          flags: scenario.flags,
          extraUsageDisabledReason,
          bootstrapAuth: user.defaultBootstrapAuth,
          additionalModelOptionsCache,
        }),
      )
    }

    if (args.format === 'json') {
      console.log(
        JSON.stringify(
          {
            mode: 'matrix',
            configPath: configSnapshot?.path ?? null,
            resultsByUser,
          },
          null,
          2,
        ),
      )
      return
    }

    console.log(renderMatrix(resultsByUser))
    return
  }

  const userKey = normalizeUser(args.user)
  const provider = normalizeProvider(args.provider)
  const user = USER_PROFILES[userKey]
  const flags = resolveFlags(args)
  const extraUsageDisabledReason =
    args.extraUsage !== undefined
      ? normalizeExtraUsageState(args.extraUsage)
      : configSnapshot?.cachedExtraUsageDisabledReason ??
        normalizeExtraUsageState(user.defaultExtraUsageState)
  const bootstrapAuth =
    args.bootstrapAuth === 'auto'
      ? provider === 'firstParty'
        ? user.defaultBootstrapAuth
        : 'none'
      : args.bootstrapAuth

  if (!['none', 'api-key', 'oauth-profile'].includes(bootstrapAuth)) {
    die(`unsupported bootstrap auth mode: ${bootstrapAuth}`)
  }

  const additionalModelOptionsCache = [
    ...(configSnapshot?.additionalModelOptionsCache ?? []),
    ...normalizeAdditionalModels(args.additionalModels),
  ]

  const result = buildScenario({
    scenarioName: 'custom',
    userKey,
    provider,
    flags,
    extraUsageDisabledReason,
    bootstrapAuth,
    additionalModelOptionsCache,
  })

  if (args.format === 'json') {
    console.log(
      JSON.stringify(
        {
          mode: 'custom',
          configPath: configSnapshot?.path ?? null,
          result,
        },
        null,
        2,
      ),
    )
    return
  }

  console.log(
    [
      `# ${result.userLabel} (${userKey}, provider=${provider})`,
      renderTable([result]),
      '',
      `extra_usage=${result.extraUsageDisabledReason}`,
      `additional_models_cached=${result.additionalModelOptionsCached}`,
      `source_logic=${result.sourcePaths.join(', ')}`,
    ].join('\n'),
  )
}

main()
