# RE CODE 👾

<p align="center">
  <img src="https://img.shields.io/badge/version-3.0.1-purple.svg" alt="Version">
  <img src="https://img.shields.io/badge/platform-Windows%20macOS%20Linux%20Termux-pink.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License">
  <img src="https://img.shields.io/badge/npm-Not%20Published-purple.svg" alt="NPM">
</p>

**RE CODE** — Open-source multi-model AI chat interface with custom model support.

---

## Why ReCode?

| Feature | Description |
|---------|-------------|
| Multi-Model | Claude Opus/Sonnet/Haiku, custom models |
| Configurable | Model selection, API endpoints, env vars |
| Multi-Provider | Anthropic, AWS Bedrock, Google Vertex, Azure |
| Cross-Platform | Windows, macOS, Linux, Termux |
| Enterprise | Permissions, workspace trust |

---

## Architecture

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  Onboarding → ModelPicker → REPL   │
└────────────────┬────────────────────┘
                 ▼
┌─────────────────────────────────────┐
│         Business Logic Layer        │
│  Commands → Query Engine → Tools   │
└────────────────┬────────────────────┘
                 ▼
┌─────────────────────────────────────┐
│              API Layer              │
│      Claude API → Auth → Errors    │
└────────────────┬────────────────────┘
                 ▼
┌─────────────────────────────────────┐
│       Provider Integration          │
│  Anthropic │ Bedrock │ Vertex │ Foundry │
└─────────────────────────────────────┘
```

---

## Core Workflow

```
CLI Entry → Bootstrap → Config Check
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
   First Launch            Main Loop
        │                       │
   Onboarding          Ready to Use!
   Theme → Model → Security
```

---

## Model Configuration

### Priority Order

| # | Source | Example |
|---|--------|---------|
| 1 | /model cmd | /model opus |
| 2 | --model flag | --model sonnet |
| 3 | ENV variable | ANTHROPIC_MODEL=haiku |
| 4 | settings.json | { "model": "..." } |
| 5 | Default | Sonnet 4.6 |

### Model Resolution Flow

```
User Input → Alias Resolution → [1m] Suffix → Provider Mapping → Final Model
```

---

## Custom Model & Providers

```
Environment Variables → getAPIProvider()
                              │
         ┌────────┬─────────┴────────┬──────────┐
         ▼        ▼            ▼          ▼
    Bedrock   Vertex      Foundry     FirstParty
      │          │            │           │
      ▼          ▼            ▼           ▼
    AWS ARN   Vertex ID   Deploy ID   claude-xxx
```

### Environment Variables

```bash
# API Config
ANTHROPIC_API_KEY=your-key
ANTHROPIC_BASE_URL=custom-endpoint
ANTHROPIC_MODEL=model-name

# Provider Selection
CLAUDE_CODE_USE_BEDROCK=1
CLAUDE_CODE_USE_VERTEX=1
CLAUDE_CODE_USE_FOUNDRY=1
```

---

## State Management

```
App State (In-Memory)
    │
    └── mainLoopModel, isFastMode, permissions
    │
    ▼
Global Config (Persistent)
    │
    └── theme, hasCompletedOnboarding, hasCompletedModelSetup
    │
    ▼
Settings (settings.json)
    │
    └── model, allowedMcpServers, permissions
```

---

## Installation

| Platform | Command |
|----------|---------|
| macOS/Linux | `curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.sh \| bash` |
| Windows | `irm https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 \| iex` |
| Termux | `curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install-termux.sh \| bash` |
| NPM | `npm install -g github:mangiapanejohn-dev/-Re-Code` |

---

## First Launch Flow

```
Welcome → Theme Selection → MODEL SELECTION (REQUIRED) → Security → Ready!
                                              │
                              ┌───────────────┴───────────────┐
                              ▼                               ▼
                    Save to settings.json          Mark hasCompletedModelSetup=true
```

### Commands

| Command | Description |
|---------|-------------|
| /help | Show help |
| /model | Switch model |
| /config | View/edit config |
| /clear | Clear session |
| /exit | Exit |

---

## Project Structure

```
ReCode/
├── src/
│   ├── components/     # React UI
│   │   ├── Onboarding.tsx
│   │   ├── ModelPicker.tsx
│   │   └── REPL.tsx
│   ├── utils/
│   │   ├── model/      # Model config
│   │   └── settings/   # User settings
│   └── commands/       # CLI commands
├── recode-temp/package/  # Built CLI
├── install.sh            # macOS/Linux
├── install.ps1           # Windows
└── install-termux.sh     # Termux
```

---

## Contributing

```bash
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode
git checkout -b feature/amazing
git commit -m 'Add feature'
git push origin feature/amazing
```

---

## License

MIT - See LICENSE

---

<p align="center">Made with love by ReCode Team</p>