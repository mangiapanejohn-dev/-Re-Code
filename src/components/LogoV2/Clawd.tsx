import * as React from 'react'
import { Box, Text } from '../../ink.js'

export type ClawdPose =
  | 'default'
  | 'arms-up'
  | 'look-left'
  | 'look-right'

type Props = {
  pose?: ClawdPose
}

type Sprite = readonly [string, string, string]

const SPRITES: Record<ClawdPose, Sprite> = {
  default: [' ▗╭─╮▖ ', '▐║◕╳◕║▌', ' ▝▚▄▞▘ '],
  'look-left': [' ▗╭─╮▖ ', '▐║◃╳◃║▌', ' ▝▚▄▞▘ '],
  'look-right': [' ▗╭─╮▖ ', '▐║▹╳▹║▌', ' ▝▚▄▞▘ '],
  'arms-up': ['╭╲◕╳◕╱╮', ' ╲▚▄▞╱ ', ' ▝▘ ▝▘ '],
}

export function Clawd({ pose = 'default' }: Props = {}): React.ReactNode {
  const sprite = SPRITES[pose] ?? SPRITES.default

  return (
    <Box height={3} flexDirection="column" justifyContent="center" alignItems="center">
      {sprite.map((row, index) => (
        <Text key={index} color="clawd_body">
          {row}
        </Text>
      ))}
    </Box>
  )
}
