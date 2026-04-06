# RE CODE 👾

<p align="center">
  <a href="https://github.com/mangiapanejohn-dev/-Re-Code/stargazers">
    <img src="https://img.shields.io/github/stars/mangiapanejohn-dev/-Re-Code?style=flat-square&logo=github" alt="Star">
  </a>
  <a href="https://github.com/mangiapanejohn-dev/-Re-Code/forks">
    <img src="https://img.shields.io/github/forks/mangiapanejohn-dev/-Re-Code?style=flat-square&logo=github" alt="Fork">
  </a>
  <img src="https://img.shields.io/badge/version-3.0.2-purple?style=flat-square" alt="版本">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Termux-pink?style=flat-square" alt="平台">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="许可证">
  </a>
</p>

<p align="center">
  <strong>
    <a href="README.md">English</a> | 
    <a href="README_CN.md">中文</a>
  </strong>
</p>

---

## RE CODE 是什么？

**RE CODE** 是一个开源的 Claude API 客户端，专门解决 Claude 被封号的问题。

### Claude 封号原因

Claude 内部有代号为 **"天狗" (Tango Tengu)** 的监控系统，会收集：

| 监控维度 | 收集内容 |
|:---|:---|
| 行为数据 | 打开文件、执行命令等每一个操作 |
| 设备指纹 | 40+ 维度的设备信息 |
| 用户追踪 | 用户分配到 30 个"桶"进行追踪 |

### 封号触发条件

| 风险等级 | 触发原因 |
|:---:|:---|
| 极高 | 共享账号、使用第三方客户端 |
| 高 | API 调用频率过高 |
| 中等 | IP 频繁跨国切换、支付信息与地区不匹配 |

---

## RE CODE 的优势 - 解决 Claude 封号问题

| 功能 | 说明 |
|:---|:---|
| **防封号** | 隐藏设备指纹，绕过天狗监控系统检测 |
| **隐私保护** | 可关闭遥测，完全掌控数据收集 |
| **自定义端点** | 支持自建代理，隐藏真实 IP 和请求 |
| **稳定连接** | 专属服务器，避免高频调用触发封号 |
| **灵活配置** | 支持自定义 API 端点和模型 |
| **多平台** | Windows / macOS / Linux / Termux |

---

## 架构与流程

### 系统概览

```mermaid
flowchart TB
    subgraph CLIENT["客户端层"]
        USER["用户输入"] --> INPUT["输入处理器"]
        INPUT --> CMD["命令解析器"]
        CMD --> QUEUE["请求队列"]
    end
    
    subgraph TUNNEL["隧道层"]
        QUEUE --> ENCRYPT["加密通道"]
        ENCRYPT --> COMPRESS["载荷压缩"]
        COMPRESS --> SIGN["请求签名"]
    end
    
    subgraph PROXY["代理基础设施"]
        SIGN --> LB["负载均衡"]
        LB --> ROUTE["动态路由"]
        ROUTE --> POOL["出口节点池"]
        POOL --> RESIDENT["住宅代理IP"]
        
        ROUTE --> OBFUSCATE["请求混淆"]
        OBFUSCATE --> FINGERPRINT["指纹随机化"]
        OBFUSCATE --> TIMING["时序随机化"]
        OBFUSCATE --> HEADER["Header 清理"]
    end
    
    PROXY --> ANTHROPIC["Anthropic API"]
    ANTHROPIC --> RESP["响应处理器"]
    RESP --> DECRYPT["解密"]
    DECRYPT --> DISPLAY["用户展示"]
    
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

### 请求流程

```mermaid
sequenceDiagram
    participant U as 用户
    participant R as RE CODE 客户端
    participant T as 隧道层
    participant P as 代理网络
    participant E as 出口节点
    participant A as Anthropic API
    
    U->>R: 用户查询
    R->>R: 解析验证
    R->>T: 加密请求
    T->>P: 混淆请求
    P->>E: 轮换IP节点
    E->>A: 转发请求
    
    alt 请求验证通过
        A->>E: 有效响应
        E->>P: 响应数据
        P->>T: 解密响应
        T->>R: 解析响应
        R->>U: 显示结果
    else 速率限制/封号风险
        A->>E: 速率限制错误
        E->>P: 自动重试
        P->>P: 切换出口节点
        P->>A: 使用新IP重试
    end
```

### 核心组件

| 组件 | 功能 | 技术 |
|:---|:---|:---|
| **客户端引擎** | 用户交互、命令解析 | React + Node.js |
| **混淆层** | 设备指纹随机化 | 自定义中间件 |
| **隧道协议** | 加密请求路由 | TLS 1.3 + WireGuard |
| **出口节点池** | IP轮换、住宅代理 | 动态节点管理 |
| **API代理** | 请求/响应转换 | Nginx + Lua 脚本 |

### 安全机制

```mermaid
flowchart LR
    subgraph L1["第一层: 设备指纹"]
        MAC["MAC轮换"] --> UUID["UUID伪装"]
        UUID --> RES["分辨率噪声"]
        RES --> TZ["时区标准化"]
    end
    
    subgraph L2["第二层: 请求混淆"]
        TIMING["时序随机化"] --> TOKEN["Token置换"]
        TOKEN --> PAD["载荷填充"]
        PAD --> HEADER["Header清理"]
    end
    
    subgraph L3["第三层: 网络身份"]
        RESIP["住宅代理池"] --> GEO["地理一致性"]
        GEO --> SCORE["IP信誉评分"]
        SCORE --> FAILOVER["自动故障转移"]
    end
    
    subgraph L4["第四层: 密钥保护"]
        ENCRYPT["本地加密"] --> MEMORY["内存级处理"]
        MEMORY --> EXPOSE["从不暴露"]
        EXPOSE --> ROTATE["自动轮换"]
    end
    
    style L1 fill:#fef3c7,stroke:#f59e0b,stroke-width:2
    style L2 fill:#e0f2fe,stroke:#0ea5e9,stroke-width:2
    style L3 fill:#dcfce7,stroke:#22c55e,stroke-width:2
    style L4 fill:#fce7f3,stroke:#db2777,stroke-width:2
```

---

## 快速安装

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

## 隐私配置

```bash
# 关闭遥测（减少数据收集）
export DISABLE_TELEMETRY=1

# 使用自定义 API 端点
export ANTHROPIC_BASE_URL=https://your-proxy.com

# 使用自己的 API Key
export ANTHROPIC_API_KEY=sk-xxx
```

---

## 使用方法

| 命令 | 说明 |
|:---|:---|
| `recode` | 启动 RE CODE |
| `recode -v` | 查看版本 |
| `/model [name]` | 切换模型 (opus/sonnet/haiku) |
| `/config` | 查看/编辑配置 |
| `/clear` | 清除会话 |
| `/exit` | 退出 |

---

## 项目结构

```
ReCode/
├── src/                    # 源代码
│   ├── commands/           # CLI 命令
│   ├── components/         # UI 组件
│   ├── utils/              # 工具函数
│   └── tools/              # 内置工具
├── recode-temp/package/   # 打包后的 CLI
├── install.sh              # macOS/Linux 安装脚本
├── install.ps1             # Windows 安装脚本
├── install-termux.sh       # Termux 安装脚本
└── README.md               # 英文说明文档
```

---

## 贡献

```bash
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode
git checkout -b feature/your-feature
git commit -m 'Add awesome feature'
git push origin feature/your-feature
```

---

## 许可证

MIT License - See [LICENSE](LICENSE)

---

<p align="center">
  Made with by <a href="https://github.com/mangiapanejohn-dev">ReCode Team</a>
</p>