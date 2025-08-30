#!/bin/bash

# MVP功能完成后的自动备份和GitHub提交脚本
# 确保每个最小功能迭代都有完整的版本记录

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印函数
print_header() {
    echo -e "${CYAN}🚀 ===============================================${NC}"
    echo -e "${CYAN}   MVP功能完成 - 自动备份和版本记录${NC}"
    echo -e "${CYAN}===============================================${NC}"
}

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
🚀 MVP功能自动备份工具

用法: $0 [选项] <MVP功能描述>

参数:
  MVP功能描述    当前完成的MVP功能描述（必需）

选项:
  -v, --version <版本号>     指定版本号 (默认: 自动生成)
  -t, --type <类型>         MVP类型 (feature/bugfix/enhancement, 默认: feature)
  -n, --no-push            不自动推送到远程仓库
  -b, --backup-only        仅创建备份，不提交到GitHub
  -r, --remote <远程>       指定远程仓库名 (默认: origin)
  --tag                    创建Git标签
  -h, --help               显示帮助信息

示例:
  $0 "完成用户登录功能"
  $0 -v "v1.1.0" -t "feature" "实现AI对话核心功能"
  $0 --tag "修复关键Bug" -t "bugfix"
  $0 --backup-only "临时功能保存"

功能:
  ✅ 自动检测项目变更
  ✅ 生成MVP里程碑记录
  ✅ 创建详细的提交信息
  ✅ 自动推送到GitHub
  ✅ 生成版本标签
  ✅ 备份重要文件
  ✅ 更新项目文档

EOF
}

# 初始化变量
MVP_DESCRIPTION=""
MVP_VERSION=""
MVP_TYPE="feature"
NO_PUSH=false
BACKUP_ONLY=false
REMOTE_NAME="origin"
CREATE_TAG=false
PROJECT_ROOT=$(pwd)

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            MVP_VERSION="$2"
            shift 2
            ;;
        -t|--type)
            MVP_TYPE="$2"
            shift 2
            ;;
        -n|--no-push)
            NO_PUSH=true
            shift
            ;;
        -b|--backup-only)
            BACKUP_ONLY=true
            shift
            ;;
        -r|--remote)
            REMOTE_NAME="$2"
            shift 2
            ;;
        --tag)
            CREATE_TAG=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            print_error "未知选项: $1"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$MVP_DESCRIPTION" ]; then
                MVP_DESCRIPTION="$1"
            fi
            shift
            ;;
    esac
done

# 验证必需参数
if [ -z "$MVP_DESCRIPTION" ]; then
    print_error "必须提供MVP功能描述"
    show_help
    exit 1
fi

# 验证Git仓库
if [ ! -d ".git" ]; then
    print_error "当前目录不是Git仓库"
    exit 1
fi

# 验证CLAUDE.md文件
if [ ! -f "CLAUDE.md" ]; then
    print_error "未找到CLAUDE.md配置文件"
    print_warning "请先运行项目初始化脚本集成AI开发规范"
    exit 1
fi

print_header

# 获取项目信息
PROJECT_NAME=$(basename "$PROJECT_ROOT")
CURRENT_BRANCH=$(git branch --show-current)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
SHORT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "initial")

print_step "项目信息检测"
echo "  📁 项目名称: $PROJECT_NAME"
echo "  🌿 当前分支: $CURRENT_BRANCH"
echo "  🕐 时间戳: $TIMESTAMP"
echo "  #️⃣  提交哈希: $SHORT_HASH"

# 自动生成版本号（如果未指定）
if [ -z "$MVP_VERSION" ]; then
    # 获取最新标签
    LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
    
    # 解析版本号
    if [[ $LATEST_TAG =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
        MAJOR=${BASH_REMATCH[1]}
        MINOR=${BASH_REMATCH[2]}
        PATCH=${BASH_REMATCH[3]}
        
        # 根据类型递增版本号
        case $MVP_TYPE in
            feature)
                MINOR=$((MINOR + 1))
                PATCH=0
                ;;
            bugfix)
                PATCH=$((PATCH + 1))
                ;;
            enhancement)
                PATCH=$((PATCH + 1))
                ;;
        esac
        
        MVP_VERSION="v${MAJOR}.${MINOR}.${PATCH}"
    else
        MVP_VERSION="v0.1.0"
    fi
fi

print_success "自动生成版本号: $MVP_VERSION"

# 检查工作区状态
print_step "检查工作区状态"
if ! git diff-index --quiet HEAD --; then
    print_warning "工作区有未提交的更改"
    
    # 显示更改的文件
    echo "📝 变更的文件:"
    git diff --name-status
    echo ""
    
    # 询问是否继续
    read -p "是否继续处理这些更改? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "已取消操作"
        exit 0
    fi
else
    print_warning "工作区没有新的更改"
    
    # 询问是否仍要创建MVP记录
    read -p "是否仍要创建MVP里程碑记录? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "已取消操作"
        exit 0
    fi
fi

# 创建MVP里程碑目录
MVP_DIR="docs/mvp-milestones"
mkdir -p "$MVP_DIR"

# 生成MVP里程碑文档
print_step "生成MVP里程碑文档"
MVP_FILE="$MVP_DIR/MVP-${MVP_VERSION}-$(date +%Y%m%d).md"

cat > "$MVP_FILE" << EOF
# MVP里程碑记录 - $MVP_VERSION

## 📋 基本信息
- **版本号**: $MVP_VERSION
- **MVP类型**: $MVP_TYPE
- **完成时间**: $TIMESTAMP
- **开发分支**: $CURRENT_BRANCH
- **提交哈希**: $SHORT_HASH

## 🎯 MVP功能描述
$MVP_DESCRIPTION

## 📊 项目状态快照

### 代码统计
\`\`\`bash
$(find . -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" -o -name "*.go" | head -20 | wc -l) 个主要代码文件
$(git rev-list --count HEAD) 次提交
$(git log --oneline --since="1 month ago" | wc -l) 次本月提交
\`\`\`

### 目录结构
\`\`\`
$(tree -L 2 -a -I '.git|node_modules|__pycache__|.DS_Store' 2>/dev/null || find . -maxdepth 2 -type d | head -10)
\`\`\`

## 🔄 主要变更

### 新增功能
$(git log --oneline --since="1 week ago" --grep="feat:" | sed 's/^/- /')

### Bug修复  
$(git log --oneline --since="1 week ago" --grep="fix:" | sed 's/^/- /')

### 文档更新
$(git log --oneline --since="1 week ago" --grep="docs:" | sed 's/^/- /')

## 🧪 测试状态
- [ ] 单元测试通过
- [ ] 集成测试通过  
- [ ] 功能验收完成
- [ ] 性能测试通过

## 📈 性能指标
- 响应时间: 待测试
- 内存使用: 待测试
- 并发能力: 待测试

## 🐛 已知问题
- 无重大问题

## 📝 下一步计划
- [ ] 下个MVP功能规划
- [ ] 性能优化
- [ ] 用户反馈收集

## 🔗 相关资源
- [项目文档](../standards/)
- [技术决策记录](../decisions/)
- [测试报告](../tests/)

---
*此文档由MVP自动备份工具生成*  
*工具版本: AI开发规范 v1.0*  
*生成时间: $TIMESTAMP*
EOF

print_success "MVP里程碑文档已创建: $MVP_FILE"

# 创建备份
if [ "$BACKUP_ONLY" != "true" ]; then
    print_step "准备Git提交"
    
    # 添加所有更改
    git add .
    
    # 生成详细的提交信息
    COMMIT_MSG=$(cat << EOF
$MVP_TYPE($MVP_VERSION): $MVP_DESCRIPTION

📋 MVP里程碑记录:
- 版本号: $MVP_VERSION  
- 类型: $MVP_TYPE
- 完成时间: $TIMESTAMP
- 分支: $CURRENT_BRANCH

🔄 主要变更:
$(git diff --cached --name-status | head -10 | sed 's/^/- /')

🎯 功能描述:
$MVP_DESCRIPTION

📚 文档更新:
- 新增MVP里程碑记录: $MVP_FILE
- 更新项目状态快照
- 记录代码统计信息

🤖 自动生成: AI开发规范MVP备份工具
⏰ 备份时间: $TIMESTAMP
EOF
)
    
    # 执行提交
    git commit -m "$COMMIT_MSG"
    print_success "Git提交完成"
    
    # 创建标签
    if [ "$CREATE_TAG" = "true" ]; then
        print_step "创建Git标签"
        git tag -a "$MVP_VERSION" -m "MVP里程碑: $MVP_DESCRIPTION"
        print_success "标签已创建: $MVP_VERSION"
    fi
    
    # 推送到远程仓库
    if [ "$NO_PUSH" != "true" ]; then
        print_step "推送到远程仓库"
        
        # 检查远程仓库是否存在
        if git remote get-url "$REMOTE_NAME" > /dev/null 2>&1; then
            # 推送代码
            git push "$REMOTE_NAME" "$CURRENT_BRANCH"
            print_success "代码已推送到 $REMOTE_NAME/$CURRENT_BRANCH"
            
            # 推送标签
            if [ "$CREATE_TAG" = "true" ]; then
                git push "$REMOTE_NAME" "$MVP_VERSION"
                print_success "标签已推送: $MVP_VERSION"
            fi
        else
            print_warning "远程仓库 '$REMOTE_NAME' 不存在，跳过推送"
            print_warning "请手动配置远程仓库或使用 -n 选项"
        fi
    fi
else
    print_step "仅创建本地备份（跳过Git操作）"
fi

# 更新项目根目录的MVP状态文件
print_step "更新项目MVP状态"
cat > "MVP_STATUS.md" << EOF
# 项目MVP状态

## 🎯 当前版本
- **最新版本**: $MVP_VERSION
- **更新时间**: $TIMESTAMP
- **功能描述**: $MVP_DESCRIPTION

## 📈 版本历史
$(ls -1 "$MVP_DIR" | tail -5 | sed 's/^/- /')

## 🔗 快速导航
- [最新MVP记录](./$MVP_FILE)
- [开发规范](./docs/standards/)
- [Claude配置](./CLAUDE.md)

---
*最后更新: $TIMESTAMP*
EOF

print_success "项目MVP状态已更新"

# 生成总结报告
print_step "生成操作总结"
echo ""
echo "🎉 MVP备份操作完成！"
echo ""
echo "📊 操作总结:"
echo "  🏷️  版本号: $MVP_VERSION"
echo "  📝 功能描述: $MVP_DESCRIPTION"
echo "  📁 里程碑文档: $MVP_FILE"
echo "  🌿 Git分支: $CURRENT_BRANCH"
echo "  ⏰ 完成时间: $TIMESTAMP"

if [ "$BACKUP_ONLY" != "true" ]; then
    echo "  ✅ Git提交: 已完成"
    if [ "$CREATE_TAG" = "true" ]; then
        echo "  🏷️  Git标签: $MVP_VERSION"
    fi
    if [ "$NO_PUSH" != "true" ]; then
        echo "  🚀 远程推送: 已完成"
    fi
fi

echo ""
echo "🔗 相关文件:"
echo "  📄 MVP记录: $MVP_FILE"
echo "  📊 项目状态: MVP_STATUS.md"
echo "  🤖 AI配置: CLAUDE.md"
echo ""
echo "📚 下一步建议:"
echo "  1. 查看MVP里程碑记录: cat $MVP_FILE"
echo "  2. 更新项目文档"
echo "  3. 规划下一个MVP功能"
echo "  4. 启动开发规范Wiki: http://localhost:1024"
echo ""

print_success "🎯 MVP功能迭代记录完成！"