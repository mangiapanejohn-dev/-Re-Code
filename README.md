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
sequenceDiagram
    participant USER as User
    participant CLI as CLI/TUI
    participant ENGINE as Client Engine
    participant TUNNEL as Security Tunnel
    participant PROXY as Proxy Infrastructure
    participant GATEWAY as API Gateway
    participant API as Anthropic API
    
    Note over USER,CLI: User Layer
    USER->>CLI: Input Query
    CLI->>ENGINE: Parse & Queue
    
    Note over ENGINE: Client Engine Layer
    ENGINE->>ENGINE: Validate Input
    ENGINE->>ENGINE: Build Context
    ENGINE->>TUNNEL: Encrypted Payload
    
    Note over TUNNEL: Security Tunnel Layer
    TUNNEL->>TUNNEL: AES-256 Encrypt
    TUNNEL->>TUNNEL: Compress Payload
    TUNNEL->>TUNNEL: HMAC Sign
    TUNNEL->>TUNNEL: Randomize Timing
    TUNNEL->>PROXY: Forward Request
    
    Note over PROXY: Proxy Infrastructure Layer
    PROXY->>PROXY: Load Balance
    PROXY->>PROXY: Obfuscate Request
    PROXY->>PROXY: Randomize Fingerprint
    PROXY->>PROXY: Select Exit Node
    PROXY->>GATEWAY: Route Request
    
    Note over GATEWAY: API Gateway Layer
    GATEWAY->>GATEWAY: Rate Limiting
    GATEWAY->>API: Forward Request
    
    API->>GATEWAY: Response
    GATEWAY->>PROXY: Response Data
    PROXY->>TUNNEL: Decrypt Response
    TUNNEL->>ENGINE: Parse Response
    ENGINE->>CLI: Display Result
    CLI->>USER: Output
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
sequenceDiagram
    participant REQ as Request
    participant L1 as Layer 1<br/>Device Identity
    participant L2 as Layer 2<br/>Request Pattern
    participant L3 as Layer 3<br/>Network Identity
    participant L4 as Layer 4<br/>API Key Protection
    participant OUT as Output
    
    REQ->>L1: Start Processing
    
    Note over L1: Device Identity Obfuscation
    L1->>L1: MAC Address Rotation
    L1->>L1: Hardware UUID Spoofing
    L1->>L1: Display Info Noise Injection
    L1->>L1: Timezone Normalization
    L1->>L1: User-Agent Rotation
    L1->>L2: Obfuscated Request
    
    Note over L2: Request Pattern Randomization
    L2->>L2: Request Timing Randomization
    L2->>L2: Token Sequence Permutation
    L2->>L2: Payload Size Padding
    L2->>L2: Header Sanitization
    L2->>L2: Cookie Isolation
    L2->>L3: Masked Pattern
    
    Note over L3: Network Identity Management
    L3->>L3: Select from Residential IP Pool
    L3->>L3: Enforce Geo-Location Consistency
    L3->>L3: Check IP Reputation Score
    L3->>L3: Automatic IP Rotation
    L3->>L3: Smart Failover if Needed
    L3->>L4: Rotated Identity
    
    Note over L4: API Key Protection
    L4->>L4: Load from Local Encryption
    L4->>L4: Store in Memory-Only
    L4->>L4: Process Isolation
    L4->>L4: Key Rotation Support
    L4->>L4: Never Expose to Third-Party
    L4->>OUT: Protected Request
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