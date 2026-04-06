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

---

## 🛡️ RE CODE 是什么？

**RE CODE** 是一个开源的 Claude API 客户端，专门解决 Claude 被封号的问题。

### 🔍 Claude 封号原因

Claude 内部有代号 **"天狗" (Tango Tengu)** 的监控系统，会收集：

| 监控维度 | 收集内容 |
|:---|:---|
| 行为数据 | 打开文件、执行命令等操作 |
| 设备指纹 | 40+ 维度的设备信息 |
| 追踪分组 | 用户分配到 30 个"桶"进行追踪 |

### ⚠️ 封号触发条件

| 风险等级 | 触发原因 |
|:---:|:---|
| 🔴 极高 | 共享账号、使用第三方客户端 |
| 🟠 高 | API 调用频率过高 |
| 🟡 中等 | IP 频繁跨国切换、支付信息与地区不匹配 |

---

## ✨ RE CODE 的优势

| 功能 | 说明 |
|:---|:---|
| 🔒 **隐私保护** | 可关闭遥测，减少数据收集 |
| 🌐 **自定义端点** | 支持自建代理，隐藏真实请求 |
| 🔧 **灵活配置** | 支持自定义 API 端点和模型 |
| 🌍 **多平台** | Windows / macOS / Linux / Termux |
| 📦 **开源可控** | 完全透明，无隐藏行为 |

---

## 🚀 快速安装

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

## ⚙️ 隐私配置

```bash
# 关闭遥测（减少数据收集）
export DISABLE_TELEMETRY=1

# 使用自定义 API 端点
export ANTHROPIC_BASE_URL=https://your-proxy.com

# 使用自己的 API Key
export ANTHROPIC_API_KEY=sk-xxx
```

---

## 📖 使用方法

| 命令 | 说明 |
|:---|:---|
| `recode` | 启动 RE CODE |
| `recode -v` | 查看版本 |
| `/model [name]` | 切换模型 (opus/sonnet/haiku) |
| `/config` | 查看/编辑配置 |
| `/clear` | 清除会话 |
| `/exit` | 退出 |

---

## 🏗️ 项目结构

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
└── README.md               # 说明文档
```

---

## 🤝 贡献

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