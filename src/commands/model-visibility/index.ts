import type { Command } from '../../commands.js'

const modelVisibility = {
  type: 'local',
  name: 'model-visibility',
  aliases: ['model-exp'],
  description:
    'Run the local model visibility experiment for privacy flags and model options',
  supportsNonInteractive: true,
  load: () => import('./model-visibility.js'),
} satisfies Command

export default modelVisibility
