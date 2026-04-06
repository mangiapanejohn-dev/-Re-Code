import type { Command, CommandResultDisplay } from '../types/command.js'
import { getGlobalConfig, setGlobalConfig } from '../utils/config.js'
import { SPECIES, type Species, type Rarity, EYES, HATS, type Eye, type Hat } from '../buddy/types.js'
import { rollWithSeed } from '../buddy/companion.js'

// Custom companion that allows user selection
const CompanionSelectionCommand: Command = {
  type: 'prompt',
  name: '👾',
  description: 'Choose and customize your companion pet',
  contentLength: 0,
  progressMessage: 'showing companion options',
  source: 'builtin',
  async getPromptForCommand(args): Promise<{ prompt: string; schema?: object }> {
    const config = getGlobalConfig()
    const action = args?.[0]

    if (!action) {
      // Show menu
      const current = config.companion
      let message = '👾 **Companion Menu**\n\n'
      message += 'Current companion: '
      if (current) {
        message += `${current.name} (hatched ${new Date(current.hatchedAt).toLocaleDateString()})`
      } else {
        message += 'None'
      }
      message += '\n\n'
      message += '**Commands:**\n'
      message += '`/👾 spawn` - Create a new random companion\n'
      message += '`/👾 select <species>` - Choose a specific species\n'
      message += '`/👾 eye <type>` - Choose eye style\n'
      message += '`/👾 hat <type>` - Choose hat style\n'
      message += '`/👾 name <name>` - Set companion name\n'
      message += '`/👾 list` - Show all available options\n'
      message += '`/👾 delete` - Remove your companion\n'

      return { prompt: message }
    }

    switch (action) {
      case 'list': {
        let list = '📋 **Available Options**\n\n'
        list += '**Species:**\n'
        for (const s of SPECIES) {
          list += `- ${s}\n`
        }
        list += '\n**Eyes:**\n'
        for (const e of EYES) {
          list += `- ${e}\n`
        }
        list += '\n**Hats:**\n'
        for (const h of HATS) {
          list += `- ${h}\n`
        }
        return { prompt: list }
      }

      case 'spawn': {
        const seed = `${Date.now()}-${Math.random()}`
        const { bones } = rollWithSeed(seed)
        const name = args[1] || generateName(bones.rarity)
        const companion = {
          name,
          personality: generatePersonality(bones.rarity),
          hatchedAt: Date.now(),
        }
        // Clear any customizations when spawning new companion
        setGlobalConfig({ companion, companionCustomization: undefined })
        return { prompt: `✨ **New Companion Born!**\n\n**Name:** ${companion.name}\n**Species:** ${bones.species}\n**Rarity:** ${bones.rarity}\n**Eye:** ${bones.eye}\n**Hat:** ${bones.hat}\n**Shiny:** ${bones.shiny ? '✨ Yes!' : 'No'}\n\nStats:\n- DEBUGGING: ${bones.stats.DEBUGGING}\n- PATIENCE: ${bones.stats.PATIENCE}\n- CHAOS: ${bones.stats.CHAOS}\n- WISDOM: ${bones.stats.WISDOM}\n- SNARK: ${bones.stats.SNARK}` }
      }

      case 'select': {
        const species = args[1]?.toLowerCase() as Species | undefined
        if (!species || !SPECIES.includes(species)) {
          return { prompt: `❌ Invalid species. Use \`/👾 list\` to see available options.` }
        }
        if (!config.companion) {
          return { prompt: `❌ You don't have a companion yet. Use \`/👾 spawn\` to create one first.` }
        }
        // Store the customization, getCompanion will apply it
        const currentCustomization = config.companionCustomization || {}
        setGlobalConfig({
          companionCustomization: { ...currentCustomization, species }
        })
        return { prompt: `✅ Species changed to **${species}**!` }
      }

      case 'eye': {
        const eye = args[1]?.toLowerCase() as Eye | undefined
        if (!eye || !EYES.includes(eye)) {
          return { prompt: `❌ Invalid eye style. Use \`/👾 list\` to see available options.` }
        }
        if (!config.companion) {
          return { prompt: `❌ You don't have a companion yet. Use \`/👾 spawn\` to create one first.` }
        }
        const currentCustomization = config.companionCustomization || {}
        setGlobalConfig({
          companionCustomization: { ...currentCustomization, eye }
        })
        return { prompt: `✅ Eye style changed to **${eye}**!` }
      }

      case 'hat': {
        const hat = args[1]?.toLowerCase() as Hat | undefined
        if (!hat || !HATS.includes(hat)) {
          return { prompt: `❌ Invalid hat style. Use \`/👾 list\` to see available options.` }
        }
        if (!config.companion) {
          return { prompt: `❌ You don't have a companion yet. Use \`/👾 spawn\` to create one first.` }
        }
        const currentCustomization = config.companionCustomization || {}
        setGlobalConfig({
          companionCustomization: { ...currentCustomization, hat }
        })
        return { prompt: `✅ Hat style changed to **${hat}**!` }
      }

      case 'name': {
        const name = args.slice(1).join(' ')
        if (!name) {
          return { prompt: `❌ Please provide a name. Usage: \`/👾 name <name>\`` }
        }
        if (!config.companion) {
          return { prompt: `❌ You don't have a companion yet. Use \`/👾 spawn\` to create one first.` }
        }
        setGlobalConfig({ companion: { ...config.companion, name } })
        return { prompt: `✅ Companion renamed to **${name}**!` }
      }

      case 'delete': {
        if (!config.companion) {
          return { prompt: `❌ You don't have a companion to delete.` }
        }
        // Actually delete the companion
        setGlobalConfig({ companion: undefined, companionCustomization: undefined })
        return { prompt: `🗑️ Companion deleted! Use \`/👾 spawn\` to create a new one.` }
      }

      default:
        return { prompt: `❌ Unknown command: ${action}\nUse \`/👾\` without arguments to see the menu.` }
    }
  },
}

function generateName(rarity: Rarity): string {
  const names: Record<Rarity, string[]> = {
    common: ['Buddy', 'Pixel', 'Dot', 'Chip', 'Bean', 'Nugget', 'Sprout', 'Pebble'],
    uncommon: ['Spark', 'Glint', 'Breeze', 'Mist', ' Ember', 'Frost', 'Storm', 'Shadow'],
    rare: ['Aurora', 'Nebula', 'Cosmos', 'Stellar', 'Nova', 'Quasar', 'Zenith', 'Apex'],
    epic: ['Phantom', 'Cipher', 'Vector', 'Matrix', 'Nexus', 'Quantum', 'Synapse', 'Prism'],
    legendary: ['Omega', 'Alpha', 'Prime', 'Infinity', 'Eternity', 'Axiom', 'Paradigm', 'Sovereign'],
  }
  const list = names[rarity] || names.common
  return list[Math.floor(Math.random() * list.length)]
}

function generatePersonality(rarity: Rarity): string {
  const traits: Record<Rarity, string[]> = {
    common: ['Playful', 'Curious', 'Shy', 'Energetic', 'Calm'],
    uncommon: ['Clever', 'Adventurous', 'Loyal', 'Mysterious', 'Brave'],
    rare: ['Wise', 'Noble', 'Independent', 'Protective', 'Artistic'],
    epic: ['Regal', 'Enigmatic', 'Charismatic', 'Ambitious', 'Tenacious'],
    legendary: ['Divine', 'Omniscient', 'Eternal', 'Transcendent', 'Mythic'],
  }
  const list = traits[rarity] || traits.common
  return list[Math.floor(Math.random() * list.length)]
}

export default CompanionSelectionCommand