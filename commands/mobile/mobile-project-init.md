# 📱 移动端跨平台项目初始化命令

## 🎯 命令概述

智能化移动端跨平台项目初始化命令，支持Flutter、React Native、uni-app、Taro等主流框架的快速项目搭建和配置。

## 🚀 核心功能

### 一键项目初始化
```bash
# 基础语法
/mobile-init [framework] [project-name] [template] [platform-targets]

# 示例用法
/mobile-init flutter MyApp ecommerce "ios,android,web"
/mobile-init react-native SocialApp basic "ios,android"
/mobile-init uni-app ShopApp "mp-weixin,mp-alipay,h5,app"
/mobile-init taro EnterpriseApp typescript "weapp,h5,rn"
```

### 智能框架选择
基于项目需求自动推荐最适合的技术栈：

```typescript
interface ProjectRequirements {
  platforms: Platform[];        // 目标平台
  teamSkills: TechStack[];      // 团队技术栈
  projectType: ProjectType;     // 项目类型
  budget: BudgetLevel;          // 预算等级
  timeline: number;             // 开发周期(周)
  performance: PerformanceLevel; // 性能要求
  maintenance: MaintenanceLevel; // 维护要求
}

interface FrameworkRecommendation {
  framework: Framework;
  score: number;               // 匹配度评分 (0-100)
  reasons: string[];           // 推荐理由
  risks: string[];            // 潜在风险
  alternatives: Framework[];   // 备选方案
}
```

## 💻 使用说明

### 交互式初始化模式

```bash
用户输入: /mobile-init

系统响应:
🎯 移动端跨平台项目初始化向导

📋 第1步: 项目基本信息
项目名称: [输入项目名]
项目描述: [输入简短描述]
项目类型: 
  1. 电商应用
  2. 社交媒体
  3. 金融应用
  4. 内容展示
  5. 工具应用
  6. 游戏应用
  7. 其他

🎯 第2步: 平台需求
需要支持的平台 (多选):
  □ iOS App
  □ Android App  
  □ 微信小程序
  □ 支付宝小程序
  □ 百度小程序
  □ 字节小程序
  □ Web H5
  □ 鸿蒙应用

👥 第3步: 团队技术栈
当前团队熟悉的技术:
  □ JavaScript/TypeScript
  □ React
  □ Vue.js
  □ Dart/Flutter
  □ 小程序开发
  □ 原生开发

⚡ 第4步: 项目约束
开发预算: [高/中/低]
开发周期: [输入周数]
性能要求: [高/中/低]
维护周期: [长期/中期/短期]

🤖 正在分析您的需求...

✨ 推荐方案:
根据您的需求，推荐使用 uni-app 框架：
- 匹配度: 92%
- 开发效率: ⭐⭐⭐⭐⭐
- 维护成本: ⭐⭐⭐⭐
- 学习成本: ⭐⭐⭐⭐⭐

推荐理由:
1. 完美支持您需要的所有平台
2. 基于Vue.js，符合团队技术栈
3. 开发效率高，符合预算和时间要求
4. 社区生态完善，适合电商应用

是否继续使用 uni-app 初始化项目? (Y/n)
```

### 快速初始化模式

```bash
# Flutter项目初始化
/mobile-init flutter MyApp

系统执行:
1. 🏗️  创建Flutter项目结构
2. 📦  安装项目依赖包
3. 🎨  配置Material Design主题
4. 🔧  设置开发工具配置
5. 🚀  配置CI/CD流水线
6. 📱  生成多平台构建配置
7. 🧪  初始化测试框架
8. 📚  生成项目文档

✅ Flutter项目初始化完成!

项目路径: ./MyApp
启动命令: 
  - iOS: flutter run -d ios
  - Android: flutter run -d android  
  - Web: flutter run -d web

下一步建议:
1. 运行 'flutter doctor' 检查环境
2. 查看 README.md 了解项目结构
3. 访问 docs/ARCHITECTURE.md 了解架构设计
```

## 🛠️ 技术实现

### 项目模板生成器

```typescript
class ProjectGenerator {
  private templates: Map<Framework, ProjectTemplate> = new Map();
  
  async generateProject(config: ProjectConfig): Promise<ProjectStructure> {
    const template = this.selectTemplate(config);
    const structure = await this.createStructure(template);
    
    // 生成核心文件
    await this.generateCoreFiles(structure, config);
    await this.generatePlatformFiles(structure, config);
    await this.generateConfigFiles(structure, config);
    await this.generateDocumentation(structure, config);
    
    // 安装依赖
    await this.installDependencies(structure);
    
    // 初始化Git
    await this.initializeGit(structure);
    
    return structure;
  }
  
  private selectTemplate(config: ProjectConfig): ProjectTemplate {
    const recommendation = this.analyzeRequirements(config);
    return this.templates.get(recommendation.framework);
  }
  
  private analyzeRequirements(config: ProjectConfig): FrameworkRecommendation {
    const scorer = new FrameworkScorer();
    
    const candidates = [
      Framework.Flutter,
      Framework.ReactNative,
      Framework.UniApp,
      Framework.Taro
    ];
    
    const scores = candidates.map(framework => {
      return {
        framework,
        score: scorer.calculateScore(framework, config),
        reasons: scorer.getReasons(framework, config),
        risks: scorer.getRisks(framework, config)
      };
    });
    
    return scores.sort((a, b) => b.score - a.score)[0];
  }
}
```

### 智能配置生成

```typescript
interface ConfigGenerator {
  // 生成package.json
  generatePackageJson(config: ProjectConfig): PackageJson;
  
  // 生成TypeScript配置
  generateTSConfig(framework: Framework): TSConfig;
  
  // 生成ESLint配置
  generateESLintConfig(framework: Framework): ESLintConfig;
  
  // 生成CI/CD配置
  generateCIConfig(config: ProjectConfig): CIConfig;
  
  // 生成平台特定配置
  generatePlatformConfigs(platforms: Platform[]): PlatformConfig[];
}

class SmartConfigGenerator implements ConfigGenerator {
  generatePackageJson(config: ProjectConfig): PackageJson {
    const basePackage = this.getBasePackage(config.framework);
    
    // 根据目标平台添加依赖
    if (config.platforms.includes(Platform.iOS)) {
      basePackage.dependencies.push(...this.getIOSDependencies());
    }
    
    if (config.platforms.includes(Platform.Android)) {
      basePackage.dependencies.push(...this.getAndroidDependencies());
    }
    
    // 添加开发工具依赖
    basePackage.devDependencies.push(...this.getDevDependencies(config));
    
    return basePackage;
  }
  
  generateCIConfig(config: ProjectConfig): CIConfig {
    const ciConfig: CIConfig = {
      name: "Mobile CI/CD Pipeline",
      triggers: ["push", "pull_request"],
      jobs: []
    };
    
    // 添加测试任务
    ciConfig.jobs.push(this.createTestJob());
    
    // 根据平台添加构建任务
    config.platforms.forEach(platform => {
      ciConfig.jobs.push(this.createBuildJob(platform, config.framework));
    });
    
    // 添加部署任务
    if (config.autoDeployment) {
      ciConfig.jobs.push(this.createDeployJob(config));
    }
    
    return ciConfig;
  }
}
```

## 📋 项目模板

### Flutter项目模板

```yaml
# flutter_template.yaml
structure:
  lib/
    main.dart                    # 应用入口
    app/                        # 应用层
      app.dart                  # App配置
      routes.dart               # 路由配置
      theme.dart                # 主题配置
    core/                       # 核心层
      constants/                # 常量定义
      utils/                    # 工具函数
      services/                 # 服务层
      models/                   # 数据模型
    features/                   # 功能模块
      authentication/           # 认证模块
      home/                     # 首页模块
      profile/                  # 个人资料
    shared/                     # 共享组件
      widgets/                  # 通用组件
      styles/                   # 样式定义

dependencies:
  - flutter_bloc: ^8.1.3       # 状态管理
  - dio: ^5.3.2                # 网络请求
  - cached_network_image: ^3.3.0 # 图片缓存
  - shared_preferences: ^2.2.2  # 本地存储
  - provider: ^6.1.1           # 依赖注入

dev_dependencies:
  - flutter_test: ^1.0.0       # 测试框架
  - bloc_test: ^9.1.5          # Bloc测试
  - mockito: ^5.4.2            # Mock框架
  - flutter_launcher_icons: ^0.13.1 # 图标生成
```

### React Native项目模板

```json
{
  "template_name": "react_native_template",
  "structure": {
    "src/": {
      "components/": "通用组件",
      "screens/": "页面组件", 
      "navigation/": "导航配置",
      "services/": "服务层",
      "store/": "状态管理",
      "utils/": "工具函数",
      "types/": "类型定义",
      "constants/": "常量定义",
      "assets/": "静态资源"
    }
  },
  "dependencies": {
    "react": "18.2.0",
    "react-native": "0.72.6",
    "@react-navigation/native": "^6.1.9",
    "@react-navigation/stack": "^6.3.20",
    "@reduxjs/toolkit": "^1.9.7",
    "react-redux": "^8.1.3",
    "axios": "^1.6.0",
    "react-native-vector-icons": "^10.0.0"
  },
  "scripts": {
    "android": "react-native run-android",
    "ios": "react-native run-ios",
    "start": "react-native start",
    "test": "jest",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx"
  }
}
```

### uni-app项目模板

```json
{
  "template_name": "uni_app_template",
  "structure": {
    "pages/": "页面文件",
    "components/": "组件库",
    "static/": "静态资源",
    "common/": "公共代码",
    "store/": "状态管理",
    "utils/": "工具函数",
    "api/": "接口定义",
    "config/": "配置文件"
  },
  "config_files": [
    "pages.json",
    "manifest.json", 
    "App.vue",
    "main.js",
    "uni.scss"
  ],
  "dependencies": {
    "@dcloudio/uni-ui": "^1.4.28",
    "vuex": "^3.6.2",
    "axios": "^1.6.0"
  },
  "platforms": {
    "mp-weixin": "微信小程序配置",
    "mp-alipay": "支付宝小程序配置", 
    "h5": "H5配置",
    "app-plus": "App配置"
  }
}
```

### Taro项目模板

```typescript
// taro_template.ts
export const TaroTemplate: ProjectTemplate = {
  name: "taro_template",
  framework: Framework.Taro,
  structure: {
    "src/": {
      "app.tsx": "应用入口",
      "app.config.ts": "全局配置",
      "pages/": "页面组件",
      "components/": "通用组件",
      "services/": "服务层",
      "store/": "状态管理",
      "utils/": "工具函数",
      "styles/": "样式文件",
      "assets/": "静态资源"
    },
    "config/": {
      "index.js": "基础配置",
      "dev.js": "开发环境",
      "prod.js": "生产环境"
    }
  },
  dependencies: [
    "@tarojs/components",
    "@tarojs/taro", 
    "@tarojs/runtime",
    "@tarojs/react",
    "@reduxjs/toolkit",
    "react-redux"
  ],
  scripts: {
    "build:weapp": "taro build --type weapp",
    "build:h5": "taro build --type h5",
    "build:rn": "taro build --type rn",
    "dev:weapp": "npm run build:weapp -- --watch",
    "dev:h5": "npm run build:h5 -- --watch"
  }
};
```

## 🧪 质量保证

### 自动化测试配置

```typescript
// 测试框架配置生成
interface TestConfig {
  unit: UnitTestConfig;
  integration: IntegrationTestConfig;
  e2e: E2ETestConfig;
}

class TestConfigGenerator {
  generateTestConfig(framework: Framework): TestConfig {
    return {
      unit: this.generateUnitTestConfig(framework),
      integration: this.generateIntegrationConfig(framework),
      e2e: this.generateE2EConfig(framework)
    };
  }
  
  private generateUnitTestConfig(framework: Framework): UnitTestConfig {
    switch (framework) {
      case Framework.Flutter:
        return {
          testFramework: "flutter_test",
          mockFramework: "mockito",
          coverage: "lcov",
          testDir: "test/"
        };
      
      case Framework.ReactNative:
        return {
          testFramework: "jest",
          mockFramework: "jest",
          coverage: "lcov",
          testDir: "__tests__/"
        };
      
      default:
        return this.getDefaultConfig();
    }
  }
}
```

### 代码质量检查

```javascript
// 代码质量配置自动生成
const QualityConfig = {
  flutter: {
    linter: "dart_code_metrics",
    formatter: "dartfmt", 
    analyzer: "analysis_options.yaml"
  },
  
  reactNative: {
    linter: "eslint",
    formatter: "prettier",
    typeChecker: "typescript"
  },
  
  uniApp: {
    linter: "eslint-plugin-vue",
    formatter: "prettier",
    styleChecker: "stylelint"
  },
  
  taro: {
    linter: "@tarojs/eslint-config",
    formatter: "prettier",
    typeChecker: "typescript"
  }
};
```

## 📈 使用统计和分析

```typescript
interface UsageAnalytics {
  // 记录用户选择偏好
  trackFrameworkChoice(choice: FrameworkChoice): void;
  
  // 记录项目成功率
  trackProjectSuccess(projectId: string, success: boolean): void;
  
  // 分析用户反馈
  analyzeUserFeedback(feedback: UserFeedback): Insights;
  
  // 生成推荐优化建议
  generateRecommendations(usage: UsageData): Recommendation[];
}

// 数据收集和分析
class ProjectAnalytics implements UsageAnalytics {
  trackFrameworkChoice(choice: FrameworkChoice) {
    // 记录选择的framework和原因
    // 用于优化推荐算法
    this.collector.track('framework_selected', {
      framework: choice.framework,
      score: choice.score,
      reasons: choice.reasons,
      userProfile: choice.userProfile
    });
  }
  
  generateRecommendations(usage: UsageData): Recommendation[] {
    // 基于历史数据生成个性化推荐
    const patterns = this.analyzer.findPatterns(usage);
    return patterns.map(pattern => ({
      type: 'framework_optimization',
      description: pattern.description,
      confidence: pattern.confidence,
      impact: pattern.estimatedImpact
    }));
  }
}
```

## 🎯 预期效果

### 开发效率提升
- **项目启动时间**: 从2-3天减少到30分钟
- **配置工作量**: 减少90%的重复配置工作
- **标准化程度**: 100%的项目结构标准化
- **错误率降低**: 减少80%的初始化错误

### 质量保证增强
- **代码规范**: 自动应用最佳实践规范
- **测试覆盖**: 默认集成完整测试框架
- **CI/CD集成**: 一键配置自动化流水线
- **文档完整性**: 自动生成项目文档

### 团队协作改善
- **学习成本**: 标准化降低新人上手难度
- **维护效率**: 统一架构提升维护效率
- **知识传承**: 完整文档和最佳实践沉淀

---

## 🔗 相关命令

- `mobile-framework-compare` - 框架详细对比分析
- `mobile-platform-check` - 平台兼容性检查
- `mobile-performance-analyze` - 性能分析和优化
- `mobile-migration-assist` - 项目迁移助手

---

*让移动端跨平台开发变得简单高效！*