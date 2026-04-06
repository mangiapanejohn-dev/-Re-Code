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

### Request Processing Flow

```mermaid
sequenceDiagram
    participant USER as User
    participant CLI as CLI/TUI
    participant ENGINE as Client Engine
    participant SEC as Security Pipeline
    participant PROXY as Proxy
    participant API as Anthropic Claude API
    
    USER->>CLI: Input Query
    CLI->>ENGINE: Parse & Queue
    ENGINE->>ENGINE: Validate & Build Context
    
    ENGINE->>SEC: Protected Request
    Note over SEC: 4-Layer Security Pipeline
    SEC->>SEC: Layer 1: Device Identity Obfuscation
    SEC->>SEC: Layer 2: Request Pattern Randomization
    SEC->>SEC: Layer 3: Network Identity Management
    SEC->>SEC: Layer 4: API Key Protection
    SEC->>SEC: AES-256 Encryption + HMAC Sign
    
    SEC->>PROXY: Encrypted Request
    PROXY->>PROXY: Load Balance + IP Rotation
    PROXY->>API: Forward Request
    
    alt Success
        API->>PROXY: Response
        PROXY->>SEC: Encrypted Response
        SEC->>ENGINE: Decrypted Response
        ENGINE->>CLI: Display Result
        CLI->>USER: Output
    else Rate Limit
        API->>PROXY: Rate Limit Error
        PROXY->>PROXY: Switch IP & Retry
        PROXY->>API: Retry Request
    end
```

### Core Components
    L3->>L3: Select from Residential IP Pool
    L3->>L3: Enforce Geo-Location Consistency
    L3->>L3: Check IP Reputation Score
    L3->>L3: Automatic IP Rotation
    L3->>L3: Smart Failover if Needed
    L3->>L4: Network-Identity Request
    
    %% Security Layer 4: API Key Protection
    Note over L4: API Key Protection
    L4->>L4: Load from Local Encryption
    L4->>L4: Store in Memory-Only
    L4->>L4: Process Isolation
    L4->>L4: Key Rotation Support
    L4->>L4: Never Expose to Third-Party
    L4->>TUNNEL: Security-Protected Request
    
    %% Security Tunnel Processing
    Note over TUNNEL: Security Tunnel
    TUNNEL->>TUNNEL: AES-256 Encryption
    TUNNEL->>TUNNEL: Payload Compression
    TUNNEL->>TUNNEL: HMAC Signature
    TUNNEL->>TUNNEL: Timing Randomization
    TUNNEL->>PROXY: Encrypted Forward Request
    
    %% Proxy Infrastructure Processing
    Note over PROXY: Proxy Infrastructure
    PROXY->>PROXY: Global Load Balancing
    PROXY->>PROXY: Edge Node Selection
    PROXY->>PROXY: Request Obfuscation
    PROXY->>PROXY: Fingerprint Randomization
    PROXY->>PROXY: Exit Node Selection
    PROXY->>GATEWAY: Routed Request
    
    %% API Gateway Processing
    Note over GATEWAY: API Gateway
    GATEWAY->>GATEWAY: Rate Limiting
    GATEWAY->>GATEWAY: Retry Engine
    GATEWAY->>GATEWAY: Failover Controller
    GATEWAY->>API: Forward to Claude API
    
    %% Response Phase
    alt Success Response
        API->>GATEWAY: Claude Response
        GATEWAY->>PROXY: Response Data
        PROXY->>TUNNEL: Encrypted Response
        TUNNEL->>TUNNEL: Decrypt Response
        TUNNEL->>ENGINE: Parsed Response
        ENGINE->>ENGINE: Update Context Cache
        ENGINE->>CLI: Display Result
        CLI->>USER: Output
    else Rate Limit / Ban Risk
        API->>GATEWAY: Rate Limit Error
        GATEWAY->>PROXY: Trigger Retry
        PROXY->>PROXY: Switch Exit Node
        PROXY->>GATEWAY: Retry with New IP
        GATEWAY->>API: Retry Request
    end
```

### Core Components

| Component | Function | Technology |
|:---|:---|:---|
| **Client Engine** | User interaction, command parsing | React + Node.js |
| **Security Pipeline** | 4-layer security + encryption | Custom middleware |
| **Proxy Network** | Load balance, IP rotation | Dynamic node management |
| **API Gateway** | Rate limiting, retry, failover | Nginx + Lua scripts |

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