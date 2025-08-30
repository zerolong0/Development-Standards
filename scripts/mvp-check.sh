#!/bin/bash

# MVP完成度检查和提醒脚本
# 帮助团队跟踪MVP进度，提醒定期备份

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 打印函数
print_header() {
    echo -e "${CYAN}📊 ===============================================${NC}"
    echo -e "${CYAN}   MVP进度检查和备份提醒${NC}"
    echo -e "${CYAN}===============================================${NC}"
}

print_step() {
    echo -e "${BLUE}🔍 $1${NC}"
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

# 获取项目信息
PROJECT_NAME=$(basename "$(pwd)")
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "no-git")

print_header
echo "🔍 检查项目: $PROJECT_NAME"
echo "🌿 当前分支: $CURRENT_BRANCH"
echo ""

# 检查是否是Git仓库
if [ ! -d ".git" ]; then
    print_error "当前目录不是Git仓库"
    exit 1
fi

# 检查CLAUDE.md文件
if [ ! -f "CLAUDE.md" ]; then
    print_error "未找到CLAUDE.md配置文件"
    print_warning "请先运行项目初始化脚本集成AI开发规范"
    exit 1
fi

# 检查MVP里程碑目录
MVP_DIR="docs/mvp-milestones"
if [ ! -d "$MVP_DIR" ]; then
    print_warning "未找到MVP里程碑目录"
    print_step "创建MVP里程碑目录"
    mkdir -p "$MVP_DIR"
    print_success "MVP里程碑目录已创建: $MVP_DIR"
fi

# 统计MVP记录
print_step "统计MVP里程碑记录"
MVP_COUNT=$(find "$MVP_DIR" -name "MVP-*.md" | wc -l)
echo "  📈 已记录MVP: $MVP_COUNT 个"

if [ $MVP_COUNT -gt 0 ]; then
    echo "  📝 最新MVP记录:"
    ls -1t "$MVP_DIR"/MVP-*.md | head -3 | sed 's/^/    - /'
fi

# 检查最后一次备份时间
print_step "检查最后备份时间"
if [ $MVP_COUNT -gt 0 ]; then
    LATEST_MVP=$(ls -1t "$MVP_DIR"/MVP-*.md | head -1)
    LATEST_DATE=$(stat -c %Y "$LATEST_MVP" 2>/dev/null || stat -f %m "$LATEST_MVP" 2>/dev/null || echo "0")
    CURRENT_DATE=$(date +%s)
    DAYS_DIFF=$(( (CURRENT_DATE - LATEST_DATE) / 86400 ))
    
    echo "  📅 最后备份: $DAYS_DIFF 天前"
    
    if [ $DAYS_DIFF -gt 7 ]; then
        print_warning "距离上次MVP备份已超过一周"
        echo "    建议执行MVP备份: ./scripts/mvp-backup.sh \"功能描述\""
    elif [ $DAYS_DIFF -gt 3 ]; then
        print_warning "距离上次MVP备份已超过3天"
    else
        print_success "MVP备份时间正常"
    fi
else
    print_warning "尚未创建任何MVP里程碑记录"
    echo "    建议执行首次备份: ./scripts/mvp-backup.sh \"初始版本\""
fi

# 检查Git状态
print_step "检查代码变更状态"
UNCOMMITTED_CHANGES=$(git status --porcelain | wc -l)
COMMITS_AHEAD=$(git rev-list @{upstream}..HEAD 2>/dev/null | wc -l || echo "0")

echo "  📝 未提交更改: $UNCOMMITTED_CHANGES 项"
echo "  🚀 待推送提交: $COMMITS_AHEAD 个"

if [ $UNCOMMITTED_CHANGES -gt 0 ]; then
    print_warning "发现未提交的更改"
    echo "    📋 更改的文件:"
    git status --porcelain | head -5 | sed 's/^/      /'
    if [ $UNCOMMITTED_CHANGES -gt 5 ]; then
        echo "      ... 还有 $((UNCOMMITTED_CHANGES - 5)) 个文件"
    fi
fi

if [ $COMMITS_AHEAD -gt 0 ]; then
    print_warning "有 $COMMITS_AHEAD 个提交待推送到远程仓库"
fi

# 分析提交历史，判断是否需要MVP备份
print_step "分析开发活动"
RECENT_COMMITS=$(git log --oneline --since="3 days ago" | wc -l)
FEATURE_COMMITS=$(git log --oneline --since="1 week ago" --grep="feat:" | wc -l)
FIX_COMMITS=$(git log --oneline --since="1 week ago" --grep="fix:" | wc -l)

echo "  📊 最近3天提交: $RECENT_COMMITS 个"
echo "  🆕 本周新功能: $FEATURE_COMMITS 个"  
echo "  🐛 本周Bug修复: $FIX_COMMITS 个"

# MVP备份建议
print_step "MVP备份建议评估"
BACKUP_SCORE=0

# 评分规则
if [ $FEATURE_COMMITS -gt 0 ]; then
    BACKUP_SCORE=$((BACKUP_SCORE + 30))
fi

if [ $FIX_COMMITS -gt 2 ]; then
    BACKUP_SCORE=$((BACKUP_SCORE + 20))
fi

if [ $RECENT_COMMITS -gt 5 ]; then
    BACKUP_SCORE=$((BACKUP_SCORE + 25))
fi

if [ $DAYS_DIFF -gt 7 ]; then
    BACKUP_SCORE=$((BACKUP_SCORE + 25))
fi

echo "  🎯 备份推荐度: $BACKUP_SCORE/100"

if [ $BACKUP_SCORE -ge 70 ]; then
    print_error "强烈建议立即执行MVP备份！"
    echo "    💡 推荐命令:"
    echo "    ./scripts/mvp-backup.sh --tag \"完成重要功能迭代\""
elif [ $BACKUP_SCORE -ge 50 ]; then
    print_warning "建议考虑执行MVP备份"
    echo "    💡 推荐命令:"
    echo "    ./scripts/mvp-backup.sh \"最新功能更新\""
elif [ $BACKUP_SCORE -ge 30 ]; then
    print_success "当前开发进度适中"
    echo "    继续开发，注意定期备份"
else
    print_success "项目状态良好"
fi

# 检查项目健康度
print_step "项目健康度检查"
HEALTH_SCORE=100

# 检查文档完整性
if [ ! -f "README.md" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE - 10))
    print_warning "缺少README.md文档"
fi

if [ ! -d "docs/standards" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE - 15))
    print_warning "缺少开发规范文档"
fi

# 检查Git配置
if [ ! -f ".git/hooks/pre-commit" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE - 10))
    print_warning "缺少Git pre-commit hook"
fi

# 检查VSCode配置
if [ ! -d ".vscode" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE - 5))
    print_warning "缺少VSCode配置"
fi

echo "  💚 项目健康度: $HEALTH_SCORE/100"

if [ $HEALTH_SCORE -ge 90 ]; then
    print_success "项目配置完善"
elif [ $HEALTH_SCORE -ge 70 ]; then
    print_warning "项目配置基本完整，建议完善不足项"
else
    print_error "项目配置不完整，建议运行初始化脚本"
    echo "    🔧 修复命令: /path/to/Development-Standards/scripts/init-project.sh $(pwd)"
fi

# 生成操作建议
echo ""
print_step "🎯 操作建议"

if [ $BACKUP_SCORE -ge 50 ] && [ $UNCOMMITTED_CHANGES -gt 0 ]; then
    echo "  1. 提交当前更改"
    echo "  2. 执行MVP备份"
    echo "  3. 推送到远程仓库"
elif [ $UNCOMMITTED_CHANGES -gt 0 ]; then
    echo "  1. 提交当前更改"
    echo "  2. 继续开发"
elif [ $COMMITS_AHEAD -gt 0 ]; then
    echo "  1. 推送待提交内容到远程仓库"
    echo "  2. 考虑执行MVP备份"
else
    echo "  1. 继续开发新功能"
    echo "  2. 定期检查MVP进度"
fi

# 显示有用的命令
echo ""
print_step "🛠️  有用的命令"
echo "  📊 查看详细状态: git status"
echo "  📝 执行MVP备份: ./scripts/mvp-backup.sh \"功能描述\""
echo "  🔍 查看提交历史: git log --oneline -10"
echo "  📚 启动规范Wiki: python3 scripts/simple-wiki.py"
echo "  ⚙️  检查项目配置: ./scripts/mvp-check.sh"

echo ""
print_success "MVP进度检查完成！"

# 返回适当的退出代码
if [ $BACKUP_SCORE -ge 70 ]; then
    exit 2  # 需要立即备份
elif [ $BACKUP_SCORE -ge 50 ]; then
    exit 1  # 建议备份
else
    exit 0  # 状态良好
fi