# AI协作开发规范体系

## 🎯 概述
这是一套基于行业专家最佳实践的AI协作开发规范体系，整合了Chris Dzombak、Simon Willison、Anthropic等专家的经验，并通过Claude Code逆向工程分析提炼出企业级AI Agent架构设计，为所有软件项目提供标准化的开发流程和质量保证。

### ✨ 最新更新
- **AI系统架构模块**: 基于Claude Code逆向工程，提供完整的Multi-Agent架构设计、92%压缩率的上下文管理、15个工具生态分析
- **1人公司创业指南**: AI时代的独立开发者创业方法论，从想法到产品的完整路径
- **移动端跨平台方案**: Flutter、React Native、uni-app、Taro全栈支持

## 📚 文档结构

### 🏗️ AI系统架构模块（新增）
- **[ai-system-architecture/](./ai-system-architecture/)** - 基于Claude Code逆向工程的企业级AI Agent架构参考
  - **[核心设计原则](./ai-system-architecture/core-principles.md)** - 效率优先、用户体验、安全可控、工程化原则
  - **[系统架构设计](./ai-system-architecture/system-architecture.md)** - 分层架构、组件设计、数据流控制
  - **[Multi-Agent协作](./ai-system-architecture/multi-agent-pattern.md)** - Main-Sub Agent模式、任务分发、上下文隔离
  - **[上下文管理](./ai-system-architecture/context-management.md)** - 92%压缩率优化、记忆持久化、动态注入
  - **[工具生态系统](./ai-system-architecture/tool-ecosystem.md)** - 15个工具分析、MCP协议集成、安全框架
  - **[实施指南](./ai-system-architecture/implementation-guide.md)** - MVP开发路线图、部署策略、监控运维

### 🚀 1人公司AI创业指南（新增）
- **[AI-Solo-Founder/](./AI-Solo-Founder/)** - AI时代的单人创业完整指南
  - 基于实战经验的AI创业方法论
  - 从想法到产品的完整路径
  - 适合独立开发者和小团队

### 📋 核心规范文档
- **[TECHNICAL_DECISIONS_TEMPLATE.md](./docs/TECHNICAL_DECISIONS_TEMPLATE.md)** - 技术决策记录模板
- **[DEVELOPMENT_BEST_PRACTICES.md](./docs/DEVELOPMENT_BEST_PRACTICES.md)** - 开发最佳实践指南
- **[PROJECT_WORKFLOW.md](./docs/PROJECT_WORKFLOW.md)** - 项目工作流程规范
- **[CONTEXT_ENGINEERING_GUIDE.md](./docs/CONTEXT_ENGINEERING_GUIDE.md)** - AI协作上下文管理指南
- **[AI_AGENT_DEVELOPMENT_GUIDE.md](./docs/AI_AGENT_DEVELOPMENT_GUIDE.md)** - AI Agent产品开发完整指南

### 📱 移动端跨平台开发指南
- **[MOBILE_CROSS_PLATFORM_GUIDE.md](./docs/MOBILE_CROSS_PLATFORM_GUIDE.md)** - 移动端跨平台开发完整指南
- **[MOBILE_FRAMEWORK_COMPARISON.md](./docs/MOBILE_FRAMEWORK_COMPARISON.md)** - 移动端框架详细对比分析
- **[MOBILE_IMPLEMENTATION_GUIDE.md](./docs/MOBILE_IMPLEMENTATION_GUIDE.md)** - 移动端项目实施指南

### 📝 实用模板
- **[PROJECT_SETUP_CHECKLIST.md](./templates/PROJECT_SETUP_CHECKLIST.md)** - 项目启动检查清单
- **[WEEKLY_PLANNING_TEMPLATE.md](./templates/WEEKLY_PLANNING_TEMPLATE.md)** - 周计划模板
- **[CODE_REVIEW_CHECKLIST.md](./templates/CODE_REVIEW_CHECKLIST.md)** - 代码审查检查清单
- **[BUG_REPORT_TEMPLATE.md](./templates/BUG_REPORT_TEMPLATE.md)** - 问题报告模板
- **[AGENT_PRD_TEMPLATE.md](./templates/AGENT_PRD_TEMPLATE.md)** - AI Agent产品需求文档模板

### 🛠️ 工具和脚本
- **[scripts/](./scripts/)** - 自动化脚本集合
- **[configs/](./configs/)** - 常用配置文件模板

## 🚀 如何使用

### ⚡ 快速开始（推荐）

**一键集成到任何项目：**
```bash
# Agent项目
./scripts/init-project.sh /path/to/your-project agent

# Web项目  
./scripts/init-project.sh /path/to/your-project web

# 移动端项目
./scripts/init-project.sh /path/to/your-project mobile

# 通用项目
./scripts/init-project.sh /path/to/your-project
```

**立即获得：**
- ✅ Claude AI协作配置  
- ✅ 完整开发规范文档
- ✅ Git hooks自动检查
- ✅ VSCode优化配置
- ✅ Agent专用模板（agent项目）
- ✅ 移动端跨平台模板（mobile项目）

📚 **详细使用指南**: [QUICK_START.md](./QUICK_START.md)

### 📖 启动本地Wiki服务
```bash
# 方法1: 使用启动脚本（推荐）
./start-wiki.sh

# 方法2: 直接运行Python脚本
cd scripts && python3 start-wiki.py
```

**访问地址**: http://localhost:1024

**特色功能**:
- 🎨 美观的响应式界面
- 📝 Markdown自动渲染
- 🔗 智能链接导航
- 📋 自动目录生成
- 💻 代码语法高亮

### 新项目启动
1. 复制本规范体系到项目根目录下的 `docs/standards/`
2. 根据项目特点定制技术决策模板
3. 设置开发环境和工具链
4. 建立团队协作流程

### AI Agent项目开发
1. 阅读 [AI Agent开发完整指南](./docs/AI_AGENT_DEVELOPMENT_GUIDE.md)
2. 使用 [Agent PRD模板](./templates/AGENT_PRD_TEMPLATE.md) 撰写需求文档
3. 参考 [保险Agent案例](./examples/Insurance-Agent-PRD-Example.md) 学习实践
4. 遵循Agent产品开发方法论

### 日常开发
1. 遵循Context Engineering原则与AI协作
2. 应用三次尝试原则解决问题
3. 执行增量开发和持续集成
4. 维护功能性文档

### 质量保证
1. 使用代码审查检查清单
2. 执行TDD开发流程
3. 监控性能和质量指标
4. 定期回顾和改进流程

## 📈 版本历史

| 版本 | 日期 | 主要变更 | 基于项目 |
|------|------|----------|----------|
| 2.0 | 2025-09-07 | 新增AI系统架构模块、1人公司创业指南 | Claude Code逆向工程 |
| 1.5 | 2025-09-06 | 新增移动端跨平台开发完整方案 | 跨平台框架分析 |
| 1.0 | 2025-08-29 | 初始版本，整合专家最佳实践 | MiniClothes |

## 📖 参考资料

### 核心参考文献
- Chris Dzombak: "Getting Good Results from Claude Code"
- Chris Dzombak: "Functional Documentation"
- Simon Willison: Context Engineering理念
- Anthropic: Claude Code Best Practices
- Claude Code Reverse Engineering Analysis (Yuyz0112)
- AI Pair Programming研究和实践
- AI-Solo-Founder创业方法论

### 适用场景
- **企业级AI Agent开发** - 基于Claude Code架构的Multi-Agent系统
- **1人公司/独立开发者** - AI驱动的单人创业完整方案
- **AI Agent产品开发** - 完整的Agent开发方法论
- **智能应用开发** - AI驱动的应用产品
- **移动端跨平台开发** - Flutter、React Native、uni-app、Taro全栈支持
- iOS/Android移动应用开发
- Web前端/后端开发  
- AI/ML项目开发
- 小团队敏捷开发
- 个人项目管理

## 🤝 贡献和改进

这套规范体系是活文档，会根据实际使用经验持续优化：

1. **问题反馈**: 记录使用中遇到的问题和改进建议
2. **最佳实践分享**: 补充新发现的有效方法
3. **工具更新**: 随技术发展更新工具和配置
4. **流程优化**: 根据团队反馈调整工作流程

## 📞 支持和联系

如有问题或建议，请通过以下方式联系：
- 项目Issues: [GitHub链接]
- 邮箱: [联系邮箱]
- 文档维护者: 开发团队

---

*最后更新: 2025-09-07*  
*维护者: Zerolong*  
*版权: MIT License*