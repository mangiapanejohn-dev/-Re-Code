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
    subgraph CLIENT["CLIENT LAYER"]
        USER["User Input"] --> INPUT["Input Handler"]
        INPUT --> CMD["Command Parser"]
        CMD --> QUEUE["Request Queue"]
    end
    
    subgraph TUNNEL["TUNNEL LAYER"]
        QUEUE --> ENCRYPT["Encryption Pipeline"]
        ENCRYPT --> COMPRESS["Payload Compression"]
        COMPRESS --> SIGN["Request Signing"]
    end
    
    subgraph PROXY["PROXY INFRASTRUCTURE"]
        SIGN --> LB["Load Balancer"]
        LB --> ROUTE["Dynamic Routing"]
        ROUTE --> POOL["Exit Node Pool"]
        POOL --> RESIDENT["Residential IPs"]
        
        ROUTE --> OBFUSCATE["Request Obfuscation"]
        OBFUSCATE --> FINGERPRINT["Fingerprint Randomizer"]
        OBFUSCATE --> TIMING["Timing Randomizer"]
        OBFUSCATE --> HEADER["Header Sanitizer"]
    end
    
    PROXY --> ANTHROPIC["Anthropic API"]
    ANTHROPIC --> RESP["Response Handler"]
    RESP --> DECRYPT["Decryption"]
    DECRYPT --> DISPLAY["User Display"]
    
    style CLIENT fill:#1e1b4b,stroke:#4338ca,stroke-width:2,color:#fff
    style TUNNEL fill:#1e3a5f,stroke:#0ea5e9,stroke-width:2,color:#fff
    style PROXY fill:#14532d,stroke:#22c55e,stroke-width:2,color:#fff
    style USER fill:#fff,stroke:#333,stroke-width:2
    style INPUT fill:#e0e7ff,stroke:#4338ca
    style CMD fill:#e0e7ff,stroke:#4338ca
    style QUEUE fill:#c7d2fe,stroke:#4338ca
    style ENCRYPT fill:#e0f2fe,stroke:#0ea5e9
    style COMPRESS fill:#e0f2fe,stroke:#0ea5e9
    style SIGN fill:#e0f2fe,stroke:#0ea5e9
    style LB fill:#dcfce7,stroke:#22c55e
    style ROUTE fill:#dcfce7,stroke:#22c55e
    style POOL fill:#dcfce7,stroke:#22c55e
    style RESIDENT fill:#bbf7d0,stroke:#22c55e
    style OBFUSCATE fill:#fef3c7,stroke:#f59e0b
    style FINGERPRINT fill:#fed7aa,stroke:#f59e0b
    style TIMING fill:#fed7aa,stroke:#f59e0b
    style HEADER fill:#fed7aa,stroke:#f59e0b
    style ANTHROPIC fill:#7c3aed,stroke:#9333ea,stroke-width:3,color:#fff
    style RESP fill:#fce7f3,stroke:#db2777
    style DECRYPT fill:#fce7f3,stroke:#db2777
    style DISPLAY fill:#fff,stroke:#333
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
flowchart LR
    subgraph L1["Layer 1: Device Fingerprint"]
        MAC["MAC Rotation"] --> UUID["UUID Spoofing"]
        UUID --> RES["Resolution Noise"]
        RES --> TZ["Timezone Normalize"]
    end
    
    subgraph L2["Layer 2: Request Obfuscation"]
        TIMING["Timing Randomize"] --> TOKEN["Token Permutation"]
        TOKEN --> PAD["Payload Padding"]
        PAD --> HEADER["Header Sanitize"]
    end
    
    subgraph L3["Layer 3: Network Identity"]
        RESIP["Residential Pool"] --> GEO["Geo Consistency"]
        GEO --> SCORE["IP Reputation"]
        SCORE --> FAILOVER["Auto Failover"]
    end
    
    subgraph L4["Layer 4: Key Protection"]
        ENCRYPT["Local Encryption"] --> MEMORY["Memory Only"]
        MEMORY --> EXPOSE["Never Expose"]
        EXPOSE --> ROTATE["Auto Rotation"]
    end
    
    style L1 fill:#fef3c7,stroke:#f59e0b,stroke-width:2
    style L2 fill:#e0f2fe,stroke:#0ea5e9,stroke-width:2
    style L3 fill:#dcfce7,stroke:#22c55e,stroke-width:2
    style L4 fill:#fce7f3,stroke:#db2777,stroke-width:2
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