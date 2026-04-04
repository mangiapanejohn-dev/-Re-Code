# ReCode 🚀

<p align="center">
  <img src="https://img.shields.io/badge/version-3.0.1-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Termux-green.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License">
  <img src="https://img.shields.io/badge/node-%3E%3D18.0.0-yellow.svg" alt="Node Version">
</p>

> 🔄 **ReCode** 是一个开源的多模型 AI 对话界面，让你可以自由选择和配置各种 AI 模型。

## ✨ 核心特性

### 🤖 多模型支持
- **Claude 系列**: Opus 4.6, Sonnet 4.6, Haiku 4.5 等
- **自定义模型**: 支持配置自己的模型和 API Endpoint
- **多提供商**: 支持 Anthropic API、AWS Bedrock、Google Vertex、Azure Foundry

### 🔧 高度可配置
- 首次启动引导配置模型
- 灵活的模型选择器
- 支持环境变量配置
- 本地设置持久化

### 🛡️ 企业级安全
- 完整的权限控制系统
- 工作区信任机制
- MCP 服务器审批
- 代码安全审查

### 💻 跨平台支持
- Windows / macOS / Linux / Termux
- 终端界面，零依赖
- 快速启动，即开即用

## 📸 界面预览

```
╔══════════════════════════════════════════════════════════╗
║  ReCode v3.0.1                                            ║
║  ───────────────────────────────────────────────          ║
║  🤖 AI Assistant                                          ║
║                                                          ║
║  你好！我是 ReCode，一个强大的 AI 对话助手。              ║
║  有什么我可以帮你的吗？                                  ║
║                                                          ║
║  ───────────────────────────────────────────────          ║
║  > _                                                     ║
║                                                          ║
║  模型: Claude Sonnet 4.6 | 会话: 1                       ║
╚══════════════════════════════════════════════════════════╝
```

## 🚀 快速开始

### 一键安装

#### macOS / Linux
```bash
curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.sh | bash
```

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 | iex
```

#### Termux
```bash
curl -sL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install-termux.sh | bash
```

### 手动安装

```bash
# 克隆仓库
git clone https://github.com/mangiapanejohn-dev/-Re-Code.git
cd ReCode

# 安装依赖
npm install

# 启动
npm start
# 或
node cli.js
```

### NPM 安装

```bash
# 全局安装
npm install -g @recode/cli

# 启动
recode
```

## 📖 使用指南

### 首次启动

首次启动时，系统会引导你完成初始配置：

1. **主题选择** - 选择你喜欢的界面主题
2. **模型配置** - 选择要使用的 AI 模型
3. **安全设置** - 了解安全使用指南

### 基本命令

| 命令 | 说明 |
|------|------|
| `/help` | 显示帮助信息 |
| `/model` | 切换模型 |
| `/config` | 查看/修改配置 |
| `/clear` | 清除会话 |
| `/exit` | 退出程序 |

### 环境变量配置

```bash
# 设置 API Key
export ANTHROPIC_API_KEY="your-api-key"

# 使用自定义模型
export ANTHROPIC_MODEL="claude-opus-4-6"

# 自定义 API 地址
export ANTHROPIC_BASE_URL="https://api.anthropic.com"
```

### 使用其他 AI 提供商

```bash
# AWS Bedrock
export CLAUDE_CODE_USE_BEDROCK=1

# Google Vertex
export CLAUDE_CODE_USE_VERTEX=1

# Azure Foundry
export CLAUDE_CODE_USE_FOUNDRY=1
```

## 🔧 工作原理

```
┌─────────────────────────────────────────────────────────────┐
│                         ReCode                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   UI Layer   │───▶│  API Layer   │───▶│  AI Provider │  │
│  │  (Ink/React) │    │ (Client/Auth)│    │ (Anthropic)  │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│         │                   │                   │           │
│         ▼                   ▼                   ▼           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              State Management                       │   │
│  │  - App State (models, sessions, permissions)         │   │
│  │  - Settings (user preferences, config)              │   │
│  │  - Global Config (onboarding, theme)                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 核心模块

1. **UI 层** (`src/components/`)
   - Onboarding: 首次启动引导
   - ModelPicker: 模型选择器
   - REPL: 主交互界面

2. **API 层** (`src/services/api/`)
   - Claude API 客户端
   - 认证与授权
   - 错误处理与重试

3. **状态管理层** (`src/utils/`)
   - Settings: 用户配置持久化
   - Config: 全局配置管理
   - Model: 模型选择逻辑

### 启动流程

```
1. CLI 入口 (cli.js)
       │
       ▼
2. 初始化 (init.ts / main.tsx)
       │
       ▼
3. 检查配置 (showSetupScreens)
       │
       ├──▶ 首次启动 → Onboarding → Model Setup
       │
       └──▶ 已配置 → 主循环 (REPL)
```

## 📁 项目结构

```
ReCode/
├── src/
│   ├── components/       # React 组件
│   │   ├── Onboarding.tsx       # 首次启动引导
│   │   ├── ModelPicker.tsx     # 模型选择器
│   │   └── REPL.tsx            # 主界面
│   ├── services/         # 服务层
│   │   └── api/           # API 客户端
│   ├── utils/            # 工具函数
│   │   ├── model/         # 模型配置
│   │   ├── settings/     # 设置管理
│   │   └── config.ts     # 全局配置
│   └── commands/         # 命令处理
├── cli.js                # 入口文件
├── package.json          # 依赖配置
└── README.md             # 本文件
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建你的分支 (`git checkout -b feature/amazing`)
3. 提交你的更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing`)
5. 创建 Pull Request

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE)

## 🙏 致谢

- [Anthropic](https://www.anthropic.com/) - 提供 Claude API
- [Ink](https://github.com/vadimdemedes/ink) - 终端 UI 框架
- 所有贡献者和测试者

---

<p align="center">Made with ❤️ by ReCode Team</p>