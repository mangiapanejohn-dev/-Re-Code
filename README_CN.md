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

### 请求处理流程

```mermaid
sequenceDiagram
    participant USER as 用户
    participant CLI as CLI/TUI 终端
    participant ENGINE as 客户端引擎
    participant SEC as 安全管道
    participant PROXY as 代理网络
    participant API as Anthropic Claude API
    
    USER->>CLI: 查询
    CLI->>ENGINE: 解析
    ENGINE->>ENGINE: 验证并构建上下文
    
    ENGINE->>SEC: 原始请求
    Note over SEC: 4层安全管道
    SEC->>SEC: L1: MAC/UUID/显示/时区/UserAgent
    SEC->>SEC: L2: 时序/Token/载荷/Header/Cookie
    SEC->>SEC: L3: 住宅IP/地理/IP信誉/轮换
    SEC->>SEC: L4: 加密/内存/隔离/轮换
    SEC->>SEC: AES-256 + HMAC
    
    SEC->>PROXY: 加密请求
    PROXY->>PROXY: 负载均衡 + IP 轮换
    PROXY->>API: 转发
    
    alt 成功
        API->>PROXY: 响应
        PROXY->>SEC: 解密
        SEC->>ENGINE: 解析
        ENGINE->>CLI: 显示
        CLI->>USER: 输出
    else 速率限制/封号
        API->>PROXY: 错误
        PROXY->>PROXY: 切换IP并重试
    end
```

### 核心组件

| 组件 | 功能描述 |
|:---|:---|
| **客户端引擎** | 解析、验证、上下文管理 |
| **安全管道** | 4层保护 + AES-256/HMAC |
| **代理网络** | 负载均衡、住宅IP、故障转移 |
| **API 网关** | 速率限制、重试引擎 |

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
export DISABLE_TELEMETRY=1
export ANTHROPIC_BASE_URL=https://your-proxy.com
export ANTHROPIC_API_KEY=sk-xxx
```

---

## 使用方法

| 命令 | 说明 |
|:---|:---|
| `recode` | 启动 RE CODE |
| `recode -v` | 查看版本 |
| `/model [name]` | 切换模型 |
| `/config` | 查看/编辑配置 |
| `/clear` | 清除会话 |
| `/exit` | 退出 |

---

## 项目结构

```
ReCode/
├── src/                    # 源代码
├── recode-temp/package/   # 打包后的 CLI
├── install.sh              # macOS/Linux
├── install.ps1             # Windows
└── install-termux.sh       # Termux
```

---

## 贡献

```bash
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode
git checkout -b feature/amazing
git commit -m 'Add feature'
git push origin feature/amazing
```

---

## 许可证

MIT License - See [LICENSE](LICENSE)

---

<p align="center">
  Made with by <a href="https://github.com/mangiapanejohn-dev">ReCode Team</a>
</p>