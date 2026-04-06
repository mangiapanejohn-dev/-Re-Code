import { c as _c } from "react/compiler-runtime";
import * as React from 'react';
import { Box, Text } from '../../ink.js';
import { env } from '../../utils/env.js';

export type ReCodePose = 'default' | 'happy' | 'wink'

type Props = {
  pose?: ReCodePose;
};

// RE Code ASCII art - 7 lines tall
const RECODE_ART: string[] = [
  " ██████╗ ███████╗  ██████╗ ██████╗ ██████╗ ███████╗",
  " ██╔══██╗██╔════╝ ██╔════╝██╔═══██╗██╔══██╗██╔════╝",
  " ██████╔╝█████╗   ██║     ██║   ██║██║  ██║█████╗  ",
  " ██╔══██╗██╔══╝   ██║     ██║   ██║██║  ██║██╔══╝  ",
  " ██║  ██║███████╗ ╚██████╗╚██████╔╝██████╔╝███████╗",
  " ╚═╝  ╚═╝╚══════╝  ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝"
];

// Compact single line version
const RECODE_COMPACT = "RE CODE";

export function ReCodeLogo({ pose = 'default' }: Props) {
  const $ = _c(10);

  if (env.terminal === "Apple_Terminal") {
    let t1;
    if ($[0] !== pose) {
      t1 = <Text bold={true} color="reCode">{RECODE_COMPACT}</Text>;
      $[0] = pose;
      $[1] = t1;
    } else {
      t1 = $[1];
    }
    return t1;
  }

  let t2;
  if ($[2] === Symbol.for("react.memo_cache_sentinel")) {
    t2 = (
      <Box flexDirection="column">
        <Text color="reCode">{RECODE_ART[0]}</Text>
        <Text color="reCode">{RECODE_ART[1]}</Text>
        <Text color="reCode">{RECODE_ART[2]}</Text>
        <Text color="reCode">{RECODE_ART[3]}</Text>
        <Text color="reCode">{RECODE_ART[4]}</Text>
        <Text color="reCode">{RECODE_ART[5]}</Text>
      </Box>
    );
    $[2] = t2;
  } else {
    t2 = $[2];
  }

  return t2;
}
