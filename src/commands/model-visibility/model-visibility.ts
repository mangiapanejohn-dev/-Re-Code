import { existsSync } from 'fs'
import { dirname, resolve } from 'path'
import { fileURLToPath } from 'url'
import { execa } from 'execa'
import type { LocalCommandCall } from '../../types/command.js'

function getCandidateScriptPaths(): string[] {
  const moduleDir = dirname(fileURLToPath(import.meta.url))
  const cliDir = dirname(process.argv[1] ?? moduleDir)

  return [
    resolve(moduleDir, '../../../scripts/model-visibility-experiment.mjs'),
    resolve(moduleDir, '../../../../scripts/model-visibility-experiment.mjs'),
    resolve(cliDir, '../scripts/model-visibility-experiment.mjs'),
    resolve(cliDir, '../../scripts/model-visibility-experiment.mjs'),
    resolve(process.cwd(), 'scripts/model-visibility-experiment.mjs'),
  ]
}

function getExperimentScriptPath(): string | null {
  for (const candidate of getCandidateScriptPaths()) {
    if (existsSync(candidate)) {
      return candidate
    }
  }
  return null
}

function splitArgs(rawArgs: string): string[] {
  const args: string[] = []
  let current = ''
  let quote: '"' | "'" | null = null
  let escaping = false

  for (const char of rawArgs) {
    if (escaping) {
      current += char
      escaping = false
      continue
    }

    if (char === '\\') {
      escaping = true
      continue
    }

    if (quote) {
      if (char === quote) {
        quote = null
      } else {
        current += char
      }
      continue
    }

    if (char === '"' || char === "'") {
      quote = char
      continue
    }

    if (/\s/.test(char)) {
      if (current) {
        args.push(current)
        current = ''
      }
      continue
    }

    current += char
  }

  if (escaping) {
    current += '\\'
  }

  if (quote) {
    throw new Error('Unterminated quote in /model-visibility arguments')
  }

  if (current) {
    args.push(current)
  }

  return args
}

function parseExperimentArgs(rawArgs: string): string[] {
  if (!rawArgs.trim()) {
    return []
  }
  return splitArgs(rawArgs)
}

export const call: LocalCommandCall = async args => {
  const scriptPath = getExperimentScriptPath()
  if (!scriptPath) {
    return {
      type: 'text',
      value:
        'Model visibility experiment script not found. Expected scripts/model-visibility-experiment.mjs in this checkout.',
    }
  }

  let argv: string[]
  try {
    argv = parseExperimentArgs(args)
  } catch (error) {
    return {
      type: 'text',
      value: error instanceof Error ? error.message : String(error),
    }
  }

  const result = await execa(process.execPath, [scriptPath, ...argv], {
    reject: false,
    cwd: process.cwd(),
  })

  const sections = []
  if (result.stdout.trim()) {
    sections.push(result.stdout.trim())
  }
  if (result.stderr.trim()) {
    sections.push(result.stderr.trim())
  }
  if (sections.length === 0) {
    sections.push(`Experiment exited with code ${result.exitCode}`)
  }

  return {
    type: 'text',
    value: sections.join('\n\n'),
  }
}
