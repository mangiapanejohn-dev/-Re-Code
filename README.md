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

## What is RE CODE?

**RE CODE** is an open-source Claude API client designed to solve the Claude account ban problem.

### Why Claude Gets Banned

Claude has an internal monitoring system codenamed **"Tango Tengu"** that collects:

| Monitoring Dimension | Data Collected |
|:---|:---|
| Behavior Data | Every action: file operations, command execution |
| Device Fingerprinting | 40+ dimensions of device information |
| User Tracking | Users assigned to 30 "buckets" for tracking |

### Ban Trigger Conditions

| Risk Level | Trigger |
|:---:|:---|
| Critical | Shared accounts, third-party clients |
| High | API rate limiting violations |
| Medium | Frequent IP geo-hopping, mismatched payment info |

---

## RE CODE Advantages - Solve Claude Ban Issue

| Feature | Description |
|:---|:---|
| **Anti-Ban** | Hide device fingerprint, bypass Tango Tengu monitoring |
| **Privacy** | Disable telemetry, full data control |
| **Custom Endpoints** | Self-hosted proxy support, hide real IP |
| **Stable** | Dedicated infrastructure, avoid rate limit triggers |
| **Flexible** | Custom API endpoints and models |
| **Cross-Platform** | Windows / macOS / Linux / Termux |

---

## Architecture & Flow

### System Overview

```mermaid
flowchart TB
    subgraph USER_LAYER["User Layer"]
        direction LR
        CLI[CLI/TUI] --> WEB[Web UI]
        WEB --> SDK[SDK API]
    end
    
    USER_LAYER --> CLIENT_ENGINE
    
    subgraph CLIENT_ENGINE["Client Engine"]
        direction TB
        PARSE["Input Parser"] --> VALIDATE["Validator"]
        VALIDATE --> QUEUE["Request Queue"]
        QUEUE --> CONTEXT["Context Manager"]
    end
    
    CLIENT_ENGINE --> TUNNEL
    
    subgraph TUNNEL["Security Tunnel"]
        direction TB
        ENCRYPT["AES-256 Encryption"] --> COMPRESS["Payload Compression"]
        COMPRESS --> SIGNATURE["HMAC Signature"]
        SIGNATURE --> TIMING["Timing Randomizer"]
    end
    
    TUNNEL --> PROXY
    
    subgraph PROXY["Proxy Infrastructure"]
        direction TB
        LB["Global Load Balancer"] --> EDGE["Edge Nodes"]
        EDGE --> OBFS["Obfuscation Engine"]
        OBFS --> FINGERPRINT["Fingerprint Randomizer"]
        FINGERPRINT --> IP_POOL["IP Pool Manager"]
        IP_POOL --> RESIDENTIAL["Residential Proxies"]
    end
    
    PROXY --> API_GATEWAY
    
    subgraph API_GATEWAY["API Gateway"]
        direction TB
        RATE["Rate Limiter"] --> RETRY["Retry Engine"]
        RETRY --> FAILOVER["Failover Controller"]
    end
    
    API_GATEWAY --> ANTHROPIC
    
    ANTHROPIC[("Anthropic Claude API")] --> RESPONSE
    RESPONSE["Response Handler"] --> DECODE["Response Decoder"]
    DECODE --> CACHE["Context Cache"]
    CACHE --> DISPLAY["User Interface"]
    
    style USER_LAYER fill:#0f172a,stroke:#334155,stroke-width:2,color:#fff
    style CLIENT_ENGINE fill:#1e1b4b,stroke:#4338ca,stroke-width:2,color:#fff
    style TUNNEL fill:#164e63,stroke:#06b6d4,stroke-width:2,color:#fff
    style PROXY fill:#14532d,stroke:#22c55e,stroke-width:2,color:#fff
    style API_GATEWAY fill:#7c2d12,stroke:#f97316,stroke-width:2,color:#fff
    style ANTHROPIC fill:#7c3aed,stroke:#9333ea,stroke-width:3,color:#fff
    style RESPONSE fill:#4a044e,stroke:#db2777,stroke-width:2,color:#fff
```

### Request Flow

```mermaid
sequenceDiagram
    participant U as User
    participant R as RE CODE Client
    participant T as Tunnel Layer
    participant P as Proxy Network
    participant E as Exit Node
    participant A as Anthropic API
    
    U->>R: User Query
    R->>R: Parse & Validate
    R->>T: Encrypted Request
    T->>P: Obfuscate Request
    P->>E: Rotate IP Node
    E->>A: Forward Request
    
    alt Request Validation
        A->>E: Valid Response
        E->>P: Response Data
        P->>T: Decrypt Response
        T->>R: Parse Response
        R->>U: Display Result
    else Rate Limit / Ban Risk
        A->>E: Rate Limit Error
        E->>P: Auto Retry
        P->>P: Switch Exit Node
        P->>A: Retry with New IP
    end
```

### Core Components

| Component | Function | Technology |
|:---|:---|:---|
| **Client Engine** | User interaction, command parsing | React + Node.js |
| **Obfuscation Layer** | Device fingerprint randomization | Custom middleware |
| **Tunnel Protocol** | Encrypted request routing | TLS 1.3 + WireGuard |
| **Exit Node Pool** | IP rotation, residential proxies | Dynamic node management |
| **API Proxy** | Request/response transformation | Nginx + Lua scripts |

### Security Mechanisms

```mermaid
flowchart TB
    subgraph LAYER1["LAYER 1: Device Identity Obfuscation"]
        direction LR
        MAC["MAC Address Rotation"] 
        HWID["Hardware UUID Spoofing"]
        DISPLAY["Display Info Noise Injection"]
        TZ["Timezone Normalization"]
        USER_AGENT["User-Agent Rotation"]
    end
    
    LAYER1 --> LAYER2
    
    subgraph LAYER2["LAYER 2: Request Pattern Randomization"]
        direction LR
        TIMING["Request Timing Randomization"]
        SEQUENCE["Token Sequence Permutation"]
        SIZE["Payload Size Padding"]
        HEADER_SANI["Header Sanitization"]
        COOKIE["Cookie Isolation"]
    end
    
    LAYER2 --> LAYER3
    
    subgraph LAYER3["LAYER 3: Network Identity Management"]
        direction LR
        IP_POOL["Residential IP Pool"]
        GEO["Geo-Location Consistency"]
        REPUTE["IP Reputation Scoring"]
        ROTATION["Automatic IP Rotation"]
        FAILOVER["Smart Failover"]
    end
    
    LAYER3 --> LAYER4
    
    subgraph LAYER4["LAYER 4: API Key Protection"]
        direction LR
        ENCRYPTED["Local Encryption"]
        MEMORY["Memory-Only Storage"]
        ISOLATE["Process Isolation"]
        ROTATE["Key Rotation Support"]
        NEVER_EXPOSE["Never Third-Party Exposure"]
    end
    
    style LAYER1 fill:#fffbeb,stroke:#d97706,stroke-width:3,color:#000
    style LAYER2 fill:#eff6ff,stroke:#2563eb,stroke-width:3,color:#000
    style LAYER3 fill:#ecfdf5,stroke:#059669,stroke-width:3,color:#000
    style LAYER4 fill:#fdf2f8,stroke:#db2777,stroke-width:3,color:#000
    
    style MAC fill:#fef3c7,stroke:#d97706,color:#000
    style HWID fill:#fef3c7,stroke:#d97706,color:#000
    style DISPLAY fill:#fef3c7,stroke:#d97706,color:#000
    style TZ fill:#fef3c7,stroke:#d97706,color:#000
    style USER_AGENT fill:#fef3c7,stroke:#d97706,color:#000
    
    style TIMING fill:#dbeafe,stroke:#2563eb,color:#000
    style SEQUENCE fill:#dbeafe,stroke:#2563eb,color:#000
    style SIZE fill:#dbeafe,stroke:#2563eb,color:#000
    style HEADER_SANI fill:#dbeafe,stroke:#2563eb,color:#000
    style COOKIE fill:#dbeafe,stroke:#2563eb,color:#000
    
    style IP_POOL fill:#d1fae5,stroke:#059669,color:#000
    style GEO fill:#d1fae5,stroke:#059669,color:#000
    style REPUTE fill:#d1fae5,stroke:#059669,color:#000
    style ROTATION fill:#d1fae5,stroke:#059669,color:#000
    style FAILOVER fill:#d1fae5,stroke:#059669,color:#000
    
    style ENCRYPTED fill:#fce7f3,stroke:#db2777,color:#000
    style MEMORY fill:#fce7f3,stroke:#db2777,color:#000
    style ISOLATE fill:#fce7f3,stroke:#db2777,color:#000
    style ROTATE fill:#fce7f3,stroke:#db2777,color:#000
    style NEVER_EXPOSE fill:#fce7f3,stroke:#db2777,color:#000
```

---

## Quick Install

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

## Privacy Configuration

```bash
# Disable telemetry (reduce data collection)
export DISABLE_TELEMETRY=1

# Use custom API endpoint
export ANTHROPIC_BASE_URL=https://your-proxy.com

# Use your own API key
export ANTHROPIC_API_KEY=sk-xxx
```

---

## Usage

| Command | Description |
|:---|:---|
| `recode` | Start RE CODE |
| `recode -v` | Show version |
| `/model [name]` | Switch model (opus/sonnet/haiku) |
| `/config` | View/edit configuration |
| `/clear` | Clear session |
| `/exit` | Exit |

---

## Project Structure

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

## Contributing

```bash
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode
git checkout -b feature/your-feature
git commit -m 'Add awesome feature'
git push origin feature/your-feature
```

---

## License

MIT License - See [LICENSE](LICENSE)

---

<p align="center">
  Made with by <a href="https://github.com/mangiapanejohn-dev">ReCode Team</a>
</p>