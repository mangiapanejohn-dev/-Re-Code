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
    subgraph USER_LAYER["用户层"]
        direction LR
        CLI["CLI/TUI 终端"] --> WEB["Web 界面"]
        WEB --> SDK["SDK API"]
    end
    
    USER_LAYER --> CLIENT_ENGINE
    
    subgraph CLIENT_ENGINE["客户端引擎"]
        direction TB
        PARSE["输入解析器"] --> VALIDATE["验证器"]
        VALIDATE --> QUEUE["请求队列"]
        QUEUE --> CONTEXT["上下文管理器"]
    end
    
    CLIENT_ENGINE --> TUNNEL
    
    subgraph TUNNEL["安全隧道"]
        direction TB
        ENCRYPT["AES-256 加密"] --> COMPRESS["载荷压缩"]
        COMPRESS --> SIGNATURE["HMAC 签名"]
        SIGNATURE --> TIMING["时序随机化"]
    end
    
    TUNNEL --> PROXY
    
    subgraph PROXY["代理基础设施"]
        direction TB
        LB["全球负载均衡"] --> EDGE["边缘节点"]
        EDGE --> OBFS["混淆引擎"]
        OBFS --> FINGERPRINT["指纹随机化"]
        FINGERPRINT --> IP_POOL["IP 池管理器"]
        IP_POOL --> RESIDENTIAL["住宅代理"]
    end
    
    PROXY --> API_GATEWAY
    
    subgraph API_GATEWAY["API 网关"]
        direction TB
        RATE["速率限制器"] --> RETRY["重试引擎"]
        RETRY --> FAILOVER["故障转移控制器"]
    end
    
    API_GATEWAY --> ANTHROPIC
    
    ANTHROPIC[("Anthropic Claude API")] --> RESPONSE
    RESPONSE["响应处理器"] --> DECODE["响应解码器"]
    DECODE --> CACHE["上下文缓存"]
    CACHE --> DISPLAY["用户界面"]
    
    style USER_LAYER fill:#0f172a,stroke:#334155,stroke-width:2,color:#fff
    style CLIENT_ENGINE fill:#1e1b4b,stroke:#4338ca,stroke-width:2,color:#fff
    style TUNNEL fill:#164e63,stroke:#06b6d4,stroke-width:2,color:#fff
    style PROXY fill:#14532d,stroke:#22c55e,stroke-width:2,color:#fff
    style API_GATEWAY fill:#7c2d12,stroke:#f97316,stroke-width:2,color:#fff
    style ANTHROPIC fill:#7c3aed,stroke:#9333ea,stroke-width:3,color:#fff
    style RESPONSE fill:#4a044e,stroke:#db2777,stroke-width:2,color:#fff
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
flowchart TB
    subgraph LAYER1["第一层: 设备身份混淆"]
        direction LR
        MAC["MAC 地址轮换"] 
        HWID["硬件 UUID 伪装"]
        DISPLAY["显示器信息噪声注入"]
        TZ["时区标准化"]
        USER_AGENT["User-Agent 轮换"]
    end
    
    LAYER1 --> LAYER2
    
    subgraph LAYER2["第二层: 请求模式随机化"]
        direction LR
        TIMING["请求时序随机化"]
        SEQUENCE["Token 序列置换"]
        SIZE["载荷大小填充"]
        HEADER_SANI["Header 清理"]
        COOKIE["Cookie 隔离"]
    end
    
    LAYER2 --> LAYER3
    
    subgraph LAYER3["第三层: 网络身份管理"]
        direction LR
        IP_POOL["住宅代理 IP 池"]
        GEO["地理位置一致性"]
        REPUTE["IP 信誉评分"]
        ROTATION["自动 IP 轮换"]
        FAILOVER["智能故障转移"]
    end
    
    LAYER3 --> LAYER4
    
    subgraph LAYER4["第四层: API 密钥保护"]
        direction LR
        ENCRYPTED["本地加密"]
        MEMORY["内存级存储"]
        ISOLATE["进程隔离"]
        ROTATE["密钥轮换支持"]
        NEVER_EXPOSE["从不暴露给第三方"]
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