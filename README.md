# ReCode 🚀

<p align="center">
  <img src="https://img.shields.io/badge/version-3.0.1-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux%7C-Termux-green.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License">
  <img src="https://img.shields.io/badge/node-%3E%3D18.0.0-yellow.svg" alt="Node Version">
</p>

> **ReCode** — A powerful code agent—writing code is just the basics!

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

```mermaid
flowchart TB
    subgraph Presentation["🎨 PRESENTATION LAYER"]
        OB["📝 Onboarding"]
        MP["🤖 ModelPicker"]
        REPL["💬 REPL UI"]
        SET["⚙️ Settings"]
        THEME["🎨 ThemePicker"]
    end

    subgraph Business["⚡ BUSINESS LOGIC LAYER"]
        CMD["📋 Command Handler"]
        QE["🔍 Query Engine"]
        SESSION["💾 Session Manager"]
        TOOL["🔧 Tool Executor"]
        PERM["🛡️ Permission System"]
    end

    subgraph API["🌐 API LAYER"]
        CLIENT["📡 Claude API"]
        AUTH["🔐 Auth/OAuth"]
        ERROR["❌ Error Handler"]
        RATE["📊 Rate Limiter"]
    end

    subgraph Provider["☁️ PROVIDER INTEGRATION"]
        ANT[" Anthropic<br/>FirstParty"]
        BEDROCK["☁️ AWS<br/>Bedrock"]
        VERTEX["🌐 Google<br/>Vertex"]
        FOUNDRY["🏢 Azure<br/>Foundry"]
    end

    OB --> MP --> REPL --> SET --> THEME
    REPL --> CMD --> QE --> SESSION --> TOOL
    TOOL --> PERM
    QE --> CLIENT --> AUTH --> ERROR --> RATE
    CLIENT --> ANT
    CLIENT --> BEDROCK
    CLIENT --> VERTEX
    CLIENT --> FOUNDRY

    style Presentation fill:#f3e8ff,stroke:#9333ea,stroke-width:2
    style Business fill:#fdf2f8,stroke:#db2777,stroke-width:2
    style API fill:#e0e7ff,stroke:#6366f1,stroke-width:2
    style Provider fill:#ecfdf5,stroke:#059669,stroke-width:2
```

---

## 🔄 Core Workflow

```mermaid
flowchart TB
    START["🚀 CLI Entry<br/>cli.js"] --> BOOT["⚙️ Bootstrap<br/>& Config Load"]
    BOOT --> CHECK{"📋 Configuration<br/>Check"}

    CHECK -->|"First Launch"| ONBOARD["📝 Onboarding<br/>Wizard"]
    CHECK -->|"Already Configured"| MAIN["💬 Main Loop<br/>REPL UI"]

    ONBOARD --> THEME["🎨 Theme<br/>Selection"]
    THEME --> MODEL["🤖 Model<br/>Configuration<br/>⭐ REQUIRED]
    MODEL --> SECURITY["🛡️ Security<br/>Notes"]
    SECURITY --> MAIN

    MODEL -.->|"Save to<br/>settings.json"| CONFIG["💾 Settings<br/>Persisted"]
    MODEL -.->|"Mark complete"| GLOB["🌍 Global Config<br/>hasCompletedModelSetup"]

    style START fill:#7c3aed,stroke:#333,stroke-width:2,color:#fff
    style CHECK fill:#f59e0b,stroke:#333,stroke-width:2,color:#000
    style ONBOARD fill:#ec4899,stroke:#333,stroke-width:2,color:#fff
    style MODEL fill:#ef4444,stroke:#333,stroke-width:3,color:#fff
    style MAIN fill:#22c55e,stroke:#333,stroke-width:2,color:#fff
```

---

## 🔧 Model Configuration System

```mermaid
flowchart LR
    subgraph Priority["📊 PRIORITY ORDER"]
        P1["1. /model cmd"]
        P2["2. --model flag"]
        P3["3. ENV variable"]
        P4["4. settings.json"]
        P5["5. Default"]
    end

    P1 -->|"Highest"| RESOLVE["🔍 Model<br/>Resolution"]
    P2 --> RESOLVE
    P3 --> RESOLVE
    P4 --> RESOLVE
    P5 -->|"Lowest"| RESOLVE

    RESOLVE --> ALIAS["📝 Alias<br/>Resolution"]
    ALIAS --> SUFFIX["🔢 [1m] Suffix<br/>Handling"]
    SUFFIX --> PROVIDER["🌍 Provider<br/>Mapping"]
    PROVIDER --> FINAL["✅ Final<br/>Model ID"]

    style Priority fill:#f3e8ff,stroke:#9333ea,stroke-width:2
    style RESOLVE fill:#fef3c7,stroke:#f59e0b,stroke-width:2
    style FINAL fill:#dcfce7,stroke:#22c55e,stroke-width:2
```

### Model Selection Priority

| Priority | Source | Example |
|----------|--------|---------|
| 1 | `/model` command | `/model opus` |
| 2 | CLI `--model` flag | `--model sonnet` |
| 3 | ENV variable | `ANTHROPIC_MODEL=haiku` |
| 4 | `settings.json` | `{ "model": "claude-opus-4-6" }` |
| 5 | Built-in default | Sonnet 4.6 |

---

## 🌍 Custom Model & Provider Configuration

```mermaid
flowchart TB
    subgraph Env["🌍 Environment Variables"]
        BEDROCK["CLAUDE_CODE_USE_BEDROCK=1"]
        VERTEX["CLAUDE_CODE_USE_VERTEX=1"]
        FOUNDRY["CLAUDE_CODE_USE_FOUNDRY=1"]
        CUSTOM["ANTHROPIC_BASE_URL=..."]
    end

    subgraph Resolution["🔄 Provider Resolution"]
        API["getAPIProvider()"]
    end

    subgraph Mapping["📊 Model String Mapping"]
        CFG["ALL_MODEL_CONFIGS"]
    end

    BEDROCK -->|"bedrock"| API
    VERTEX -->|"vertex"| API
    FOUNDRY -->|"foundry"| API
    CUSTOM -->|"firstParty"| API

    API --> CFG

    CFG -->|"bedrock"| ARN["us.anthropic.claude-opus-4-6-v1:0"]
    CFG -->|"vertex"| VERT["claude-opus-4-6@20250514"]
    CFG -->|"foundry"| FD["claude-opus-4-6"]
    CFG -->|"firstParty"| FP["claude-opus-4-6"]

    style Env fill:#e0e7ff,stroke:#6366f1,stroke-width:2
    style Resolution fill:#fef3c7,stroke:#f59e0b,stroke-width:2
    style Mapping fill:#f3e8ff,stroke:#9333ea,stroke-width:2
```

---

## 🔬 Custom Model Configuration Flow

```mermaid
flowchart TB
    INPUT["👤 User Input<br/>custom-model-name"] --> PARSE["📝 parseUserSpecifiedModel()"]

    subgraph Step1["Step 1: Alias Resolution"]
        OPUS["'opus' → getDefaultOpusModel()"]
        SONNET["'sonnet' → getDefaultSonnetModel()"]
        HAIKU["'haiku' → getDefaultHaikuModel()"]
        CUSTOM["'custom' → passthrough"]
    end

    subgraph Step2["Step 2: Context Suffix"]
        CONTEXT["'model[1m]' → has1mContext()"]
    end

    subgraph Step3["Step 3: Provider Mapping"]
        PROVIDER["getAPIProvider()"]
    end

    PARSE --> Step1
    Step1 --> CONTEXT
    CONTEXT --> PROVIDER

    PROVIDER -->|"firstParty"| FP["claude-opus-4-6"]
    PROVIDER -->|"bedrock"| BED["AWS ARN format"]
    PROVIDER -->|"vertex"| VRT["Vertex model string"]
    PROVIDER -->|"foundry"| FD["Foundry deployment ID"]

    FP --> API["📡 API Call"]
    BED --> API
    VRT --> API
    FD --> API

    style INPUT fill:#ec4899,stroke:#333,stroke-width:2,color:#fff
    style Step1 fill:#f3e8ff,stroke:#9333ea,stroke-width:2
    style Step2 fill:#fdf2f8,stroke:#db2777,stroke-width:2
    style Step3 fill:#e0e7ff,stroke:#6366f1,stroke-width:2
    style API fill:#dcfce7,stroke:#22c55e,stroke-width:2
```

---

## 📊 State Management Architecture

```mermaid
flowchart TB
    subgraph AppState["💾 APP STATE (In-Memory)"]
        MODEL["🤖 mainLoopModel"]
        FAST["⚡ isFastMode"]
        PERM["🛡️ permissions"]
        SESSION["💬 session"]
    end

    subgraph GlobalConfig["🌍 GLOBAL CONFIG (Persistent)"]
        THEME["🎨 theme"]
        ONBOARD["✅ hasCompletedOnboarding"]
        MODELSET["✅ hasCompletedModelSetup ⭐"]
        OAUTH["🔐 oauthAccount"]
    end

    subgraph Settings["📁 SETTINGS (settings.json)"]
        SMODEL["🤖 model: 'claude-opus-4-6'"]
        MCP["🔌 allowedMcpServers"]
        PERMRULES["📋 permissions allow/deny"]
        HOOKS["🪝 hooks pre/post"]
    end

    AppState -->|"runtime"| GlobalConfig
    GlobalConfig -->|"persistent"| Settings

    style AppState fill:#fef3c7,stroke:#f59e0b,stroke-width:2
    style GlobalConfig fill:#f3e8ff,stroke:#9333ea,stroke-width:2
    style Settings fill:#dcfce7,stroke:#22c55e,stroke-width:2
```

---

## 📦 Installation

### One-Click Installation

```mermaid
flowchart LR
    subgraph Platforms["🖥️ Platforms"]
        MAC["🍎 macOS<br/>Linux"]
        WIN["🪟 Windows"]
        TERMUX["📱 Termux"]
    end

    MAC -->|"curl|bash"| CMD1["recode"]
    WIN -->|"PowerShell"| CMD2["recode"]
    TERMUX -->|"curl|bash"| CMD3["recode"]

    CMD1 --> RUN["✅ Running"]
    CMD2 --> RUN
    CMD3 --> RUN

    style Platforms fill:#f3e8ff,stroke:#9333ea,stroke-width:2
    style RUN fill:#dcfce7,stroke:#22c55e,stroke-width:3
```

| Platform | Command |
|----------|---------|
| **macOS / Linux** | `curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.sh \| bash` |
| **Windows** | `irm https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 \| iex` |
| **Termux** | `curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install-termux.sh \| bash` |

### NPM Installation

```bash
npm install -g @recode/cli
recode
```

---

## 💻 First Launch Flow

```mermaid
flowchart TB
    START["👋 Welcome<br/>Screen"] --> THEME["🎨 Theme<br/>Selection"]
    THEME --> MODEL["🤖 MODEL<br/>SELECTION ⭐<br/>REQUIRED"]
    MODEL -->|"Save to<br/>settings.json"| SAVE["💾 Model<br/>Saved"]
    SAVE -->|"Mark complete"| DONE["✅ hasCompleted<br/>ModelSetup=true"]
    DONE --> SECURITY["🛡️ Security<br/>Notes"]
    SECURITY --> REPL["💬 Main Loop<br/>Ready to Use!"]

    style START fill:#7c3aed,stroke:#333,stroke-width:2,color:#fff
    style THEME fill:#ec4899,stroke:#333,stroke-width:2,color:#fff
    style MODEL fill:#ef4444,stroke:#333,stroke-width:4,color:#fff
    style DONE fill:#22c55e,stroke:#333,stroke-width:2,color:#fff
    style REPL fill:#22c55e,stroke:#333,stroke-width:3,color:#fff
```

### Environment Variables

```mermaid
flowchart LR
    subgraph Config["🔧 Configuration"]
        KEY["ANTHROPIC_API_KEY"]
        URL["ANTHROPIC_BASE_URL"]
        MODEL["ANTHROPIC_MODEL"]
        PROVIDER["CLAUDE_CODE_USE_*"]
    end

    Config -->|"sets"| ENV["🌍 Environment"]
    ENV -->|"uses"| API["📡 API Client"]

    style Config fill:#e0e7ff,stroke:#6366f1,stroke-width:2
    style ENV fill:#fef3c7,stroke:#f59e0b,stroke-width:2
    style API fill:#dcfce7,stroke:#22c55e,stroke-width:2
```

```bash
# API Configuration
ANTHROPIC_API_KEY=your-key          # API authentication
ANTHROPIC_BASE_URL=custom-endpoint  # Custom API URL
ANTHROPIC_MODEL=model-name          # Specify model

# Provider Selection
CLAUDE_CODE_USE_BEDROCK=1           # Use AWS Bedrock
CLAUDE_CODE_USE_VERTEX=1             # Use Google Vertex
CLAUDE_CODE_USE_FOUNDRY=1            # Use Azure Foundry
```

---

## Commands

| Command | Description |
|---------|-------------|
| `/help` | Display help information |
| `/model` | Switch AI model |
| `/config` | View/modify configuration |
| `/clear` | Clear current session |
| `/exit` | Exit program |

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
