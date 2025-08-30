# AI开发规范自动集成指南

## 🎯 概述

本指南介绍如何将AI开发规范自动集成到所有后续项目中，实现开发标准的统一化和自动化。

---

## 🚀 一键集成使用方法

### 基础使用

```bash
# 为新项目自动集成开发规范
/path/to/Development-Standards/scripts/init-project.sh /path/to/your-project [项目类型]
```

### 项目类型说明

| 项目类型 | 说明 | 特殊配置 |
|---------|------|---------|
| **agent** | AI Agent产品项目 | Agent PRD模板、开发检查清单、专用配置 |
| **web** | Web应用项目 | 前端/后端开发规范、构建配置 |
| **mobile** | 移动应用项目 | 移动开发特殊配置、平台相关设置 |
| **general** | 通用项目(默认) | 基础开发规范和最佳实践 |

### 使用示例

```bash
# Agent项目
./scripts/init-project.sh /Users/me/MyAgent agent

# Web项目  
./scripts/init-project.sh /Users/me/MyWebApp web

# 移动应用项目
./scripts/init-project.sh /Users/me/MyMobileApp mobile

# 通用项目
./scripts/init-project.sh /Users/me/MyProject
```

---

## 📁 集成后的项目结构

### 自动创建的文件和目录

```
your-project/
├── 📄 CLAUDE.md                     # Claude AI协作配置（核心文件）
├── 📄 README.md                     # 项目说明（如不存在则创建）
├── 🚀 dev-start.sh                  # 项目快速启动脚本
├── 📚 docs/
│   ├── 📂 standards/                # 开发规范文档（完整复制）
│   │   ├── AI_AGENT_DEVELOPMENT_GUIDE.md
│   │   ├── DEVELOPMENT_BEST_PRACTICES.md
│   │   ├── PROJECT_WORKFLOW.md
│   │   ├── TECHNICAL_DECISIONS_TEMPLATE.md
│   │   └── CONTEXT_ENGINEERING_GUIDE.md
│   ├── 📂 templates/                # 开发模板（完整复制）
│   │   ├── AGENT_PRD_TEMPLATE.md
│   │   ├── PROJECT_SETUP_CHECKLIST.md
│   │   ├── WEEKLY_PLANNING_TEMPLATE.md
│   │   └── ...
│   ├── 📂 decisions/                # 技术决策记录目录
│   └── 📂 [Agent项目专用文件]
│       ├── ${PROJECT_NAME}-Agent-PRD.md
│       └── AGENT_DEVELOPMENT_CHECKLIST.md
├── 🔧 .vscode/                      # VSCode配置
│   ├── settings.json                # 编辑器配置
│   ├── tasks.json                   # 任务配置
│   └── extensions.json              # 推荐扩展
└── 🔗 .git/hooks/                   # Git hooks
    ├── pre-commit                   # 提交前检查
    └── commit-msg                   # 提交信息格式检查
```

---

## 🤖 CLAUDE.md文件详解

### 文件作用
`CLAUDE.md` 是每个项目的AI协作配置文件，包含：
- 项目基本信息和技术栈
- Claude协作指南和上下文要求
- 开发规范文档链接
- 项目特定的检查清单

### 典型内容结构

```markdown
# Claude AI协作配置文件

## 🎯 项目信息
- **项目名称**: MyAgent
- **项目类型**: agent  
- **项目描述**: 智能客服Agent系统
- **技术栈**: Python + FastAPI + OpenAI
- **开发者**: 张三
- **创建时间**: 2025-08-30

## 📋 开发规范
[链接到本地规范文档]

## 🤖 Claude协作指南
[具体的协作指导]

## 📊 项目检查清单
[项目特定的开发检查项]
```

---

## ⚙️ 自动配置功能详解

### 1. Git Hooks自动配置

#### Pre-commit Hook
```bash
# 自动执行的检查项
✅ CLAUDE.md配置文件存在性检查
✅ Agent项目特殊要求验证
✅ 代码质量基础检查
✅ 文档文件格式验证
⚠️  TODO/FIXME标记提醒
⚠️  调试代码检查提醒
```

#### Commit Message Hook
```bash
# 强制提交信息格式
feat: 添加新功能
fix: 修复bug
docs: 更新文档
agent: Agent相关更新
```

### 2. VSCode自动配置

#### 编辑器设置
- 自动格式化和保存
- Markdown预览优化
- 文件关联配置
- 代码规范检查

#### 任务配置
- 一键启动开发规范Wiki
- 创建技术决策文档
- Agent PRD文档生成
- 开发环境检查

#### 推荐扩展
- Markdown编辑增强
- 代码格式化工具
- Git集成工具
- 项目管理辅助

### 3. Agent项目特殊配置

当项目类型为`agent`时，额外提供：
- Agent PRD文档模板
- Agent开发检查清单
- Agent特定的VSCode任务
- Agent相关的Git检查

---

## 🔄 使用工作流程

### 新项目开发流程

```bash
# 1. 创建项目目录
mkdir MyNewProject && cd MyNewProject

# 2. 初始化Git（如果需要）
git init

# 3. 运行自动集成脚本
/path/to/Development-Standards/scripts/init-project.sh $(pwd) agent

# 4. 根据提示输入项目信息
# 项目描述: 智能客服Agent系统
# 技术栈: Python + FastAPI
# 开发者: 你的名字

# 5. 开始开发
./dev-start.sh
```

### 日常开发工作流

```bash
# 1. 启动开发环境
./dev-start.sh

# 2. 查看开发规范（浏览器自动打开）
# http://localhost:1024

# 3. 按照CLAUDE.md指导与AI协作

# 4. 提交代码（自动执行检查）
git add .
git commit -m "feat: 实现用户意图识别功能"
```

---

## 📋 Agent项目专用功能

### Agent PRD文档自动生成
```bash
# 脚本会自动创建
docs/MyAgent-Agent-PRD.md
```

基于模板包含完整的Agent产品需求结构：
- Agent身份设计
- 认知能力架构  
- 交互行为设计
- 知识体系设计
- 系统集成设计
- 测试验证框架
- 成功指标定义
- 实施计划

### Agent开发检查清单
```bash
# 自动创建开发检查清单
docs/AGENT_DEVELOPMENT_CHECKLIST.md
```

包含四个开发阶段的详细检查项：
- Phase 1: 需求设计
- Phase 2: 系统实现  
- Phase 3: 测试验证
- Phase 4: 上线部署

### VSCode Agent任务
```json
{
  "label": "Agent: 创建PRD文档",
  "type": "shell",
  "command": "cp",
  "args": ["模板路径", "目标路径"]
}
```

---

## 🎯 自定义和扩展

### 修改项目模板
编辑以下文件来定制模板：
```bash
templates/CLAUDE_PROJECT_TEMPLATE.md    # CLAUDE.md模板
templates/git-hooks/pre-commit          # Git hooks模板
templates/vscode/settings.json          # VSCode设置模板
```

### 添加新的项目类型
在初始化脚本中添加新的case分支：
```bash
# scripts/init-project.sh
case "$PROJECT_TYPE" in
    agent|web|mobile|general|new_type)
        ;;
esac
```

### 自定义检查规则
修改Git hooks模板添加项目特定检查：
```bash
# templates/git-hooks/pre-commit
# 添加你的检查逻辑
```

---

## 🔧 高级配置

### 全局别名设置
```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
alias init-ai-project='/path/to/Development-Standards/scripts/init-project.sh'

# 使用
init-ai-project /path/to/project agent
```

### 环境变量配置
```bash
# 设置开发规范路径
export AI_DEV_STANDARDS="/path/to/Development-Standards"

# 在脚本中使用
$AI_DEV_STANDARDS/scripts/init-project.sh
```

### CI/CD集成
```yaml
# .github/workflows/check-standards.yml
name: Check AI Development Standards
on: [push, pull_request]
jobs:
  check-standards:
    runs-on: ubuntu-latest
    steps:
      - name: Check CLAUDE.md exists
        run: test -f CLAUDE.md
      - name: Validate project structure
        run: test -d docs/standards
```

---

## ❓ 故障排除

### 常见问题

#### 1. 权限错误
```bash
# 确保脚本有执行权限
chmod +x /path/to/Development-Standards/scripts/init-project.sh
```

#### 2. Python依赖缺失
```bash
# 检查Python和JSON模块
python3 -c "import json"
```

#### 3. Git hooks不生效
```bash
# 检查hooks权限
ls -la .git/hooks/
chmod +x .git/hooks/pre-commit
```

#### 4. VSCode配置不生效
```bash
# 重新加载VSCode工作区
Ctrl/Cmd + Shift + P -> "Developer: Reload Window"
```

### 调试模式
```bash
# 开启调试模式运行脚本
bash -x /path/to/Development-Standards/scripts/init-project.sh
```

---

## 🚀 最佳实践建议

### 团队使用规范
1. **统一路径**：团队成员使用相同的Development-Standards路径
2. **定期更新**：定期从主仓库更新开发规范
3. **自定义配置**：根据团队特点调整模板配置
4. **培训指导**：为新成员提供使用培训

### 项目维护
1. **定期检查**：使用VSCode任务检查项目配置完整性
2. **文档更新**：随项目发展更新CLAUDE.md文件
3. **规范跟进**：关注Development-Standards的更新

### 质量保证
1. **强制使用**：团队所有新项目必须使用自动集成
2. **定期审查**：定期检查项目是否遵循开发规范
3. **持续改进**：根据实际使用情况优化集成脚本

---

## 📚 相关资源

### 核心文档
- [AI Agent开发完整指南](./AI_AGENT_DEVELOPMENT_GUIDE.md)
- [开发最佳实践](./DEVELOPMENT_BEST_PRACTICES.md)
- [项目工作流程](./PROJECT_WORKFLOW.md)

### 模板文件
- [Agent PRD模板](../templates/AGENT_PRD_TEMPLATE.md)
- [Claude配置模板](../templates/CLAUDE_PROJECT_TEMPLATE.md)
- [项目检查清单](../templates/PROJECT_SETUP_CHECKLIST.md)

### 工具脚本
- [项目初始化脚本](../scripts/init-project.sh)
- [Wiki服务脚本](../scripts/simple-wiki.py)

---

*本指南随开发实践持续更新，确保自动集成功能的实用性和有效性*
*最后更新: 2025-08-30*
*维护者: AI开发团队*