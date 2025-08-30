#!/bin/bash

# AI开发规范自动集成脚本
# 自动为新项目配置开发标准和最佳实践

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 脚本路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
STANDARDS_DIR="$(dirname "$SCRIPT_DIR")"

# 打印带颜色的消息
print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 显示帮助信息
show_help() {
    cat << EOF
🤖 AI开发规范自动集成工具

用法: $0 [项目路径] [项目类型]

参数:
  项目路径    目标项目的绝对路径（必需）
  项目类型    项目类型，可选值：
             - agent    (AI Agent产品项目)
             - web      (Web应用项目) 
             - mobile   (移动应用项目)
             - general  (通用项目，默认值)

示例:
  $0 /path/to/my-project agent
  $0 /path/to/web-app web
  $0 /path/to/mobile-app mobile

功能:
  ✅ 复制开发规范文档到项目
  ✅ 生成项目专用的CLAUDE.md配置
  ✅ 配置Git hooks和IDE设置
  ✅ 创建项目启动检查清单
  ✅ 设置Agent产品开发模板（agent类型）

EOF
}

# 验证参数
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -lt 1 ]; then
    show_help
    exit 0
fi

PROJECT_PATH="$1"
PROJECT_TYPE="${2:-general}"

# 验证项目路径
if [ ! -d "$PROJECT_PATH" ]; then
    print_error "项目路径不存在: $PROJECT_PATH"
    echo "请确保项目目录已创建"
    exit 1
fi

# 验证项目类型
case "$PROJECT_TYPE" in
    agent|web|mobile|general)
        ;;
    *)
        print_error "不支持的项目类型: $PROJECT_TYPE"
        echo "支持的类型: agent, web, mobile, general"
        exit 1
        ;;
esac

echo "🚀 开始为项目集成AI开发规范..."
echo "📁 项目路径: $PROJECT_PATH"
echo "🏷️  项目类型: $PROJECT_TYPE"
echo ""

# 获取项目名称
PROJECT_NAME=$(basename "$PROJECT_PATH")

# 1. 创建docs目录结构
print_step "创建文档目录结构"
mkdir -p "$PROJECT_PATH/docs/standards"
mkdir -p "$PROJECT_PATH/docs/decisions"
mkdir -p "$PROJECT_PATH/docs/templates"
mkdir -p "$PROJECT_PATH/.vscode"
mkdir -p "$PROJECT_PATH/.git/hooks" 2>/dev/null || true

print_success "文档目录结构创建完成"

# 2. 复制核心规范文档
print_step "复制核心开发规范文档"
cp -r "$STANDARDS_DIR/docs/"* "$PROJECT_PATH/docs/standards/"
cp -r "$STANDARDS_DIR/templates/"* "$PROJECT_PATH/docs/templates/"
cp -r "$STANDARDS_DIR/configs/"* "$PROJECT_PATH/" 2>/dev/null || true

print_success "开发规范文档复制完成"

# 3. 生成项目专用的CLAUDE.md
print_step "生成项目专用的CLAUDE.md配置"

# 读取项目基本信息
read -p "📝 请输入项目描述: " PROJECT_DESCRIPTION
read -p "🎯 请输入主要技术栈 (如: React+Node.js): " TECH_STACK
read -p "👥 请输入开发者姓名: " DEVELOPER_NAME

# 生成CLAUDE.md
cat > "$PROJECT_PATH/CLAUDE.md" << EOF
# Claude AI协作配置文件

## 🎯 项目信息
- **项目名称**: $PROJECT_NAME
- **项目类型**: $PROJECT_TYPE  
- **项目描述**: $PROJECT_DESCRIPTION
- **技术栈**: $TECH_STACK
- **开发者**: $DEVELOPER_NAME
- **创建时间**: $(date +"%Y-%m-%d")

## 📋 开发规范
本项目遵循AI开发标准，相关规范文档位于 \`docs/standards/\` 目录。

### 核心规范文件
- [开发最佳实践](./docs/standards/DEVELOPMENT_BEST_PRACTICES.md)
- [项目工作流程](./docs/standards/PROJECT_WORKFLOW.md)
- [技术决策模板](./docs/standards/TECHNICAL_DECISIONS_TEMPLATE.md)
- [上下文工程指南](./docs/standards/CONTEXT_ENGINEERING_GUIDE.md)
$(if [ "$PROJECT_TYPE" = "agent" ]; then
echo "- [AI Agent开发指南](./docs/standards/AI_AGENT_DEVELOPMENT_GUIDE.md)"
echo "- [Agent PRD模板](./docs/templates/AGENT_PRD_TEMPLATE.md)"
fi)

## 🤖 Claude协作指南

### 上下文信息
当与Claude协作时，请提供以下上下文：

1. **项目背景**: $PROJECT_DESCRIPTION
2. **技术栈**: $TECH_STACK
3. **当前任务**: [请在每次对话时明确当前要解决的具体问题]
4. **相关文件**: [请指出相关的代码文件或文档]

### 工作流程
1. **问题描述**: 清晰描述要解决的问题
2. **现状分析**: 提供相关的代码片段或错误信息
3. **期望结果**: 明确期望达到的目标
4. **约束条件**: 说明技术限制或业务要求

### 代码规范要求
- 遵循项目现有的代码风格
- 添加必要的注释和文档
- 确保代码的可测试性
- 考虑错误处理和边界情况
$(if [ "$PROJECT_TYPE" = "agent" ]; then
echo "- 遵循Agent产品开发方法论"
echo "- 明确Agent能力边界和交互设计"
fi)

## 📊 项目检查清单

### 开发准备
- [ ] 阅读开发规范文档
- [ ] 配置开发环境
- [ ] 设置Git hooks
- [ ] 配置IDE设置

$(if [ "$PROJECT_TYPE" = "agent" ]; then
cat << 'AGENT_CHECKLIST'
### Agent项目专用检查清单
- [ ] 完成Agent身份设计
- [ ] 定义能力边界和转接条件
- [ ] 设计对话交互流程
- [ ] 建立知识体系架构
- [ ] 实现工具调用能力
- [ ] 设置测试验证框架
- [ ] 建立成功指标体系

AGENT_CHECKLIST
fi)

### 质量保证
- [ ] 代码审查完成
- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] 文档更新完整

## 🔗 相关资源
- [AI开发规范Wiki](http://localhost:1024) - 本地知识库
- [技术决策记录](./docs/decisions/) - 项目技术决策历史
- [开发模板](./docs/templates/) - 常用开发模板

---
*此文件由AI开发规范自动生成，请根据项目实际情况调整*
*最后更新: $(date +"%Y-%m-%d %H:%M:%S")*
EOF

print_success "CLAUDE.md配置文件生成完成"

# 4. 配置Git hooks
print_step "配置Git hooks"
if [ -d "$PROJECT_PATH/.git" ]; then
    # Pre-commit hook
    cat > "$PROJECT_PATH/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# AI开发规范 - Pre-commit检查

echo "🔍 运行pre-commit检查..."

# 检查是否有CLAUDE.md文件
if [ ! -f "CLAUDE.md" ]; then
    echo "❌ 缺少CLAUDE.md配置文件"
    echo "请运行项目初始化脚本创建该文件"
    exit 1
fi

# 检查提交信息格式（如果有的话）
# 这里可以添加更多检查逻辑

echo "✅ Pre-commit检查通过"
EOF

    chmod +x "$PROJECT_PATH/.git/hooks/pre-commit"
    print_success "Git hooks配置完成"
else
    print_warning "项目未初始化Git，跳过Git hooks配置"
fi

# 5. 配置VSCode设置
print_step "配置VSCode开发环境"
cat > "$PROJECT_PATH/.vscode/settings.json" << EOF
{
    "files.associations": {
        "CLAUDE.md": "markdown"
    },
    "markdown.preview.breaks": true,
    "editor.rulers": [80, 120],
    "editor.formatOnSave": true,
    "files.autoSave": "onFocusChange",
    "explorer.fileNesting.enabled": true,
    "explorer.fileNesting.patterns": {
        "CLAUDE.md": "docs/standards/*, docs/templates/*"
    }
}
EOF

# VSCode任务配置
cat > "$PROJECT_PATH/.vscode/tasks.json" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "启动开发规范Wiki",
            "type": "shell",
            "command": "python3",
            "args": [
                "${workspaceFolder}/docs/standards/../../../scripts/simple-wiki.py"
            ],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            },
            "problemMatcher": []
        }
    ]
}
EOF

print_success "VSCode配置完成"

# 6. 创建项目README模板
if [ ! -f "$PROJECT_PATH/README.md" ]; then
    print_step "创建项目README模板"
    cat > "$PROJECT_PATH/README.md" << EOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## 🚀 快速开始

### 环境要求
- $TECH_STACK

### 安装依赖
\`\`\`bash
# 添加你的安装命令
\`\`\`

### 开发运行
\`\`\`bash
# 添加你的启动命令
\`\`\`

## 📚 开发规范

本项目遵循AI开发标准，详细规范请参考：
- [开发规范文档](./docs/standards/)
- [Claude协作指南](./CLAUDE.md)

### 开发前必读
1. [开发最佳实践](./docs/standards/DEVELOPMENT_BEST_PRACTICES.md)
2. [项目工作流程](./docs/standards/PROJECT_WORKFLOW.md)
$(if [ "$PROJECT_TYPE" = "agent" ]; then
echo "3. [AI Agent开发指南](./docs/standards/AI_AGENT_DEVELOPMENT_GUIDE.md)"
fi)

### 工具和资源
- 📖 [本地开发规范Wiki](http://localhost:1024)
- 🔧 [项目模板](./docs/templates/)
- 📋 [技术决策记录](./docs/decisions/)

## 🤖 AI协作

本项目配置了Claude AI协作环境，使用时请：
1. 阅读 [CLAUDE.md](./CLAUDE.md) 了解协作规范
2. 遵循上下文工程最佳实践
3. 参考开发规范进行编程

## 📈 项目状态

- 开发阶段: 初始化
- 最后更新: $(date +"%Y-%m-%d")
- 维护者: $DEVELOPER_NAME

---
*此项目使用AI开发标准，自动集成开发规范和最佳实践*
EOF
    print_success "README.md模板创建完成"
fi

# 7. Agent项目特殊配置
if [ "$PROJECT_TYPE" = "agent" ]; then
    print_step "配置Agent项目专用模板"
    
    # 创建Agent PRD文件
    cp "$STANDARDS_DIR/templates/AGENT_PRD_TEMPLATE.md" "$PROJECT_PATH/docs/${PROJECT_NAME}-Agent-PRD.md"
    
    # 创建Agent开发检查清单
    cat > "$PROJECT_PATH/docs/AGENT_DEVELOPMENT_CHECKLIST.md" << 'EOF'
# Agent开发检查清单

## 📋 开发阶段检查

### Phase 1: 需求设计 ✅/❌
- [ ] 完成Agent身份设计（角色、能力边界）
- [ ] 定义核心业务场景和用户画像
- [ ] 设计意图识别和分类体系
- [ ] 规划对话流程和澄清策略
- [ ] 建立知识图谱结构

### Phase 2: 系统实现 ✅/❌
- [ ] 实现意图识别模块
- [ ] 开发对话管理系统
- [ ] 构建知识检索引擎
- [ ] 集成外部工具和API
- [ ] 实现推理决策逻辑

### Phase 3: 测试验证 ✅/❌
- [ ] 功能测试用例覆盖
- [ ] 对话质量评估
- [ ] 边界识别测试
- [ ] 性能压力测试
- [ ] 用户验收测试

### Phase 4: 上线部署 ✅/❌
- [ ] 监控指标配置
- [ ] 日志和分析系统
- [ ] 错误处理和恢复
- [ ] 用户反馈收集
- [ ] 持续学习机制

## 🎯 质量标准

### 核心指标要求
- 任务成功率 ≥ 80%
- 意图识别准确率 ≥ 90%
- 响应时间 ≤ 2秒
- 用户满意度 ≥ 4.0分

### 代码质量要求
- 单元测试覆盖率 ≥ 80%
- 代码审查通过率 100%
- 文档完整性 ≥ 90%
- 性能基准达标

---
*基于AI Agent开发最佳实践制作*
EOF
    
    print_success "Agent项目专用配置完成"
fi

# 8. 配置GitHub Workflows（如果是Git仓库）
if [ -d "$PROJECT_PATH/.git" ]; then
    print_step "配置GitHub Actions工作流"
    mkdir -p "$PROJECT_PATH/.github/workflows"
    
    # 复制工作流模板
    if [ -d "$STANDARDS_DIR/templates/github-workflows" ]; then
        cp "$STANDARDS_DIR/templates/github-workflows/"*.yml "$PROJECT_PATH/.github/workflows/"
        print_success "GitHub Actions工作流已配置"
        
        echo "  📋 已配置的工作流:"
        echo "    - MVP自动备份和版本管理"
        echo "    - 项目健康度检查"
        echo "    - AI开发规范合规检查"
    fi
else
    print_warning "非Git仓库，跳过GitHub Actions配置"
fi

# 9. 创建MVP管理脚本链接
print_step "配置MVP管理工具"
if [ -f "$STANDARDS_DIR/scripts/mvp-backup.sh" ]; then
    cp "$STANDARDS_DIR/scripts/mvp-backup.sh" "$PROJECT_PATH/scripts/"
    chmod +x "$PROJECT_PATH/scripts/mvp-backup.sh"
    print_success "MVP备份脚本已配置"
fi

if [ -f "$STANDARDS_DIR/scripts/mvp-check.sh" ]; then
    cp "$STANDARDS_DIR/scripts/mvp-check.sh" "$PROJECT_PATH/scripts/"
    chmod +x "$PROJECT_PATH/scripts/mvp-check.sh"
    print_success "MVP检查脚本已配置"
fi

# 创建MVP工具的快捷方式
cat > "$PROJECT_PATH/mvp-tools.sh" << 'EOF'
#!/bin/bash
# MVP管理工具快捷方式

case "$1" in
    "backup"|"b")
        shift
        ./scripts/mvp-backup.sh "$@"
        ;;
    "check"|"c")
        ./scripts/mvp-check.sh
        ;;
    "status"|"s")
        if [ -f "MVP_STATUS.md" ]; then
            cat MVP_STATUS.md
        else
            echo "尚未创建MVP状态文件"
        fi
        ;;
    *)
        echo "MVP管理工具"
        echo "用法: $0 {backup|check|status} [参数...]"
        echo ""
        echo "命令:"
        echo "  backup, b    执行MVP备份"
        echo "  check, c     检查MVP状态"
        echo "  status, s    显示MVP状态"
        echo ""
        echo "示例:"
        echo "  $0 backup \"完成用户登录功能\""
        echo "  $0 check"
        echo "  $0 status"
        ;;
esac
EOF

chmod +x "$PROJECT_PATH/mvp-tools.sh"
print_success "MVP管理工具快捷方式已创建"

# 10. 最终设置和验证
print_step "执行最终设置和验证"

# 设置文件权限
find "$PROJECT_PATH/docs" -name "*.md" -exec chmod 644 {} \;
find "$PROJECT_PATH/.vscode" -name "*.json" -exec chmod 644 {} \;

# 创建快速启动脚本
cat > "$PROJECT_PATH/dev-start.sh" << 'EOF'
#!/bin/bash
# 项目开发快速启动脚本

echo "🚀 启动开发环境..."

# 启动开发规范Wiki（如果需要）
if command -v python3 &> /dev/null; then
    echo "📖 启动开发规范Wiki: http://localhost:1024"
    # python3 docs/standards/../../../scripts/simple-wiki.py &
fi

# 这里可以添加你的项目启动命令
# 例如: npm start, python app.py 等

echo "✅ 开发环境准备完成"
echo "📚 开发规范: 查看 CLAUDE.md 和 docs/standards/"
echo "🤖 AI协作: 参考 CLAUDE.md 中的协作指南"
EOF

chmod +x "$PROJECT_PATH/dev-start.sh"

print_success "最终设置完成"

# 输出总结信息
echo ""
echo "🎉 项目规范集成完成！"
echo ""
echo "📁 已创建的文件和目录:"
echo "   ├── CLAUDE.md                 # Claude AI协作配置"
echo "   ├── README.md                 # 项目说明文档"
echo "   ├── dev-start.sh              # 快速启动脚本"
echo "   ├── mvp-tools.sh              # MVP管理工具快捷方式"
echo "   ├── docs/standards/           # 开发规范文档"
echo "   ├── docs/templates/           # 开发模板"
echo "   ├── docs/decisions/           # 技术决策记录"
$(if [ "$PROJECT_TYPE" = "agent" ]; then
echo "   ├── docs/${PROJECT_NAME}-Agent-PRD.md  # Agent产品需求文档"
echo "   ├── docs/AGENT_DEVELOPMENT_CHECKLIST.md  # Agent开发检查清单"
fi)
echo "   ├── scripts/mvp-backup.sh     # MVP自动备份脚本"
echo "   ├── scripts/mvp-check.sh      # MVP状态检查脚本"
echo "   ├── .github/workflows/        # GitHub Actions工作流"
echo "   ├── .vscode/settings.json     # VSCode配置"
echo "   ├── .vscode/tasks.json        # VSCode任务"
echo "   └── .git/hooks/pre-commit     # Git hooks"
echo ""
echo "🚀 下一步操作:"
echo "   1. 阅读 CLAUDE.md 了解AI协作规范"
echo "   2. 查看 docs/standards/ 中的开发规范"
$(if [ "$PROJECT_TYPE" = "agent" ]; then
echo "   3. 使用 Agent PRD模板 撰写产品需求"
echo "   4. 参考 Agent开发检查清单 进行开发"
fi)
echo "   3. 启动开发规范Wiki: http://localhost:1024"
echo "   4. 使用MVP管理工具: ./mvp-tools.sh"
echo "   5. 开始愉快的AI协作开发！"
echo ""
echo "💡 MVP管理快速使用:"
echo "   ./mvp-tools.sh backup \"完成功能描述\"  # 备份MVP"
echo "   ./mvp-tools.sh check                    # 检查MVP状态"  
echo "   ./mvp-tools.sh status                   # 查看MVP状态"
echo ""
print_success "集成完成，祝开发顺利！🎯"
EOF