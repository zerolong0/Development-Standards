# 🚀 AI开发规范快速开始指南

## 一分钟上手 - 自动集成到所有项目

### 🎯 立即使用

```bash
# 1. 进入你的项目目录
cd /path/to/your-project

# 2. 一键集成AI开发规范（选择你的项目类型）
/Users/zerolong/Documents/AICODE/Development-Standards/scripts/init-project.sh $(pwd) agent
```

**支持的项目类型**：
- `agent` - AI Agent产品项目  
- `web` - Web应用项目
- `mobile` - 移动应用项目
- `general` - 通用项目（默认）

### ✨ 立即获得的功能

✅ **Claude AI协作配置** - 每个项目自动生成CLAUDE.md  
✅ **完整开发规范** - 自动复制所有规范文档到项目  
✅ **Git提交检查** - 自动配置代码质量检查hooks  
✅ **VSCode优化配置** - 编辑器、任务、扩展推荐  
✅ **Agent专用模板** - PRD模板、开发检查清单（agent项目）  
✅ **本地知识库** - 一键访问http://localhost:1024  

---

## 🔧 设置全局别名（推荐）

```bash
# 添加到你的 ~/.bashrc 或 ~/.zshrc
echo 'alias init-ai-project="/Users/zerolong/Documents/AICODE/Development-Standards/scripts/init-project.sh"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc

# 现在可以直接使用
init-ai-project /path/to/project agent
```

---

## 📖 典型使用场景

### 🤖 创建新的AI Agent项目

```bash
# 1. 创建项目目录
mkdir MyIntelligentAgent && cd MyIntelligentAgent

# 2. 初始化Git
git init

# 3. 集成AI开发规范
init-ai-project $(pwd) agent

# 4. 根据提示输入项目信息
# 项目描述: 智能客服系统
# 技术栈: Python + FastAPI + OpenAI
# 开发者: 你的名字

# 5. 立即开始开发！
# ✅ 自动打开浏览器访问规范文档
# ✅ 生成Agent PRD模板
# ✅ 配置完整的开发环境
```

### 🌐 为现有Web项目添加规范

```bash
cd /path/to/existing-web-project
init-ai-project $(pwd) web

# 不会覆盖现有文件，只添加规范配置
```

---

## 🎯 Agent项目专享功能

当你选择`agent`类型时，会自动获得：

📋 **Agent产品需求文档模板**
```
docs/MyAgent-Agent-PRD.md
├── Agent身份设计
├── 认知能力架构  
├── 交互行为设计
├── 知识体系设计
├── 系统集成设计
├── 测试验证框架
└── 成功指标定义
```

✅ **Agent开发检查清单**
```
docs/AGENT_DEVELOPMENT_CHECKLIST.md
├── Phase 1: 需求设计 (5项检查)
├── Phase 2: 系统实现 (5项检查)  
├── Phase 3: 测试验证 (5项检查)
└── Phase 4: 上线部署 (4项检查)
```

🎛️ **VSCode专用任务**
- Agent: 创建PRD文档
- 启动开发规范Wiki
- 运行开发环境检查

---

## 📚 集成后立即可用的资源

### 🏠 本地知识库
```bash
# 启动wiki服务（自动运行）
http://localhost:1024

# 包含完整的开发指南：
📖 AI Agent开发完整指南
📝 Agent PRD撰写模板  
💼 保险Agent实践案例
🔧 开发最佳实践
📋 项目工作流程
```

### 📁 项目内快速导航
```bash
your-project/
├── CLAUDE.md              # 👈 AI协作配置（核心文件）
├── docs/standards/         # 👈 完整开发规范
├── docs/templates/         # 👈 所有开发模板
└── .vscode/               # 👈 优化的编辑器配置
```

### 🤖 与Claude协作
打开项目的`CLAUDE.md`文件，里面包含：
- 项目上下文信息
- Claude协作最佳实践
- 具体的工作流程指导
- 代码规范要求

---

## ⚡ 高效使用技巧

### 1. 快速项目模板
```bash
# 创建一个新项目的完整模板函数
create_agent_project() {
    local project_name=$1
    mkdir "$project_name" && cd "$project_name"
    git init
    init-ai-project $(pwd) agent
    echo "🎉 Agent项目 $project_name 创建完成！"
}

# 使用
create_agent_project "MySmartBot"
```

### 2. 批量项目集成
```bash
# 为多个现有项目批量集成规范
for project in project1 project2 project3; do
    init-ai-project "/path/to/$project" general
done
```

### 3. VSCode工作区优化
```bash
# 在VSCode中使用快捷键
Ctrl/Cmd + Shift + P -> "Tasks: Run Task" -> "启动AI开发规范Wiki"
```

---

## 🔄 日常开发工作流

### 开发启动流程
```bash
# 1. 进入项目目录
cd MyProject

# 2. 启动开发环境（可选）
./dev-start.sh

# 3. 查看AI协作指南
code CLAUDE.md

# 4. 开始编码...
```

### 代码提交流程
```bash
# 1. 添加文件
git add .

# 2. 提交（自动运行检查）
git commit -m "feat: 添加用户认证功能"

# ✅ 自动检查：
# - CLAUDE.md文件存在
# - 代码质量检查  
# - 提交信息格式检查
# - Agent项目特殊要求（如适用）
```

---

## 🛠️ 自定义配置

### 修改默认模板
```bash
# 编辑CLAUDE.md模板
vim /Users/zerolong/Documents/AICODE/Development-Standards/templates/CLAUDE_PROJECT_TEMPLATE.md

# 修改Git hooks检查规则
vim /Users/zerolong/Documents/AICODE/Development-Standards/templates/git-hooks/pre-commit
```

### 添加团队特定配置
```bash
# 在初始化脚本后添加团队特定设置
init-ai-project $(pwd) agent
echo "团队特定配置" >> CLAUDE.md
```

---

## 📞 获取帮助

### 查看帮助信息
```bash
/Users/zerolong/Documents/AICODE/Development-Standards/scripts/init-project.sh --help
```

### 详细文档
- 📚 [自动集成完整指南](./docs/AUTO_INTEGRATION_GUIDE.md)
- 🤖 [AI Agent开发指南](./docs/AI_AGENT_DEVELOPMENT_GUIDE.md)  
- 📖 [开发最佳实践](./docs/DEVELOPMENT_BEST_PRACTICES.md)

### 在线知识库
```bash
# 启动wiki服务
python3 /Users/zerolong/Documents/AICODE/Development-Standards/scripts/simple-wiki.py

# 访问 http://localhost:1024
```

---

## 🎉 开始你的AI协作开发之旅！

1. **立即试用**：选择一个项目运行初始化脚本
2. **阅读CLAUDE.md**：了解AI协作最佳实践  
3. **浏览知识库**：访问http://localhost:1024
4. **开始编码**：享受标准化的AI协作开发体验

---

*一次集成，终身受益！让AI开发规范成为你所有项目的标准配置* 🚀