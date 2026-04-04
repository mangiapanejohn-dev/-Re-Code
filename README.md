# ReCode 🚀

<p align="center">
  <img src="https://img.shields.io/badge/version-3.0.1-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux%7C-Termux-green.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License">
  <img src="https://img.shields.io/badge/node-%3E%3D18.0.0-yellow.svg" alt="Node Version">
</p>

> **ReCode** — A powerful open-source multi-model AI chat interface with extensive customization capabilities.

---

## 🔥 Why ReCode?

| Feature | Description |
|---------|-------------|
| 🤖 **Multi-Model Support** | Claude Opus/Sonnet/Haiku, custom models, any OpenAI-compatible API |
| 🔧 **Highly Configurable** | Model selection, API endpoints, environment variables |
| 🌍 **Provider Agnostic** | Anthropic API, AWS Bedrock, Google Vertex, Azure Foundry |
| 💻 **Cross-Platform** | Windows, macOS, Linux, Termux |
| 🛡️ **Enterprise-Grade** | Permission system, workspace trust, MCP approval |
| ⚡ **Zero Dependencies** | Terminal-based, instant startup |

---

## 🏗️ Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                                    ReCode                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ╔═══════════════════════════════════════════════════════════════════════╗  │
│  ║                      PRESENTATION LAYER                               ║  │
│  ║  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐  ║  │
│  ║  │Onboard- │   │ Model   │   │  REPL   │   │Settings │   │ Theme   │  ║  │
│  ║  │   ing   │──▶│ Picker  │──▶│   UI    │──▶│   UI    │──▶│ Picker  │  ║  │
│  ║  └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘  ║  │
│  ║       │              │             │             │              │       ║  │
│  ║       └──────────────┴─────────────┴─────────────┴──────────────┘       ║  │
│  ╚═══════════════════════════════════════════════════════════════════════╝  │
│                                        │                                       │
│                                        ▼                                       │
│  ╔═══════════════════════════════════════════════════════════════════════╗  │
│  ║                      BUSINESS LOGIC LAYER                             ║  │
│  ║  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐  ║  │
│  ║  │ Command │   │  Query  │   │Session  │   │  Tool   │   │ Permission│║  │
│  ║  │ Handler│──▶│ Engine  │──▶│ Manager │──▶│Executor │──▶│  System  │  ║  │
│  ║  └─────────┘   └────┬────┘   └─────────┘   └─────────┘   └─────────┘  ║  │
│  ║                    │                                                  ║  │
│  ║              ┌─────┴─────┐                                           ║  │
│  ║              │  Context  │                                           ║  │
│  ║              │ Manager   │                                           ║  │
│  ║              └───────────┘                                           ║  │
│  ╚═══════════════════════════════════════════════════════════════════════╝  │
│                                        │                                       │
│                                        ▼                                       │
│  ╔═══════════════════════════════════════════════════════════════════════╗  │
│  ║                            API LAYER                                   ║  │
│  ║  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐  ║  │
│  ║  │ Claude  │   │  Auth   │   │  Error  │   │  Rate   │   │  Token  │  ║  │
│  ║  │API Client│──▶│OAuth/Key│──▶│ Handler │──▶│ Limiter │──▶│ Estimat.│  ║  │
│  ║  └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘  ║  │
│  ╚═══════════════════════════════════════════════════════════════════════╝  │
│                                        │                                       │
│                                        ▼                                       │
│  ╔═══════════════════════════════════════════════════════════════════════╗  │
│  ║                     PROVIDER INTEGRATION                               ║  │
│  ║                                                                       ║  │
│  ║   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐              ║  │
│  ║   │  Anthropic  │   │     AWS     │   │   Google    │   ┌────────┐ ║  │
│  ║   │ (FirstParty)│   │   Bedrock   │   │   Vertex    │   │ Azure  │ ║  │
│  ║   │             │   │             │   │             │   │Foundry │ ║  │
│  ║   └─────────────┘   └─────────────┘   └─────────────┘   └────────┘  ║  │
│  ╚═══════════════════════════════════════════════════════════════════════╝  │
│                                                                               │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Core Workflow

```
╔═════════════════════════════════════════════════════════════════════════════╗
║                         INITIALIZATION FLOW                                   ║
╚═════════════════════════════════════════════════════════════════════════════╝

                           ┌──────────────────┐
                           │   CLI Entry      │
                           │   (cli.js)       │
                           └────────┬─────────┘
                                    │
                                    ▼
                           ┌──────────────────┐
                           │   Bootstrap      │
                           │   & Config Load  │
                           └────────┬─────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │      showSetupScreens()       │
                    │  ┌─────────────────────────┐  │
                    │  │   Configuration Check  │  │
                    │  │                        │  │
                    │  │  ┌──────────────────┐  │  │
                    │  │  │theme configured? │  │  │
                    │  │  └────────┬─────────┘  │  │
                    │  │           │            │  │
                    │  │  ┌────────▼─────────┐  │  │
                    │  │  │model configured? │  │  │
                    │  │  │ (isModelConfigured│  │  │
                    │  │  └────────┬─────────┘  │  │
                    │  │           │            │  │
                    │  │  ┌────────▼─────────┐  │  │
                    │  │  │onboarding complete│  │  │
                    │  │  └────────┬─────────┘  │  │
                    │  └─────────────────────────┘  │
                    └────────────┬──────────────────┘
                                 │
              ┌──────────────────┴──────────────────┐
              │                                      │
              ▼                                      ▼
    ┌─────────────────────┐              ┌─────────────────────┐
    │    FIRST LAUNCH     │              │ ALREADY CONFIGURED │
    │                     │              │                     │
    │  ┌───────────────┐  │              │  ┌───────────────┐  │
    │  │  Onboarding   │──┼──────────────┼─▶│  Main Loop    │  │
    │  │   Wizard     │  │              │  │   (REPL UI)   │  │
    │  └───────┬───────┘  │              │  └───────────────┘  │
    │          │          │              │         │          │
    │          ▼          │              │         ▼          │
    │  ┌───────────────┐  │              │  Waiting for       │
    │  │ 1. Theme      │  │              │  user input...     │
    │  │ 2. Model Setup│◄─┼── NEW        │                     │
    │  │ 3. Security   │  │              │                     │
    │  └───────────────┘  │              │                     │
    └─────────────────────┘              └─────────────────────┘
```

---

## 🔧 Model Configuration System

```
╔═════════════════════════════════════════════════════════════════════════════╗
║                    MODEL SELECTION PRIORITY CHAIN                            ║
╚═════════════════════════════════════════════════════════════════════════════╝

  Priority    Source              Example
  ─────────   ──────              ────────
     1        /model cmd          /model opus
     2        CLI --model          --model sonnet
     3        ENV variable         ANTHROPIC_MODEL=haiku
     4        settings.json        { "model": "claude-opus-4-6" }
     5        Built-in default     Sonnet 4.6

  ┌─────────────────────────────────────────────────────────────────────────┐
  │  Model Resolution Flow                                                  │
  │                                                                         │
  │  getUserSpecifiedModelSetting()                                        │
  │         │                                                               │
  │         ▼                                                               │
  │  ┌──────────────────────────────┐                                     │
  │  │ 1. getMainLoopModelOverride()│──▶ /model command (runtime)           │
  │  └──────────────┬───────────────┘                                     │
  │                 │                                                       │
  │                 ▼                                                       │
  │  ┌──────────────────────────────┐                                     │
  │  │ 2. ANTHROPIC_MODEL env       │                                     │
  │  └──────────────┬───────────────┘                                     │
  │                 │                                                       │
  │                 ▼                                                       │
  │  ┌──────────────────────────────┐                                     │
  │  │ 3. settings.model            │                                     │
  │  └──────────────┬───────────────┘                                     │
  │                 │                                                       │
  │                 ▼                                                       │
  │  ┌──────────────────────────────┐                                     │
  │  │ 4. getDefaultMainLoopModel() │──▶ Built-in default                 │
  │  └──────────────────────────────┘                                     │
  │                 │                                                       │
  │                 ▼                                                       │
  │         ┌───────────────┐                                             │
  │         │Final Model ID │                                             │
  │         └───────────────┘                                             │
  └─────────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 Custom Model & Provider Configuration

```
╔═════════════════════════════════════════════════════════════════════════════╗
║                     PROVIDER INTEGRATION ARCHITECTURE                         ║
╚═════════════════════════════════════════════════════════════════════════════╝

┌──────────────────────────────────────────────────────────────────────────────┐
│                        Provider Selection Flow                               │
└──────────────────────────────────────────────────────────────────────────────┘

          Environment Variables              Model Config Resolution
          ──────────────────────             ────────────────────────

     ┌────────────────────────┐         ┌──────────────────────────────────┐
     │ CLAUDE_CODE_USE_BEDROCK│         │ ALL_MODEL_CONFIGS                │
     └───────────┬────────────┘         │ {                                │
                 │                     │   opus46: {                      │
                 ▼                     │     firstParty: 'claude-opus-4-6'│
     ┌────────────────────────┐         │     bedrock: 'us.anthropic.    │
     │        Provider        │         │           claude-opus-4-6-v1:0' │
     │   ┌─────────────────┐  │         │     vertex: 'claude-opus-4-6'   │
     │   │ AWS Bedrock    │◄─┼─────────│     foundry: 'claude-opus-4-6'   │
     │   └─────────────────┘  │         │   },                             │
     └────────────────────────┘         │   sonnet46: { ... },             │
                                       │   haiku45: { ... }               │
     ┌────────────────────────┐         │ }                                │
     │ CLAUDE_CODE_USE_VERTEX│         └──────────────────────────────────┘
     └───────────┬────────────┘                   │
                 │                                 │
                 ▼                                 ▼
     ┌────────────────────────┐         ┌─────────────────────────────┐
     │        Provider        │         │    API Call Construction   │
     │   ┌─────────────────┐  │         │                             │
     │   │ Google Vertex  │◄─┼─────────│ ┌─────────────────────────┐ │
     │   └─────────────────┘  │         │ │ base URL + model ID +   │ │
     └────────────────────────┘         │ │ auth headers            │ │
                                       │ └─────────────────────────┘ │
     ┌────────────────────────┐         └─────────────────────────────┘
     │ CLAUDE_CODE_USE_FOUNDRY│
     └───────────┬────────────┘
                 │
                 ▼
     ┌────────────────────────┐
     │        Provider        │
     │   ┌─────────────────┐  │
     │   │ Azure Foundry  │◄─┴──────┐
     │   └─────────────────┘         │
     └────────────────────────┘       │
                                    │
                                    ▼
                         ┌────────────────────────┐
                         │    Provider-Specific   │
                         │    Model Resolution    │
                         └────────────────────────┘
```

---

```
╔═════════════════════════════════════════════════════════════════════════════╗
║                     CUSTOM MODEL CONFIGURATION FLOW                          ║
╚═════════════════════════════════════════════════════════════════════════════╝

  User Input: "custom-model" or environment variables
                     │
                     ▼
  ┌───────────────────────────────────────────────────────────────────────────┐
  │                     parseUserSpecifiedModel()                            │
  │                                                                           │
  │  ┌─────────────────────────────────────────────────────────────────────┐  │
  │  │  Step 1: Alias Resolution                                         │  │
  │  │                                                                    │  │
  │  │  'opus'  ──────────▶  getDefaultOpusModel()  ────▶ 'claude-opus-4-6'│
  │  │  'sonnet' ──────────▶ getDefaultSonnetModel() ────▶ 'claude-sonnet-4-6'│
  │  │  'haiku'  ──────────▶ getDefaultHaikuModel()  ────▶ 'claude-haiku-4-5'│
  │  │  'best'   ──────────▶ getBestModel()         ────▶ 'claude-opus-4-6'│
  │  │  'custom' ──────────▶ passthrough (custom model name)               │
  │  └─────────────────────────────────────────────────────────────────────┘  │
  │                                    │                                      │
  │                                    ▼                                      │
  │  ┌─────────────────────────────────────────────────────────────────────┐  │
  │  │  Step 2: Context Suffix Handling                                   │  │
  │  │                                                                    │  │
  │  │  'opus[1m]' ──▶ strip '[1m]' ──▶ has1mContext() ──▶ 1M context     │  │
  │  │  'sonnet'   ──▶ no suffix ──▶ 200K context                        │  │
  │  └─────────────────────────────────────────────────────────────────────┘  │
  │                                    │                                      │
  │                                    ▼                                      │
  │  ┌─────────────────────────────────────────────────────────────────────┐  │
  │  │  Step 3: Provider Mapping                                          │  │
  │  │                                                                    │  │
  │  │  getAPIProvider() ──▶ firstParty/bedrock/vertex/foundry           │  │
  │  │                                                                    │  │
  │  │  if bedrock:    convert to Bedrock ARN format                    │  │
  │  │  if vertex:     convert to Vertex model string                   │  │
  │  │  if foundry:   use as Foundry deployment ID                     │  │
  │  │  if firstParty: use as-is (claude-opus-4-6)                      │  │
  │  └─────────────────────────────────────────────────────────────────────┘  │
  └───────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
  ┌───────────────────────────────────────────────────────────────────────────┐
  │                     Final API Request                                     │
  │                                                                           │
  │   Provider: Anthropic (firstParty)                                       │
  │   Model:    claude-opus-4-6                                             │
  │   URL:      https://api.anthropic.com/v1/messages                        │
  │   Headers: { x-api-key: ANTHROPIC_API_KEY, anthropic-version: 2023-06-01}│
  │   Body:     { model: "claude-opus-4-6", messages: [...], max_tokens: 4096}│
  └───────────────────────────────────────────────────────────────────────────┘
```

---

## 🔬 State Management Architecture

```
╔═════════════════════════════════════════════════════════════════════════════╗
║                        STATE MANAGEMENT LAYERS                               ║
╚═════════════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────────────────────────────────────────────────────┐
  │                          APP STATE (In-Memory)                             │
  │  ┌────────────────────────────────────────────────────────────────────────┐ │
  │  │  useAppState()                                                        │ │
  │  │  ┌─────────────┬─────────────┬─────────────┬─────────────┐          │ │
  │  │  │mainLoopModel│mainLoopModel│  isFastMode │ permissions  │          │ │
  │  │  │             │ ForSession  │             │              │          │ │
  │  │  └─────────────┴─────────────┴─────────────┴─────────────┘          │ │
  │  │         │                │               │              │             │ │
  │  │         └────────────────┴───────────────┴──────────────┘             │ │
  │  │                          │                                          │ │
  │  │                          ▼                                          │ │
  │  │                   ┌───────────┐                                   │ │
  │  │                   │  Session  │                                   │ │
  │  │                   │   State   │                                   │ │
  │  │                   └───────────┘                                   │ │
  │  └────────────────────────────────────────────────────────────────────────┘ │
  └────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
  ┌────────────────────────────────────────────────────────────────────────────┐
  │                       GLOBAL CONFIG (Persistent)                          │
  │  ┌────────────────────────────────────────────────────────────────────────┐ │
  │  │  saveGlobalConfig()                                                     │ │
  │  │  ┌────────────────┬────────────────┬────────────────┬────────────┐  │ │
  │  │  │theme          │hasCompleted    │hasCompleted    │oauthAccount│  │ │
  │  │  │               │Onboarding      │ModelSetup ◄NEW │            │  │ │
  │  │  └────────────────┴────────────────┴────────────────┴────────────┘  │ │
  │  └────────────────────────────────────────────────────────────────────────┘ │
  └────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
  ┌────────────────────────────────────────────────────────────────────────────┐
  │                          SETTINGS (settings.json)                         │
  │  ┌────────────────────────────────────────────────────────────────────────┐ │
  │  │  updateSettingsForSource()                                             │ │
  │  │  ┌───────────────┬──────────────┬──────────────┬──────────────┐     │ │
  │  │  │ model        │ allowedMcp    │ permissions  │ hooks        │     │ │
  │  │  │ "claude-opus"│ Servers      │ allow/deny   │ pre/post     │     │ │
  │  │  └───────────────┴──────────────┴──────────────┴──────────────┘     │ │
  │  └────────────────────────────────────────────────────────────────────────┘ │
  └────────────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Installation

### One-Click Installation

#### macOS / Linux
```bash
curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.sh | bash
```

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 | iex
```

#### Termux (Android)
```bash
curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install-termux.sh | bash
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode

# Install dependencies
npm install

# Start
node recode-temp/package/cli.js
```

### NPM Installation

```bash
# Global installation
npm install -g @recode/cli

# Run
recode
```

---

## 💻 Usage Guide

### First Launch Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           FIRST LAUNCH FLOW                                   │
└──────────────────────────────────────────────────────────────────────────────┘

     ┌──────────────┐
     │   Welcome    │
     │    Screen   │
     └──────┬───────┘
            │
            ▼
     ┌──────────────┐
     │   Theme     │  ◄── Step 1: Choose your preferred color theme
     │  Selection  │
     └──────┬───────┘
            │
            ▼
     ┌──────────────┐
     │    Model    │  ◄── Step 2: SELECT YOUR MODEL (REQUIRED) ⭐
     │  Picker     │
     │             │
     │ ┌────────┐  │
     │ │Opus 4.6│  │
     │ ├────────┤  │
     │ │Sonnet 4│◄─┼─── Select model and press Enter
     │ ├────────┤  │
     │ │ Haiku  │  │
     │ └────────┘  │
     └──────┬───────┘
            │
            ▼
     ┌──────────────┐
     │   Security   │  ◄── Step 3: Review security notes
     │    Notes    │
     └──────┬───────┘
            │
            ▼
     ┌──────────────┐
     │ Main Loop    │  ◄── Step 4: Ready to use!
     │   (REPL)    │
     └──────────────┘
```

### Commands

| Command | Description |
|---------|-------------|
| `/help` | Display help information |
| `/model` | Switch AI model |
| `/config` | View/modify configuration |
| `/clear` | Clear current session |
| `/exit` | Exit program |

### Environment Variables

```bash
# API Configuration
ANTHROPIC_API_KEY=your-key          # API authentication
ANTHROPIC_BASE_URL=custom-endpoint  # Custom API URL
ANTHROPIC_MODEL=model-name          # Specify model

# Provider Selection
CLAUDE_CODE_USE_BEDROCK=1           # Use AWS Bedrock
CLAUDE_CODE_USE_VERTEX=1             # Use Google Vertex
CLAUDE_CODE_USE_FOUNDRY=1           # Use Azure Foundry
```

---

## 🗂️ Project Structure

```
ReCode/
├── src/
│   ├── components/              # React UI components
│   │   ├── Onboarding.tsx       # First-launch wizard
│   │   ├── ModelPicker.tsx      # Model selection UI
│   │   └── REPL.tsx            # Main chat interface
│   ├── services/api/            # API client layer
│   ├── utils/
│   │   ├── model/               # Model configuration
│   │   │   ├── model.ts         # Model selection logic
│   │   │   ├── configs.ts       # Model configs
│   │   │   ├── providers.ts     # Provider resolution
│   │   │   └── validateModel.ts
│   │   ├── settings/            # User preferences
│   │   └── config.ts           # Global config
│   └── commands/                # CLI commands
├── recode-temp/package/         # NPM package
├── install.sh                   # macOS/Linux installer
├── install.ps1                  # Windows installer
├── install-termux.sh            # Termux installer
└── README.md
```

---

## 🤝 Contributing

```bash
# Fork the repository
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git

# Create your feature branch
git checkout -b feature/amazing

# Commit your changes
git commit -m 'Add amazing feature'

# Push to the branch
git push origin feature/amazing
```

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details.

---

<p align="center">Made with ❤️ by ReCode Team</p>