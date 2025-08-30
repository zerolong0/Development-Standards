#!/bin/bash

# 新项目设置脚本
# 用法: ./setup-new-project.sh <project-name> <project-type>
# 例子: ./setup-new-project.sh MyApp ios

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 输出函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 参数检查
if [ $# -lt 2 ]; then
    print_error "Usage: $0 <project-name> <project-type>"
    print_info "Project types: ios, android, web, api, desktop"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_TYPE=$2
CURRENT_DIR=$(pwd)
STANDARDS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_info "Setting up new project: $PROJECT_NAME ($PROJECT_TYPE)"

# 创建项目目录结构
print_info "Creating project directory structure..."
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 基础目录结构
mkdir -p docs/{standards,api,deployment}
mkdir -p src
mkdir -p tests
mkdir -p configs
mkdir -p scripts
mkdir -p .github/workflows

print_success "Created basic directory structure"

# 复制开发规范文档
print_info "Setting up development standards..."
cp -r "$STANDARDS_DIR/docs" "docs/standards/"
cp -r "$STANDARDS_DIR/templates" "docs/standards/"

print_success "Copied development standards"

# 创建项目特定的README
print_info "Creating project README..."
cat > README.md << EOF
# $PROJECT_NAME

## 📋 项目概述
[项目描述待完善]

## 🚀 快速开始

### 环境要求
- [列出环境要求]

### 安装依赖
\`\`\`bash
# [安装命令]
\`\`\`

### 运行项目
\`\`\`bash
# [运行命令]
\`\`\`

## 📚 文档
- [开发规范](./docs/standards/README.md)
- [API文档](./docs/api/)
- [部署文档](./docs/deployment/)

## 🛠️ 开发
遵循项目开发规范，详见 [开发最佳实践](./docs/standards/docs/DEVELOPMENT_BEST_PRACTICES.md)

## 🧪 测试
\`\`\`bash
# [测试命令]
\`\`\`

## 📦 构建和部署
\`\`\`bash
# [构建命令]
\`\`\`

## 🤝 贡献
请阅读 [项目工作流程](./docs/standards/docs/PROJECT_WORKFLOW.md)

## 📞 联系
- 项目负责人: [姓名]
- 邮箱: [邮箱]
EOF

# 根据项目类型创建特定配置
case $PROJECT_TYPE in
    ios)
        print_info "Setting up iOS project configuration..."
        
        # 创建iOS特定的配置
        cat > configs/ios-config.md << EOF
# iOS项目配置

## 开发环境
- Xcode: 15.0+
- iOS Deployment Target: 15.0+
- Swift: 5.9+

## 依赖管理
- CocoaPods / Swift Package Manager

## 架构
- SwiftUI + MVVM
- Core Data / SQLite
- Core ML (如需AI功能)

## 设计系统
- 遵循Human Interface Guidelines
- 支持Dark Mode
- 无障碍访问支持
EOF
        
        # 创建iOS的gitignore
        cat > .gitignore << 'EOF'
# Xcode
.DS_Store
*/build/*
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata
profile
*.moved-aside
DerivedData
.idea/
*.hmap
*.xccheckout
*.xcscmblueprint

# CocoaPods
Pods/
Podfile.lock

# Swift Package Manager
.swiftpm/
.build/
EOF
        ;;
        
    android)
        print_info "Setting up Android project configuration..."
        
        cat > configs/android-config.md << EOF
# Android项目配置

## 开发环境
- Android Studio: 2023.1+
- Gradle: 8.0+
- Kotlin: 1.9+
- Min SDK: 24 (Android 7.0)
- Target SDK: 34

## 架构
- MVVM + Clean Architecture
- Room Database
- Retrofit + OkHttp
- Jetpack Compose

## 依赖管理
- Gradle with Kotlin DSL
EOF

        cat > .gitignore << 'EOF'
# Built application files
*.apk
*.aar
*.ap_
*.aab

# Files for the ART/Dalvik VM
*.dex

# Java class files
*.class

# Generated files
bin/
gen/
out/

# Gradle files
.gradle/
build/

# Local configuration file (sdk path, etc)
local.properties

# Android Studio
.idea/
*.iml
.navigation/
captures/
output.json

# Keystore files
*.jks
*.keystore
EOF
        ;;
        
    web)
        print_info "Setting up Web project configuration..."
        
        cat > configs/web-config.md << EOF
# Web项目配置

## 开发环境
- Node.js: 18+
- npm: 9+

## 技术栈
- React 18+ / Vue 3+ / Next.js
- TypeScript
- Tailwind CSS / Styled Components
- Vite / Webpack

## 浏览器支持
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+
EOF

        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production builds
build/
dist/
.next/
out/

# Environment variables
.env
.env.local
.env.production
.env.development

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
EOF
        ;;
        
    *)
        print_warning "Unknown project type: $PROJECT_TYPE"
        print_info "Creating generic configuration..."
        
        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
vendor/

# Build outputs
build/
dist/
target/
bin/
obj/

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
        ;;
esac

# 创建技术决策记录模板
print_info "Creating initial technical decision record..."
cp "docs/standards/docs/TECHNICAL_DECISIONS_TEMPLATE.md" "docs/TECHNICAL_DECISIONS.md"

# 创建项目设置检查清单
print_info "Creating project setup checklist..."
cp "docs/standards/templates/PROJECT_SETUP_CHECKLIST.md" "docs/PROJECT_SETUP.md"

# 创建第一周计划模板
print_info "Creating initial week planning..."
cp "docs/standards/templates/WEEKLY_PLANNING_TEMPLATE.md" "docs/WEEK_1_PLANNING.md"

# 创建基础的GitHub Actions配置
print_info "Setting up GitHub Actions..."
case $PROJECT_TYPE in
    ios)
        cat > .github/workflows/ios.yml << 'EOF'
name: iOS Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode version
      run: sudo xcode-select -s /Applications/Xcode_15.0.app
    
    - name: Build
      run: xcodebuild build -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15'
    
    - name: Test
      run: xcodebuild test -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15'
EOF
        ;;
        
    web)
        cat > .github/workflows/web.yml << 'EOF'
name: Web Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build
      run: npm run build
EOF
        ;;
esac

# 创建贡献指南
print_info "Creating contribution guidelines..."
cat > CONTRIBUTING.md << EOF
# 贡献指南

## 开发流程
1. Fork项目
2. 创建feature分支
3. 遵循开发规范编写代码
4. 编写测试用例
5. 提交Pull Request

## 代码规范
详见 [开发最佳实践](./docs/standards/docs/DEVELOPMENT_BEST_PRACTICES.md)

## 提交信息规范
使用conventional commits格式：
- feat: 新功能
- fix: Bug修复  
- docs: 文档更新
- style: 代码格式调整
- refactor: 代码重构
- test: 测试相关
- chore: 其他杂项

## 代码审查
所有PR都需要经过代码审查，请参考 [代码审查检查清单](./docs/standards/templates/CODE_REVIEW_CHECKLIST.md)
EOF

# 初始化Git仓库
if [ ! -d ".git" ]; then
    print_info "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial project setup with development standards

- Added complete development standards documentation
- Set up project structure and configuration  
- Created initial templates and workflows
- Configured $PROJECT_TYPE specific settings"
    
    print_success "Git repository initialized with initial commit"
else
    print_warning "Git repository already exists, skipping initialization"
fi

# 完成设置
print_success "Project setup completed successfully!"
echo
print_info "Next steps:"
echo "1. Review and customize docs/PROJECT_SETUP.md"
echo "2. Update project-specific configurations in configs/"
echo "3. Customize README.md with your project details"
echo "4. Review technical decisions in docs/TECHNICAL_DECISIONS.md"
echo "5. Start development following docs/standards/docs/PROJECT_WORKFLOW.md"
echo
print_info "Project location: $CURRENT_DIR/$PROJECT_NAME"

# 检查是否需要额外设置
case $PROJECT_TYPE in
    ios)
        print_info "iOS specific setup:"
        echo "- Open project in Xcode"
        echo "- Configure code signing"
        echo "- Set up simulator targets"
        ;;
    android)
        print_info "Android specific setup:"
        echo "- Open project in Android Studio"
        echo "- Configure SDK and build tools"
        echo "- Set up emulator"
        ;;
    web)
        print_info "Web specific setup:"
        echo "- Run 'npm install' to install dependencies"
        echo "- Configure your preferred framework"
        echo "- Set up development server"
        ;;
esac

print_success "Happy coding! 🚀"
EOF