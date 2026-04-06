# RE CODE 👾

<p align="center">
  <a href="https://github.com/mangiapanejohn-dev/-Re-Code/stargazers">
    <img src="https://img.shields.io/github/stars/mangiapanejohn-dev/-Re-Code?style=flat-square&logo=github" alt="Stars">
  </a>
  <a href="https://github.com/mangiapanejohn-dev/-Re-Code/forks">
    <img src="https://img.shields.io/github/forks/mangiapanejohn-dev/-Re-Code?style=flat-square&logo=github" alt="Forks">
  </a>
  <img src="https://img.shields.io/badge/version-3.0.2-purple?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Termux-pink?style=flat-square" alt="Platforms">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License">
  </a>
</p>

---

## ✨ Features

| Feature | Description |
|:---:|:---|
| 🤖 **Multi-Model** | Claude Opus / Sonnet / Haiku + Custom Models |
| 🔧 **Configurable** | Model selection, API endpoints, environment variables |
| 🌐 **Multi-Provider** | Anthropic, AWS Bedrock, Google Vertex, Azure |
| 💻 **Cross-Platform** | Windows, macOS, Linux, Termux |
| 🛡️ **Enterprise** | Permissions, workspace trust |

---

## 🚀 Quick Install

### macOS / Linux
```bash
curl -fsSL https://cdn.jsdelivr.net/gh/mangiapanejohn-dev/-Re-Code/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm -useb https://cdn.jsdelivr.net/gh/mangiapanejohn-dev/-Re-Code/install.ps1 | iex
```

### Termux
```bash
curl -fsSL https://cdn.jsdelivr.net/gh/mangiapanejohn-dev/-Re-Code/install-termux.sh | bash
```

---

## 📖 Usage

### Basic Commands

| Command | Description |
|:---|:---|
| `recode` | Start RE CODE |
| `recode -v` | Show version |
| `recode --help` | Show help |

### Slash Commands

| Command | Description |
|:---|:---|
| `/help` | Show help |
| `/model [name]` | Switch model (opus, sonnet, haiku) |
| `/config` | View/edit configuration |
| `/clear` | Clear session |
| `/exit` | Exit |

---

## ⚙️ Configuration

### Environment Variables

```bash
# API Configuration
ANTHROPIC_API_KEY=your-api-key
ANTHROPIC_MODEL=claude-sonnet-4-20250514

# Alternative Providers
ANTHROPIC_BASE_URL=custom-endpoint

# Provider Selection
CLAUDE_CODE_USE_BEDROCK=1
CLAUDE_CODE_USE_VERTEX=1
CLAUDE_CODE_USE_FOUNDRY=1
```

### Model Priority

```
1. /model command    → Highest priority
2. --model flag
3. ENV variable      → ANTHROPIC_MODEL=xxx
4. settings.json
5. Default           → Sonnet 4.6
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│            Presentation Layer              │
│   Onboarding → ModelPicker → REPL → TUI    │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│           Business Logic Layer              │
│    Commands → Query Engine → Tools         │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│               API Layer                     │
│      Claude API → Auth → Errors            │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│         Provider Integration                │
│   Anthropic │ Bedrock │ Vertex │ Foundry   │
└─────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
ReCode/
├── src/
│   ├── components/          # React UI
│   │   ├── Onboarding.tsx
│   │   ├── ModelPicker.tsx
│   │   └── REPL.tsx
│   ├── utils/              # Utilities
│   │   ├── config/         # Configuration
│   │   └── settings/       # User settings
│   ├── commands/           # CLI commands
│   ├── tools/              # Built-in tools
│   └── skills/             # Custom skills
├── recode-temp/package/    # Built CLI
├── install.sh              # macOS/Linux
├── install.ps1             # Windows
├── install-termux.sh      # Termux
└── README.md              # This file
```

---

## 🤝 Contributing

```bash
# Clone the repository
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode

# Create a feature branch
git checkout -b feature/awesome-feature

# Make your changes
# ...

# Commit and push
git add .
git commit -m 'Add awesome feature'
git push origin feature/awesome-feature
```

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with 💜 by <a href="https://github.com/mangiapanejohn-dev">ReCode Team</a>
</p>

<p align="center">
  <img src="https://komarev.com/ghpvc/?username=mangiapanejohn-dev&label=Profile%20Views&color=purple&style=flat-square" alt="Profile views">
</p>