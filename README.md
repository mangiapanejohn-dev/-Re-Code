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

<p align="center">
  <strong>
    <a href="README.md">English</a> | 
    <a href="README_CN.md">中文</a>
  </strong>
</p>

---

## 🛡️ What is RE CODE?

**RE CODE** is an open-source Claude API client designed to solve the Claude account ban problem.

### 🔍 Why Claude Gets Banned

Claude has an internal monitoring system codenamed **"Tango Tengu"** that collects:

| Monitoring Dimension | Data Collected |
|:---|:---|
| Behavior Data | Every action: file operations, command execution |
| Device Fingerprinting | 40+ dimensions of device information |
| User Tracking | Users assigned to 30 "buckets" for tracking |

### ⚠️ Ban Trigger Conditions

| Risk Level | Trigger |
|:---:|:---|
| 🔴 Critical | Shared accounts, third-party clients |
| 🟠 High | API rate limiting violations |
| 🟡 Medium | Frequent IP geo-hopping, mismatched payment info |

---

## ✨ RE CODE Advantages - Solve Claude Ban Issue

| Feature | Description |
|:---|:---|
| 🛡️ **Anti-Ban** | Hide device fingerprint, bypass Tango Tengu monitoring |
| 🔒 **Privacy** | Disable telemetry, full data control |
| 🌐 **Custom Endpoints** | Self-hosted proxy support, hide real IP |
| 🚀 **Stable** | Dedicated infrastructure, avoid rate limit triggers |
| 🔧 **Flexible** | Custom API endpoints and models |
| 🌍 **Cross-Platform** | Windows / macOS / Linux / Termux |

---

## ⚙️ Working Principle

```
┌─────────────────────────────────────────────────────────────┐
│                    RE CODE Architecture                      │
└─────────────────────────────────────────────────────────────┘

  ┌──────────┐     ┌─────────────┐     ┌──────────────────┐
  │  User    │────▶│   Tunnel    │────▶│  Proxy Server    │
  │  Input   │     │  Encryption │     │  (Obfuscation)   │
  └──────────┘     └─────────────┘     └──────────────────┘
                                                │
                                                ▼
                                        ┌──────────────────┐
                                        │  Claude API      │
                                        │  (Anthropic)     │
                                        └──────────────────┘
```

### Core Technologies

| Technology | Implementation |
|:---|:---|
| 🔀 **Request Obfuscation** | Randomize device fingerprints, vary request patterns |
| 🕵️ **Traffic Anonymization** | Multiple exit nodes, residential IP proxies |
| 📡 **Protocol Tunneling** | Encrypted channel, bypass direct API detection |
| 🔐 **Key Isolation** | Local API key storage, never expose to third-party |

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

## ⚙️ Privacy Configuration

```bash
# Disable telemetry (reduce data collection)
export DISABLE_TELEMETRY=1

# Use custom API endpoint
export ANTHROPIC_BASE_URL=https://your-proxy.com

# Use your own API key
export ANTHROPIC_API_KEY=sk-xxx
```

---

## 📖 Usage

| Command | Description |
|:---|:---|
| `recode` | Start RE CODE |
| `recode -v` | Show version |
| `/model [name]` | Switch model (opus/sonnet/haiku) |
| `/config` | View/edit configuration |
| `/clear` | Clear session |
| `/exit` | Exit |

---

## 🏗️ Project Structure

```
ReCode/
├── src/                    # Source code
│   ├── commands/           # CLI commands
│   ├── components/         # UI components
│   ├── utils/              # Utilities
│   └── tools/              # Built-in tools
├── recode-temp/package/   # Packaged CLI
├── install.sh              # macOS/Linux installer
├── install.ps1             # Windows installer
├── install-termux.sh       # Termux installer
└── README.md               # This file
```

---

## 🤝 Contributing

```bash
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode
git checkout -b feature/your-feature
git commit -m 'Add awesome feature'
git push origin feature/your-feature
```

---

## 📄 License

MIT License - See [LICENSE](LICENSE)

---

<p align="center">
  Made with 💜 by <a href="https://github.com/mangiapanejohn-dev">ReCode Team</a>
</p>