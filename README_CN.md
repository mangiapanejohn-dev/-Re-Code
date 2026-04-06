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
sequenceDiagram
    participant USER as 用户
    participant CLI as CLI/TUI 终端
    participant ENGINE as 客户端引擎
    participant TUNNEL as 安全隧道
    participant PROXY as 代理基础设施
    participant GATEWAY as API 网关
    participant API as Anthropic API
    
    Note over USER,CLI: 用户层
    USER->>CLI: 输入查询
    CLI->>ENGINE: 解析并加入队列
    
    Note over ENGINE: 客户端引擎层
    ENGINE->>ENGINE: 验证输入
    ENGINE->>ENGINE: 构建上下文
    ENGINE->>TUNNEL: 加密载荷
    
    Note over TUNNEL: 安全隧道层
    TUNNEL->>TUNNEL: AES-256 加密
    TUNNEL->>TUNNEL: 压缩载荷
    TUNNEL->>TUNNEL: HMAC 签名
    TUNNEL->>TUNNEL: 时序随机化
    TUNNEL->>PROXY: 转发请求
    
    Note over PROXY: 代理基础设施层
    PROXY->>PROXY: 负载均衡
    PROXY->>PROXY: 混淆请求
    PROXY->>PROXY: 随机化指纹
    PROXY->>PROXY: 选择出口节点
    PROXY->>GATEWAY: 路由请求
    
    Note over GATEWAY: API 网关层
    GATEWAY->>GATEWAY: 速率限制
    GATEWAY->>API: 转发请求
    
    API->>GATEWAY: 响应
    GATEWAY->>PROXY: 响应数据
    PROXY->>TUNNEL: 解密响应
    TUNNEL->>ENGINE: 解析响应
    ENGINE->>CLI: 显示结果
    CLI->>USER: 输出
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
sequenceDiagram
    participant REQ as 请求
    participant L1 as 第一层<br/>设备身份
    participant L2 as 第二层<br/>请求模式
    participant L3 as 第三层<br/>网络身份
    participant L4 as 第四层<br/>API 密钥保护
    participant OUT as 输出
    
    REQ->>L1: 开始处理
    
    Note over L1: 设备身份混淆
    L1->>L1: MAC 地址轮换
    L1->>L1: 硬件 UUID 伪装
    L1->>L1: 显示器信息噪声注入
    L1->>L1: 时区标准化
    L1->>L1: User-Agent 轮换
    L1->>L2: 混淆后的请求
    
    Note over L2: 请求模式随机化
    L2->>L2: 请求时序随机化
    L2->>L2: Token 序列置换
    L2->>L2: 载荷大小填充
    L2->>L2: Header 清理
    L2->>L2: Cookie 隔离
    L2->>L3: 掩码模式
    
    Note over L3: 网络身份管理
    L3->>L3: 从住宅代理 IP 池选择
    L3->>L3: 强制地理位置一致性
    L3->>L3: 检查 IP 信誉评分
    L3->>L3: 自动 IP 轮换
    L3->>L3: 需要时智能故障转移
    L3->>L4: 轮换后的身份
    
    Note over L4: API 密钥保护
    L4->>L4: 从本地加密加载
    L4->>L4: 仅存储在内存中
    L4->>L4: 进程隔离
    L4->>L4: 密钥轮换支持
    L4->>L4: 从不暴露给第三方
    L4->>OUT: 受保护的请求
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