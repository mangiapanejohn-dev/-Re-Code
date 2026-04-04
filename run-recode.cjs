#!/usr/bin/env node
/**
 * ReCode Launcher
 * A simple wrapper that shows custom branding then runs Claude Code
 */

const { spawn } = require('child_process');
const path = require('path');

// Custom branding
const BANNER = `
╭─── ReCode v3.0.1 ───────────────────────────────────────────╮
│                                                              │
│                    Welcome back!                             │
│                                                              │
│                     ███████╗ ███████╗  ██████╗ ██████╗       │
│                     ██╔═══██╗██╔════╝ ██╔════╝██╔═══██╗       │
│                     ██████╔╝█████╗   ██║     ██║   ██║       │
│                     ██╔══██╗██╔══╝   ██║     ██║   ██║       │
│                     ██║  ██║███████╗ ╚██████╗╚██████╔╝       │
│                     ╚═╝  ╚═╝╚══════╝  ╚═════╝ ╚═════╝       │
│                                                              │
│                  Developed by Resonix - AG                │
│                      (MarkEllington)                        │
│                                                              │
╰──────────────────────────────────────────────────────────────╯
`;

console.log(BANNER);

// Find cli.js in the same directory
const cliPath = path.join(__dirname, 'cli.js');

// Check if cli.js exists
const fs = require('fs');
if (!fs.existsSync(cliPath)) {
  console.error('Error: cli.js not found. Please install @anthropic-ai/claude-code first.');
  console.error('Run: npm install -g @anthropic-ai/claude-code');
  process.exit(1);
}

// Spawn the actual Claude Code process
const args = process.argv.slice(2);
const claude = spawn(cliPath, args, {
  stdio: 'inherit',
  env: {
    ...process.env,
    // Override some environment variables for custom branding
    CLAUDE_CODE_ATTRIBUTION_HEADER: '0',
  }
});

claude.on('exit', (code) => {
  process.exit(code || 0);
});

claude.on('error', (err) => {
  console.error('Failed to start Claude Code:', err.message);
  process.exit(1);
});
