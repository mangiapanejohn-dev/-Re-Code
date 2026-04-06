import { getPrivacyLevel } from '../src/utils/privacyLevel.ts'
import { getModelOptions } from '../src/utils/model/modelOptions.ts'
console.log(JSON.stringify({ privacy: getPrivacyLevel(), options: getModelOptions().map(o => o.label) }))
