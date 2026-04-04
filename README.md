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
┌─────────────────────────────────────────────────────────────────────────────┐
│                                    ReCode                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐    │
│  │                         PRESENTATION LAYER                          │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐  │    │
│  │  │  Onboarding │  │ ModelPicker │  │    REPL     │  │ Settings │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘  │    │
│  │       (React + Ink Terminal UI Framework)                          │    │
│  └────────────────────────────────────────────────────────────────────┘    │
│                                    │                                         │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────┐    │
│  │                         BUSINESS LOGIC LAYER                        │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐  │    │
│  │  │   Command   │  │    Query    │  │   Session   │  │  Tool    │  │    │
│  │  │   Handler   │  │   Engine    │  │  Manager    │  │  Executor│  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘  │    │
│  │       /help, /model, /config, /exit                                   │    │
│  └────────────────────────────────────────────────────────────────────┘    │
│                                    │                                         │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────┐    │
│  │                            API LAYER                                │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐  │    │
│  │  │   Claude    │  │  Auth &      │  │   Error     │  │  Rate    │  │    │
│  │  │   API Client│  │  OAuth       │  │  Handling   │  │  Limiter │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘  │    │
│  └────────────────────────────────────────────────────────────────────┘    │
│                                    │                                         │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────┐    │
│  │                     PROVIDER INTEGRATION                           │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐  │    │
│  │  │  Anthropic  │  │    AWS      │  │   Google    │  │  Azure   │  │    │
│  │  │  (FirstParty)│  │  Bedrock   │  │   Vertex    │  │  Foundry │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘  │    │
│  └────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Core Workflow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            INITIALIZATION FLOW                              │
└─────────────────────────────────────────────────────────────────────────────┘

    ┌──────────────┐
    │   CLI Entry  │
    │  (cli.js)    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │   Bootstrap  │
    │  & Config    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────────────────────────────────┐
    │         showSetupScreens()               │
    │  ┌────────────────────────────────────┐  │
    │  │  Config Check:                       │  │
    │  │  • hasCompletedOnboarding           │  │
    │  │  • hasCompletedModelSetup  ◄── NEW │  │
    │  │  • theme configured                 │  │
    │  └────────────────────────────────────┘  │
    └──────┬───────────────────────────────────┘
           │
     ┌─────┴─────────────────────────────────────────────┐
     │                                                   │
     ▼                                                   ▼
┌───────────────────┐                           ┌───────────────────┐
│   FIRST LAUNCH   │                           │  ALREADY CONFIGURED│
│                   │                           │                    │
│ 1. Onboarding    │                           │  Main Loop (REPL) │
│    - Theme        │                           │                    │
│    - Model Setup  │◄─── NEW: ModelPicker     │  Waiting for      │
│    - Security     │      + Settings Save     │  user input...    │
│                   │                           │                    │
└───────────────────┘                           └───────────────────┘
```

---

## 🔧 Model Configuration System

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        MODEL SELECTION & CONFIGURATION                        │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────┐      ┌─────────────────────────────┐
│     Configuration Sources    │      │    Priority Order          │
├─────────────────────────────┤      ├─────────────────────────────┤
│ 1. /model command (runtime) │      │ 1. /model (runtime)        │
│ 2. --model CLI flag         │─────▶│ 2. --model (startup)       │
│ 3. ANTHROPIC_MODEL env       │      │ 3. ANTHROPIC_MODEL env      │
│ 4. settings.json (global)   │      │ 4. settings.json            │
│ 5. Default (Sonnet 4.6)     │      │ 5. Built-in default         │
└─────────────────────────────┘      └─────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                        MODEL CONFIG STRUCTURE                               │
└─────────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │  export const ALL_MODEL_CONFIGS = {                         │
  │    opus46: { firstParty: 'claude-opus-4-6', ... },          │
  │    sonnet46: { firstParty: 'claude-sonnet-4-6', ... },    │
  │    haiku45: { firstParty: 'claude-haiku-4-5', ... },       │
  │    // Custom models can be added via config                 │
  │  }                                                          │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │  API Providers Supported:                                   │
  │  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌─────────┐  │
  │  │ firstParty │ │  bedrock   │ │  vertex   │ │ foundry │  │
  │  │(Anthropic) │ │ (AWS)      │ │ (Google)  │ │(Azure)  │  │
  │  └────────────┘ └────────────┘ └────────────┘ └─────────┘  │
  │                                                              │
  │  Controlled via:                                             │
  │  • CLAUDE_CODE_USE_BEDROCK=1                                │
  │  • CLAUDE_CODE_USE_VERTEX=1                                  │
  │  • CLAUDE_CODE_USE_FOUNDRY=1                                │
  └─────────────────────────────────────────────────────────────┘
```

---

## 🌍 Custom Model Support

ReCode supports **any OpenAI-compatible API endpoint**. Here's how to configure:

### Using Environment Variables

```bash
# Option 1: Custom API Endpoint (OpenAI-compatible)
export ANTHROPIC_BASE_URL="https://your-custom-api.com/v1"
export ANTHROPIC_API_KEY="your-api-key"

# Option 2: Using Custom Model Name
export ANTHROPIC_MODEL="gpt-4-turbo"

# Option 3: AWS Bedrock
export CLAUDE_CODE_USE_BEDROCK=1

# Option 4: Google Vertex AI
export CLAUDE_CODE_USE_VERTEX=1

# Option 5: Azure Foundry
export CLAUDE_CODE_USE_FOUNDRY=1
```

### Configuration Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  CUSTOM MODEL RESOLUTION                        │
└─────────────────────────────────────────────────────────────────┘

     User Input (model/custom-name)
              │
              ▼
┌─────────────────────────────┐
│  parseUserSpecifiedModel() │
│  - Alias resolution         │
│  - [1m] suffix handling    │
│  - Provider mapping        │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Provider Resolution        │
│  ┌─────────────────────┐    │
│  │ getAPIProvider()   │    │
│  │ firstParty/bedrock │    │
│  │ /vertex/foundry    │    │
│  └─────────────────────┘    │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Model String Mapping       │
│  ┌─────────────────────┐    │
│  │ configs.ts          │    │
│  │ • firstParty ID     │    │
│  │ • bedrock ARN       │    │
│  │ • vertex model      │    │
│  │ • foundry deploy ID│    │
│  └─────────────────────┘    │
└─────────────┬───────────────┘
              │
              ▼
        API Call → Model Response
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

### First Launch

On first launch, the system guides you through:

1. **Theme Selection** - Choose your preferred color scheme
2. **Model Configuration** - Select your AI model (REQUIRED) ⭐
3. **Security Briefing** - Understand safe usage practices

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
ANTHROPIC_BASE_URL=custom-endpoint # Custom API URL
ANTHROPIC_MODEL=model-name         # Specify model

# Provider Selection
CLAUDE_CODE_USE_BEDROCK=1          # Use AWS Bedrock
CLAUDE_CODE_USE_VERTEX=1           # Use Google Vertex
CLAUDE_CODE_USE_FOUNDRY=1          # Use Azure Foundry
```

---

## 🗂️ Project Structure

```
ReCode/
├── src/
│   ├── components/           # React UI components
│   │   ├── Onboarding.tsx    # First-launch wizard
│   │   ├── ModelPicker.tsx   # Model selection UI
│   │   └── REPL.tsx          # Main chat interface
│   ├── services/api/         # API client layer
│   │   ├── claude.ts         # Anthropic client
│   │   └── errors.ts         # Error handling
│   ├── utils/
│   │   ├── model/            # Model configuration
│   │   │   ├── model.ts      # Model selection logic
│   │   │   ├── configs.ts    # Model configs
│   │   │   ├── providers.ts  # Provider resolution
│   │   │   └── validateModel.ts
│   │   ├── settings/         # User preferences
│   │   └── config.ts         # Global config
│   └── commands/             # CLI commands
├── recode-temp/package/
│   ├── cli.js               # Built CLI binary
│   └── package.json          # NPM package config
├── install.sh               # macOS/Linux installer
├── install.ps1              # Windows installer
├── install-termux.sh        # Termux installer
└── README.md                # This file
```

---

## 🔬 Technical Deep Dive

### State Management Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      STATE MANAGEMENT                           │
└─────────────────────────────────────────────────────────────────┘

  ┌──────────────────┐     ┌──────────────────┐
  │   App State      │     │  Global Config   │
  │  (In-Memory)     │     │   (Persistent)   │
  ├──────────────────┤     ├──────────────────┤
  │ • mainLoopModel  │     │ • theme          │
  │ • mainLoopModel  │     │ • hasCompleted   │
  │   ForSession    │     │   Onboarding     │
  │ • isFastMode    │     │ • hasCompleted   │
  │ • session       │     │   ModelSetup     │
  │ • permissions   │     │ • oauthAccount   │
  └────────┬─────────┘     └────────┬─────────┘
           │                        │
           └────────┬───────────────┘
                    │
                    ▼
        ┌─────────────────────────┐
        │    Settings Layer       │
        │   (settings.json)       │
        │ • model: "claude-opus"  │
        │ • allowedMcpServers    │
        │ • permissions          │
        └─────────────────────────┘
```

### API Request Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      API REQUEST FLOW                           │
└─────────────────────────────────────────────────────────────────┘

  User Input
      │
      ▼
  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
  │   Parser    │───▶│   Query     │───▶│    API      │
  │  (commands) │    │   Engine    │    │   Client    │
  └─────────────┘    └──────┬──────┘    └──────┬──────┘
                             │                  │
                             ▼                  ▼
                    ┌──────────────┐    ┌──────────────┐
                    │   Tool       │    │   Claude     │
                    │  Execution   │    │   API        │
                    └──────────────┘    └──────┬───────┘
                                                │
                                                ▼
                                       ┌──────────────┐
                                       │  Provider    │
                                       │  (Anthropic/ │
                                       │   Bedrock/   │
                                       │   Vertex/)   │
                                       └──────────────┘
```

---

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/amazing`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing`)
5. **Create** a Pull Request

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [Anthropic](https://www.anthropic.com/) - Claude API
- [Ink](https://github.com/vadimdemedes/ink) - Terminal UI framework
- All contributors and testers

---

<p align="center">Made with ❤️ by ReCode Team</p>