#!/bin/bash

# 移动端跨平台项目初始化脚本
# 支持Flutter、React Native、uni-app、Taro四大框架
# 作者: Development-Standards Team
# 版本: 1.0.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 图标定义
SUCCESS="✅"
ERROR="❌"
WARNING="⚠️"
INFO="ℹ️"
ROCKET="🚀"
PHONE="📱"
GEAR="⚙️"
STAR="⭐"

# 脚本配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STANDARDS_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$STANDARDS_DIR/templates/mobile-cross-platform"

# 全局变量
PROJECT_PATH=""
PROJECT_NAME=""
FRAMEWORK=""
PLATFORMS=""
TEMPLATE_TYPE="basic"
INTERACTIVE_MODE=true
FORCE_OVERWRITE=false
VERBOSE=false

# 支持的框架
declare -A FRAMEWORKS=(
    ["flutter"]="Flutter - Google跨平台UI框架"
    ["react-native"]="React Native - Facebook跨平台框架"
    ["uni-app"]="uni-app - DCloud全平台统一开发框架"
    ["taro"]="Taro - 京东多端统一开发框架"
)

# 支持的平台
declare -A PLATFORMS_INFO=(
    ["ios"]="iOS App"
    ["android"]="Android App"
    ["web"]="Web H5"
    ["weapp"]="微信小程序"
    ["alipay"]="支付宝小程序"
    ["baidu"]="百度小程序"
    ["toutiao"]="字节小程序"
    ["qq"]="QQ小程序"
)

# 显示帮助信息
show_help() {
    cat << EOF
${CYAN}${PHONE} 移动端跨平台项目初始化脚本${NC}

${WHITE}用法:${NC}
  $0 [选项] [项目路径] [框架] [平台列表]

${WHITE}参数:${NC}
  项目路径    项目创建路径 (必需)
  框架        目标框架: flutter|react-native|uni-app|taro
  平台列表    目标平台: ios,android,web,weapp,alipay等

${WHITE}选项:${NC}
  -h, --help              显示此帮助信息
  -f, --force             强制覆盖已存在的项目
  -q, --quiet             静默模式，不显示详细输出
  -t, --template TYPE     模板类型: basic|enterprise|minimal
  -n, --no-interactive    非交互模式
  -v, --verbose           详细输出模式

${WHITE}示例:${NC}
  # 交互式创建项目
  $0 /path/to/my-app

  # 创建Flutter项目支持iOS和Android
  $0 /path/to/flutter-app flutter ios,android

  # 创建uni-app项目支持全平台
  $0 /path/to/uni-app uni-app weapp,alipay,h5,app

  # 使用企业级模板创建React Native项目
  $0 -t enterprise /path/to/rn-app react-native ios,android

${WHITE}支持的框架:${NC}
EOF

    for framework in "${!FRAMEWORKS[@]}"; do
        echo "  ${GREEN}${framework}${NC} - ${FRAMEWORKS[$framework]}"
    done

    echo ""
    echo "${WHITE}支持的平台:${NC}"
    for platform in "${!PLATFORMS_INFO[@]}"; do
        echo "  ${GREEN}${platform}${NC} - ${PLATFORMS_INFO[$platform]}"
    done
}

# 日志函数
log_info() {
    echo -e "${INFO} ${BLUE}$1${NC}"
}

log_success() {
    echo -e "${SUCCESS} ${GREEN}$1${NC}"
}

log_warning() {
    echo -e "${WARNING} ${YELLOW}$1${NC}"
}

log_error() {
    echo -e "${ERROR} ${RED}$1${NC}" >&2
}

log_step() {
    echo -e "${GEAR} ${WHITE}$1${NC}"
}

# 详细输出
verbose_log() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}[VERBOSE]${NC} $1"
    fi
}

# 检查依赖
check_dependencies() {
    log_step "检查系统依赖..."
    
    local missing_deps=()
    
    # 检查基础工具
    command -v node >/dev/null 2>&1 || missing_deps+=("Node.js")
    command -v npm >/dev/null 2>&1 || missing_deps+=("npm")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    
    # 根据框架检查特定依赖
    case $FRAMEWORK in
        "flutter")
            command -v flutter >/dev/null 2>&1 || missing_deps+=("Flutter SDK")
            ;;
        "react-native")
            command -v npx >/dev/null 2>&1 || missing_deps+=("npx")
            ;;
        "uni-app")
            command -v vue >/dev/null 2>&1 || missing_deps+=("Vue CLI")
            ;;
        "taro")
            command -v taro >/dev/null 2>&1 || missing_deps+=("Taro CLI")
            ;;
    esac
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "缺少以下依赖："
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "请先安装缺少的依赖，然后重新运行此脚本。"
        exit 1
    fi
    
    log_success "依赖检查通过"
}

# 环境检查
check_environment() {
    log_step "检查开发环境..."
    
    # 检查操作系统
    case "$(uname -s)" in
        Darwin*)
            verbose_log "检测到 macOS 系统"
            if [[ "$PLATFORMS" == *"ios"* ]]; then
                if ! command -v xcodebuild >/dev/null 2>&1; then
                    log_warning "未检测到 Xcode，iOS 开发需要安装 Xcode"
                fi
            fi
            ;;
        Linux*)
            verbose_log "检测到 Linux 系统"
            if [[ "$PLATFORMS" == *"ios"* ]]; then
                log_warning "Linux 系统无法进行 iOS 开发"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            verbose_log "检测到 Windows 系统"
            if [[ "$PLATFORMS" == *"ios"* ]]; then
                log_warning "Windows 系统无法进行 iOS 开发"
            fi
            ;;
    esac
    
    # 检查Android开发环境
    if [[ "$PLATFORMS" == *"android"* ]]; then
        if [ -z "$ANDROID_HOME" ]; then
            log_warning "未设置 ANDROID_HOME 环境变量"
        fi
    fi
    
    log_success "环境检查完成"
}

# 交互式框架选择
select_framework() {
    if [ -n "$FRAMEWORK" ]; then
        return 0
    fi
    
    echo ""
    echo "${STAR} ${WHITE}选择开发框架:${NC}"
    echo ""
    
    local options=()
    local descriptions=()
    local i=1
    
    for framework in "${!FRAMEWORKS[@]}"; do
        options+=("$framework")
        descriptions+=("${FRAMEWORKS[$framework]}")
        echo "  ${CYAN}$i)${NC} ${GREEN}$framework${NC} - ${FRAMEWORKS[$framework]}"
        ((i++))
    done
    
    echo ""
    while true; do
        read -p "请选择框架 [1-${#options[@]}]: " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            FRAMEWORK="${options[$((choice-1))]}"
            log_success "选择了框架: $FRAMEWORK"
            break
        else
            log_error "无效选择，请输入 1-${#options[@]} 之间的数字"
        fi
    done
}

# 交互式平台选择
select_platforms() {
    if [ -n "$PLATFORMS" ]; then
        return 0
    fi
    
    echo ""
    echo "${STAR} ${WHITE}选择目标平台 (多选，用逗号分隔):${NC}"
    echo ""
    
    # 根据框架显示支持的平台
    case $FRAMEWORK in
        "flutter")
            echo "  ${GREEN}1)${NC} ios      - iOS App"
            echo "  ${GREEN}2)${NC} android  - Android App"
            echo "  ${GREEN}3)${NC} web      - Web应用"
            echo "  ${GREEN}4)${NC} macos    - macOS应用 (实验性)"
            echo "  ${GREEN}5)${NC} windows  - Windows应用 (实验性)"
            echo "  ${GREEN}6)${NC} linux    - Linux应用 (实验性)"
            ;;
        "react-native")
            echo "  ${GREEN}1)${NC} ios      - iOS App"
            echo "  ${GREEN}2)${NC} android  - Android App"
            echo "  ${GREEN}3)${NC} web      - Web应用 (通过react-native-web)"
            ;;
        "uni-app")
            echo "  ${GREEN}1)${NC} ios      - iOS App"
            echo "  ${GREEN}2)${NC} android  - Android App"
            echo "  ${GREEN}3)${NC} web      - H5网页"
            echo "  ${GREEN}4)${NC} weapp    - 微信小程序"
            echo "  ${GREEN}5)${NC} alipay   - 支付宝小程序"
            echo "  ${GREEN}6)${NC} baidu    - 百度小程序"
            echo "  ${GREEN}7)${NC} toutiao  - 字节小程序"
            echo "  ${GREEN}8)${NC} qq       - QQ小程序"
            ;;
        "taro")
            echo "  ${GREEN}1)${NC} ios      - iOS App (React Native)"
            echo "  ${GREEN}2)${NC} android  - Android App (React Native)"
            echo "  ${GREEN}3)${NC} web      - H5网页"
            echo "  ${GREEN}4)${NC} weapp    - 微信小程序"
            echo "  ${GREEN}5)${NC} alipay   - 支付宝小程序"
            echo "  ${GREEN}6)${NC} qq       - QQ小程序"
            echo "  ${GREEN}7)${NC} jd       - 京东小程序"
            ;;
    esac
    
    echo ""
    echo "建议选择: ${YELLOW}ios,android${NC} (移动端) 或 ${YELLOW}weapp,alipay${NC} (小程序)"
    echo ""
    
    read -p "请输入平台列表 (例如: ios,android): " platform_input
    
    if [ -z "$platform_input" ]; then
        log_warning "未选择平台，使用默认配置"
        case $FRAMEWORK in
            "flutter"|"react-native")
                PLATFORMS="ios,android"
                ;;
            "uni-app"|"taro")
                PLATFORMS="weapp,alipay"
                ;;
        esac
    else
        PLATFORMS="$platform_input"
    fi
    
    log_success "选择的平台: $PLATFORMS"
}

# 交互式项目配置
interactive_setup() {
    if [ "$INTERACTIVE_MODE" = false ]; then
        return 0
    fi
    
    echo ""
    echo "${ROCKET} ${WHITE}移动端跨平台项目初始化向导${NC}"
    echo ""
    
    # 项目基本信息
    if [ -z "$PROJECT_PATH" ]; then
        read -p "请输入项目路径: " PROJECT_PATH
    fi
    
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME=$(basename "$PROJECT_PATH")
        read -p "项目名称 [$PROJECT_NAME]: " input_name
        if [ -n "$input_name" ]; then
            PROJECT_NAME="$input_name"
        fi
    fi
    
    # 选择框架和平台
    select_framework
    select_platforms
    
    # 模板选择
    echo ""
    echo "${STAR} ${WHITE}选择项目模板:${NC}"
    echo "  ${GREEN}1)${NC} basic      - 基础模板，适合学习和小项目"
    echo "  ${GREEN}2)${NC} enterprise - 企业级模板，完整的架构和最佳实践"
    echo "  ${GREEN}3)${NC} minimal    - 最小模板，只包含核心文件"
    echo ""
    
    read -p "请选择模板类型 [1-3] (默认: enterprise): " template_choice
    
    case $template_choice in
        1) TEMPLATE_TYPE="basic" ;;
        3) TEMPLATE_TYPE="minimal" ;;
        *) TEMPLATE_TYPE="enterprise" ;;
    esac
    
    log_success "选择的模板: $TEMPLATE_TYPE"
    
    # 确认配置
    echo ""
    echo "${INFO} ${WHITE}项目配置确认:${NC}"
    echo "  项目路径: ${GREEN}$PROJECT_PATH${NC}"
    echo "  项目名称: ${GREEN}$PROJECT_NAME${NC}"
    echo "  开发框架: ${GREEN}$FRAMEWORK${NC}"
    echo "  目标平台: ${GREEN}$PLATFORMS${NC}"
    echo "  模板类型: ${GREEN}$TEMPLATE_TYPE${NC}"
    echo ""
    
    read -p "确认创建项目? [Y/n]: " confirm
    
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        log_warning "用户取消创建项目"
        exit 0
    fi
}

# 创建项目目录
create_project_directory() {
    log_step "创建项目目录..."
    
    if [ -d "$PROJECT_PATH" ]; then
        if [ "$FORCE_OVERWRITE" = false ]; then
            log_error "项目目录已存在: $PROJECT_PATH"
            log_error "使用 -f 或 --force 选项强制覆盖"
            exit 1
        else
            log_warning "强制覆盖已存在的目录"
            rm -rf "$PROJECT_PATH"
        fi
    fi
    
    mkdir -p "$PROJECT_PATH"
    verbose_log "创建目录: $PROJECT_PATH"
    
    log_success "项目目录创建成功"
}

# 初始化框架项目
init_framework_project() {
    log_step "初始化 $FRAMEWORK 项目..."
    
    cd "$(dirname "$PROJECT_PATH")"
    local project_dir=$(basename "$PROJECT_PATH")
    
    case $FRAMEWORK in
        "flutter")
            verbose_log "执行: flutter create $project_dir"
            flutter create "$project_dir" --platforms="${PLATFORMS//,/ --platforms=}"
            ;;
        "react-native")
            verbose_log "执行: npx react-native@latest init $PROJECT_NAME"
            npx react-native@latest init "$PROJECT_NAME" --template react-native-template-typescript
            if [ "$project_dir" != "$PROJECT_NAME" ]; then
                mv "$PROJECT_NAME" "$project_dir"
            fi
            ;;
        "uni-app")
            verbose_log "执行: vue create -p dcloudio/uni-preset-vue $project_dir"
            vue create -p dcloudio/uni-preset-vue "$project_dir"
            ;;
        "taro")
            verbose_log "执行: taro init $project_dir"
            taro init "$project_dir"
            ;;
    esac
    
    log_success "$FRAMEWORK 项目初始化完成"
}

# 应用项目模板
apply_template() {
    log_step "应用项目模板..."
    
    local template_file="$TEMPLATES_DIR/${FRAMEWORK}-template.json"
    
    if [ ! -f "$template_file" ]; then
        log_warning "模板文件不存在: $template_file"
        return 0
    fi
    
    verbose_log "使用模板: $template_file"
    
    # 复制模板配置文件
    cd "$PROJECT_PATH"
    
    # 根据模板创建额外的目录和文件
    case $TEMPLATE_TYPE in
        "enterprise")
            verbose_log "应用企业级模板配置"
            # 创建企业级项目结构
            create_enterprise_structure
            ;;
        "minimal")
            verbose_log "应用最小模板配置"
            # 清理不必要的文件
            cleanup_minimal_structure
            ;;
        *)
            verbose_log "应用基础模板配置"
            ;;
    esac
    
    log_success "模板应用完成"
}

# 创建企业级项目结构
create_enterprise_structure() {
    # 创建标准目录结构
    local dirs=(
        "docs"
        "tests"
        "scripts" 
        ".github/workflows"
        "tools"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        verbose_log "创建目录: $dir"
    done
    
    # 创建配置文件
    create_config_files
    
    # 创建文档文件
    create_documentation
}

# 清理最小项目结构
cleanup_minimal_structure() {
    # 删除不必要的文件和目录
    local cleanup_items=(
        "android/app/src/test"
        "ios/*/Tests"
        "test"
        "__tests__"
        "*.test.*"
        "*.spec.*"
    )
    
    for item in "${cleanup_items[@]}"; do
        rm -rf $item 2>/dev/null || true
        verbose_log "清理: $item"
    done
}

# 创建配置文件
create_config_files() {
    verbose_log "创建配置文件..."
    
    # .gitignore
    if [ ! -f ".gitignore" ]; then
        create_gitignore
    fi
    
    # README.md
    create_readme
    
    # CI/CD配置
    create_cicd_config
    
    # 开发环境配置
    create_dev_configs
}

# 创建 .gitignore
create_gitignore() {
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Build outputs
build/
dist/
.tmp/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE and editors
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF
    
    # 添加框架特定的 gitignore 规则
    case $FRAMEWORK in
        "flutter")
            cat >> .gitignore << 'EOF'

# Flutter/Dart specific
.packages
.pub-cache/
.pub/
build/
.flutter-plugins
.flutter-plugins-dependencies
.dart_tool/
EOF
            ;;
        "react-native")
            cat >> .gitignore << 'EOF'

# React Native specific
android/app/build/
ios/build/
ios/Pods/
*.ipa
*.apk
EOF
            ;;
        "uni-app")
            cat >> .gitignore << 'EOF'

# uni-app specific
unpackage/
platforms/
EOF
            ;;
        "taro")
            cat >> .gitignore << 'EOF'

# Taro specific
.temp/
.rn_temp/
EOF
            ;;
    esac
    
    verbose_log "创建 .gitignore"
}

# 创建 README.md
create_readme() {
    cat > README.md << EOF
# $PROJECT_NAME

基于 $FRAMEWORK 开发的跨平台移动应用。

## 支持平台

$(echo "$PLATFORMS" | tr ',' '\n' | sed 's/^/- /')

## 快速开始

### 环境要求

EOF

    case $FRAMEWORK in
        "flutter")
            cat >> README.md << 'EOF'
- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / Xcode

### 安装依赖

```bash
flutter pub get
```

### 运行项目

```bash
# iOS
flutter run -d ios

# Android  
flutter run -d android

# Web
flutter run -d web
```

### 构建项目

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ipa --release

# Web
flutter build web --release
```
EOF
            ;;
        "react-native")
            cat >> README.md << 'EOF'
- Node.js 18+
- React Native CLI
- Android Studio / Xcode

### 安装依赖

```bash
npm install
# iOS
cd ios && pod install
```

### 运行项目

```bash
# iOS
npm run ios

# Android
npm run android
```

### 构建项目

```bash
# Android
npm run build:android

# iOS
npm run build:ios
```
EOF
            ;;
        "uni-app")
            cat >> README.md << 'EOF'
- Node.js 16+
- Vue CLI
- HBuilderX (可选)

### 安装依赖

```bash
npm install
```

### 运行项目

```bash
# H5
npm run dev:h5

# 微信小程序
npm run dev:mp-weixin

# App
npm run dev:app
```

### 构建项目

```bash
# H5
npm run build:h5

# 微信小程序
npm run build:mp-weixin

# App
npm run build:app
```
EOF
            ;;
        "taro")
            cat >> README.md << 'EOF'
- Node.js 16+
- Taro CLI

### 安装依赖

```bash
npm install
```

### 运行项目

```bash
# 微信小程序
npm run dev:weapp

# H5
npm run dev:h5

# React Native
npm run dev:rn
```

### 构建项目

```bash
# 微信小程序
npm run build:weapp

# H5
npm run build:h5

# React Native
npm run build:rn
```
EOF
            ;;
    esac
    
    cat >> README.md << 'EOF'

## 项目结构

```
项目结构说明...
```

## 开发规范

请参考 [开发规范文档](docs/DEVELOPMENT_GUIDE.md)

## 贡献指南

1. Fork 项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 许可证

MIT License
EOF
    
    verbose_log "创建 README.md"
}

# 创建 CI/CD 配置
create_cicd_config() {
    mkdir -p .github/workflows
    
    cat > .github/workflows/ci.yml << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      - run: npm ci
      - run: npm test
      
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      - run: npm ci
      - run: npm run build
EOF
    
    verbose_log "创建 CI/CD 配置"
}

# 创建开发配置
create_dev_configs() {
    # VSCode 配置
    mkdir -p .vscode
    
    cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.preferences.importModuleSpecifier": "relative"
}
EOF
    
    verbose_log "创建 VSCode 配置"
}

# 创建文档
create_documentation() {
    mkdir -p docs
    
    # 开发指南
    cat > docs/DEVELOPMENT_GUIDE.md << 'EOF'
# 开发指南

## 环境设置

### 必需工具

- Node.js 18+
- Git
- 代码编辑器 (推荐 VS Code)

### 可选工具

- Docker
- Postman

## 开发流程

### 1. 克隆项目

```bash
git clone <repository-url>
cd project-directory
```

### 2. 安装依赖

```bash
npm install
```

### 3. 启动开发服务器

```bash
npm start
```

## 代码规范

### 命名规范

- 使用 camelCase 命名变量和函数
- 使用 PascalCase 命名组件和类
- 使用 kebab-case 命名文件

### 提交规范

使用 Conventional Commits 规范：

- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式调整
- refactor: 重构
- test: 测试相关
- chore: 构建过程或辅助工具的变动

## 测试

### 运行测试

```bash
npm test
```

### 测试覆盖率

```bash
npm run test:coverage
```

## 部署

### 构建项目

```bash
npm run build
```

### 发布

```bash
npm run deploy
```
EOF
    
    # 架构文档
    cat > docs/ARCHITECTURE.md << 'EOF'
# 项目架构

## 技术栈

- 框架: $FRAMEWORK
- 语言: TypeScript/JavaScript
- 状态管理: [状态管理方案]
- 路由: [路由方案]

## 目录结构

```
src/
  components/    # 组件
  pages/         # 页面
  services/      # 服务
  utils/         # 工具函数
  types/         # 类型定义
  assets/        # 静态资源
```

## 设计模式

### 组件设计

- 单一职责原则
- 组件复用
- Props 接口设计

### 状态管理

- 全局状态
- 本地状态
- 状态更新流程

### 数据流

- API 调用
- 数据转换
- 错误处理

## 性能优化

- 代码分割
- 懒加载
- 缓存策略
- 图片优化

## 安全考虑

- 数据验证
- 权限控制
- 敏感信息保护
EOF
    
    verbose_log "创建项目文档"
}

# 安装依赖
install_dependencies() {
    log_step "安装项目依赖..."
    
    cd "$PROJECT_PATH"
    
    case $FRAMEWORK in
        "flutter")
            verbose_log "执行: flutter pub get"
            flutter pub get
            ;;
        "react-native"|"uni-app"|"taro")
            verbose_log "执行: npm install"
            npm install
            
            # React Native 需要安装 iOS 依赖
            if [ "$FRAMEWORK" = "react-native" ] && [[ "$PLATFORMS" == *"ios"* ]]; then
                if [ -d "ios" ]; then
                    verbose_log "执行: cd ios && pod install"
                    cd ios && pod install && cd ..
                fi
            fi
            ;;
    esac
    
    log_success "依赖安装完成"
}

# 初始化 Git 仓库
init_git_repo() {
    log_step "初始化 Git 仓库..."
    
    cd "$PROJECT_PATH"
    
    if [ ! -d ".git" ]; then
        verbose_log "执行: git init"
        git init
        
        verbose_log "执行: git add ."
        git add .
        
        verbose_log "执行: git commit -m 'Initial commit'"
        git commit -m "feat: initial commit

${ROCKET} Generated with Mobile Cross-Platform Init Script

Framework: $FRAMEWORK
Platforms: $PLATFORMS  
Template: $TEMPLATE_TYPE

Co-Authored-By: Claude <noreply@anthropic.com>"
        
        log_success "Git 仓库初始化完成"
    else
        verbose_log "Git 仓库已存在，跳过初始化"
    fi
}

# 生成启动脚本
create_startup_scripts() {
    log_step "生成启动脚本..."
    
    cd "$PROJECT_PATH"
    
    # 创建通用启动脚本
    cat > start.sh << 'EOF'
#!/bin/bash

# 项目启动脚本

set -e

echo "🚀 启动项目..."

case "${1:-dev}" in
    "dev"|"development")
        echo "📱 启动开发模式..."
        EOF
        
    case $FRAMEWORK in
        "flutter")
            echo '        flutter run' >> start.sh
            ;;
        "react-native")
            echo '        npm start' >> start.sh
            ;;
        "uni-app")
            echo '        npm run dev:h5' >> start.sh
            ;;
        "taro")
            echo '        npm run dev:weapp' >> start.sh
            ;;
    esac
    
    cat >> start.sh << 'EOF'
        ;;
    "build"|"production")
        echo "🏗️ 构建生产版本..."
EOF
    
    case $FRAMEWORK in
        "flutter")
            echo '        flutter build apk --release' >> start.sh
            ;;
        "react-native")
            echo '        npm run build' >> start.sh
            ;;
        "uni-app")
            echo '        npm run build:h5' >> start.sh
            ;;
        "taro")
            echo '        npm run build:weapp' >> start.sh
            ;;
    esac
    
    cat >> start.sh << 'EOF'
        ;;
    "test")
        echo "🧪 运行测试..."
        npm test
        ;;
    *)
        echo "用法: $0 [dev|build|test]"
        echo "  dev   - 启动开发服务器"
        echo "  build - 构建生产版本"  
        echo "  test  - 运行测试"
        exit 1
        ;;
esac

echo "✅ 完成!"
EOF
    
    chmod +x start.sh
    verbose_log "创建启动脚本: start.sh"
    
    log_success "启动脚本创建完成"
}

# 显示完成信息
show_completion_info() {
    echo ""
    echo "${SUCCESS} ${GREEN}项目创建完成!${NC}"
    echo ""
    echo "${INFO} ${WHITE}项目信息:${NC}"
    echo "  项目路径: ${GREEN}$PROJECT_PATH${NC}"
    echo "  项目名称: ${GREEN}$PROJECT_NAME${NC}"
    echo "  开发框架: ${GREEN}$FRAMEWORK${NC}"
    echo "  目标平台: ${GREEN}$PLATFORMS${NC}"
    echo "  模板类型: ${GREEN}$TEMPLATE_TYPE${NC}"
    echo ""
    echo "${ROCKET} ${WHITE}下一步操作:${NC}"
    echo "  1. ${CYAN}cd $PROJECT_PATH${NC}"
    
    case $FRAMEWORK in
        "flutter")
            echo "  2. ${CYAN}flutter doctor${NC}    # 检查环境"
            echo "  3. ${CYAN}flutter run${NC}       # 运行项目"
            ;;
        "react-native")
            echo "  2. ${CYAN}npm start${NC}         # 启动Metro"
            echo "  3. ${CYAN}npm run ios${NC}       # 运行iOS (新终端)"
            echo "     ${CYAN}npm run android${NC}   # 运行Android (新终端)"
            ;;
        "uni-app")
            echo "  2. ${CYAN}npm run dev:h5${NC}    # 开发H5"
            echo "  3. ${CYAN}npm run dev:mp-weixin${NC} # 开发微信小程序"
            ;;
        "taro")
            echo "  2. ${CYAN}npm run dev:weapp${NC} # 开发微信小程序"
            echo "  3. ${CYAN}npm run dev:h5${NC}    # 开发H5"
            ;;
    esac
    
    echo ""
    echo "${STAR} ${WHITE}快速启动:${NC}"
    echo "  ${CYAN}./start.sh${NC}            # 启动开发服务器"
    echo "  ${CYAN}./start.sh build${NC}      # 构建生产版本"
    echo "  ${CYAN}./start.sh test${NC}       # 运行测试"
    echo ""
    echo "${INFO} ${WHITE}更多帮助:${NC}"
    echo "  - 查看 ${GREEN}README.md${NC} 了解项目详情"
    echo "  - 查看 ${GREEN}docs/DEVELOPMENT_GUIDE.md${NC} 了解开发指南"
    echo "  - 查看 ${GREEN}docs/ARCHITECTURE.md${NC} 了解项目架构"
    echo ""
    echo "${PHONE} ${WHITE}Happy Coding!${NC}"
}

# 错误处理
handle_error() {
    log_error "脚本执行失败: $1"
    log_error "错误发生在第 $2 行"
    
    if [ -d "$PROJECT_PATH" ] && [ "$FORCE_OVERWRITE" = true ]; then
        read -p "是否清理已创建的项目目录? [y/N]: " cleanup
        if [[ "$cleanup" =~ ^[Yy]$ ]]; then
            rm -rf "$PROJECT_PATH"
            log_info "已清理项目目录"
        fi
    fi
    
    exit 1
}

# 设置错误处理
trap 'handle_error "$BASH_COMMAND" "$LINENO"' ERR

# 解析命令行参数
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -f|--force)
                FORCE_OVERWRITE=true
                shift
                ;;
            -q|--quiet)
                VERBOSE=false
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -t|--template)
                TEMPLATE_TYPE="$2"
                shift 2
                ;;
            -n|--no-interactive)
                INTERACTIVE_MODE=false
                shift
                ;;
            -*)
                log_error "未知选项: $1"
                echo "使用 -h 或 --help 查看帮助信息"
                exit 1
                ;;
            *)
                if [ -z "$PROJECT_PATH" ]; then
                    PROJECT_PATH="$1"
                    PROJECT_NAME=$(basename "$PROJECT_PATH")
                elif [ -z "$FRAMEWORK" ]; then
                    FRAMEWORK="$1"
                elif [ -z "$PLATFORMS" ]; then
                    PLATFORMS="$1"
                else
                    log_error "过多的位置参数: $1"
                    exit 1
                fi
                shift
                ;;
        esac
    done
}

# 验证参数
validate_arguments() {
    if [ -z "$PROJECT_PATH" ]; then
        if [ "$INTERACTIVE_MODE" = false ]; then
            log_error "非交互模式下必须指定项目路径"
            exit 1
        fi
    fi
    
    if [ -n "$FRAMEWORK" ] && [ -z "${FRAMEWORKS[$FRAMEWORK]}" ]; then
        log_error "不支持的框架: $FRAMEWORK"
        echo "支持的框架: ${!FRAMEWORKS[*]}"
        exit 1
    fi
    
    if [ -n "$PLATFORMS" ]; then
        IFS=',' read -ra platform_array <<< "$PLATFORMS"
        for platform in "${platform_array[@]}"; do
            if [ -z "${PLATFORMS_INFO[$platform]}" ]; then
                log_error "不支持的平台: $platform"
                echo "支持的平台: ${!PLATFORMS_INFO[*]}"
                exit 1
            fi
        done
    fi
    
    if [[ ! "$TEMPLATE_TYPE" =~ ^(basic|enterprise|minimal)$ ]]; then
        log_error "不支持的模板类型: $TEMPLATE_TYPE"
        echo "支持的模板类型: basic, enterprise, minimal"
        exit 1
    fi
}

# 主函数
main() {
    echo "${CYAN}${PHONE} 移动端跨平台项目初始化脚本 v1.0.0${NC}"
    echo ""
    
    # 解析和验证参数
    parse_arguments "$@"
    validate_arguments
    
    # 交互式配置
    interactive_setup
    
    # 检查环境和依赖
    check_dependencies
    check_environment
    
    # 创建项目
    create_project_directory
    init_framework_project
    apply_template
    install_dependencies
    init_git_repo
    create_startup_scripts
    
    # 显示完成信息
    show_completion_info
}

# 运行主函数
main "$@"