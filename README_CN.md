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
    participant GATEWAY as API 网关
    participant API as Anthropic Claude API
    
    USER->>CLI: 用户输入查询
    CLI->>ENGINE: 解析用户输入
    ENGINE->>ENGINE: 验证输入
    ENGINE->>ENGINE: 构建上下文
    ENGINE->>ENGINE: 加入请求队列
    
    ENGINE->>SEC: 原始请求
    
    Note over SEC: 安全管道 - 4 层
    
    SEC->>SEC: [第1层] 设备身份混淆
    SEC->>SEC:   - MAC 地址轮换
    SEC->>SEC:   - 硬件 UUID 伪装
    SEC->>SEC:   - 显示器信息噪声注入
    SEC->>SEC:   - 时区标准化
    SEC->>SEC:   - User-Agent 轮换
    
    SEC->>SEC: [第2层] 请求模式随机化
    SEC->>SEC:   - 请求时序随机化
    SEC->>SEC:   - Token 序列置换
    SEC->>SEC:   - 载荷大小填充
    SEC->>SEC:   - Header 清理
    SEC->>SEC:   - Cookie 隔离
    
    SEC->>SEC: [第3层] 网络身份管理
    SEC->>SEC:   - 从住宅代理 IP 池选择
    SEC->>SEC:   - 强制地理位置一致性
    SEC->>SEC:   - 检查 IP 信誉评分
    SEC->>SEC:   - 自动 IP 轮换
    SEC->>SEC:   - 智能故障转移
    
    SEC->>SEC: [第4层] API 密钥保护
    SEC->>SEC:   - 从本地加密加载
    SEC->>SEC:   - 仅存储在内存中
    SEC->>SEC:   - 进程隔离
    SEC->>SEC:   - 密钥轮换支持
    SEC->>SEC:   - 从不暴露给第三方
    
    SEC->>SEC: AES-256 加密
    SEC->>SEC: HMAC 签名生成
    SEC->>SEC: 载荷压缩
    
    SEC->>PROXY: 加密签名后的请求
    
    Note over PROXY: 代理网络处理
    PROXY->>PROXY: 全球负载均衡
    PROXY->>PROXY: 边缘节点选择
    PROXY->>PROXY: 请求混淆
    PROXY->>PROXY: 指纹随机化
    PROXY->>PROXY: 出口节点选择(住宅代理IP)
    PROXY->>PROXY: 地理位置一致性检查
    
    PROXY->>GATEWAY: 路由后的请求
    
    Note over GATEWAY: API 网关处理
    GATEWAY->>GATEWAY: 速率限制检查
    GATEWAY->>GATEWAY: 请求验证
    GATEWAY->>GATEWAY: 重试引擎初始化
    GATEWAY->>GATEWAY: 故障转移控制器就绪
    
    GATEWAY->>API: 转发到 Claude API
    
    alt 成功响应
        API->>GATEWAY: Claude 响应 (200 OK)
        GATEWAY->>PROXY: 响应数据
        PROXY->>SEC: 加密响应
        SEC->>SEC: 解密响应
        SEC->>SEC: 验证 HMAC
        SEC->>SEC: 解压载荷
        SEC->>ENGINE: 解析响应
        ENGINE->>ENGINE: 更新上下文缓存
        ENGINE->>ENGINE: 格式化输出
        ENGINE->>CLI: 显示结果
        CLI->>USER: 输出给用户
    else 速率限制错误
        API->>GATEWAY: 429 请求过多
        GATEWAY->>PROXY: 触发重试机制
        PROXY->>PROXY: 切换到不同的出口节点
        PROXY->>PROXY: 选择新的住宅代理IP
        PROXY->>PROXY: 更新 IP 信誉评分
        PROXY->>GATEWAY: 使用新 IP 重试
        GATEWAY->>API: 重试请求
    else 检测到封号风险
        API->>GATEWAY: 403 禁止访问
        GATEWAY->>PROXY: 紧急 IP 轮换
        PROXY->>PROXY: 从备用 IP 池选择
        PROXY->>GATEWAY: 紧急重试
        GATEWAY->>API: 使用新身份重试
    end
```

### 核心组件

| 组件 | 功能 | 技术 |
|:---|:---|:---|
| **客户端引擎** | 用户交互、命令解析、上下文管理 | React + Node.js |
| **安全管道** | 4层安全(设备/模式/网络/密钥) + AES-256 + HMAC | 自定义中间件 |
| **代理网络** | 负载均衡、住宅代理IP池、边缘节点、故障转移 | 动态节点管理 |
| **API 网关** | 速率限制、重试引擎、故障转移、请求验证 | Nginx + Lua 脚本 |

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