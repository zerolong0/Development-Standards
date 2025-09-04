# 🔍 平台兼容性检查命令

## 🎯 命令概述

智能平台兼容性检查命令，深度分析跨平台项目的兼容性问题，提供详细的兼容性报告和修复建议。

## 🚀 核心功能

### 全面兼容性扫描
```bash
# 基础语法
/platform-check [scan-type] [target-platforms] [options]

# 示例用法
/platform-check full "ios,android,weapp" --fix-suggestions
/platform-check api-only "ios,android" --detailed-report
/platform-check ui-components "weapp,alipay,h5" --export-report
/platform-check dependencies all --security-check
```

### 智能问题检测
- **API兼容性**: 检查平台API差异和兼容性问题
- **UI组件适配**: 分析UI组件在不同平台的表现差异
- **依赖包冲突**: 识别依赖包版本冲突和平台支持问题
- **性能影响**: 评估兼容性方案对性能的影响
- **安全风险**: 检测潜在的安全兼容性问题

## 💻 使用说明

### 交互式检查模式

```bash
用户输入: /platform-check

系统响应:
🔍 平台兼容性检查向导

📱 第1步: 选择检查范围
请选择要检查的内容:
  □ API接口兼容性
  □ UI组件适配性  
  □ 依赖包兼容性
  □ 性能兼容性
  □ 安全兼容性
  □ 全面兼容性检查 ✓

🎯 第2步: 目标平台选择
请选择要检查的目标平台:
  □ iOS App
  □ Android App
  □ 微信小程序 ✓
  □ 支付宝小程序 ✓
  □ Web H5 ✓
  □ 鸿蒙应用

⚙️ 第3步: 检查选项
  □ 生成详细报告 ✓
  □ 包含修复建议 ✓
  □ 导出检查结果
  □ 实时修复模式

🚀 开始检查...

=== 兼容性检查报告 ===

📊 总体评分: 76/100 (良好)

⚠️  发现的问题:
1. 严重问题: 2个
2. 警告问题: 8个  
3. 建议优化: 12个

🔍 详细分析:

【严重问题】
❌ API兼容性问题
  - 位置: src/utils/storage.js:23
  - 问题: 使用了localStorage，微信小程序不支持
  - 影响平台: 微信小程序, 支付宝小程序
  - 修复建议: 
    ```javascript
    // 替换方案
    // 原代码: localStorage.setItem('key', 'value')
    // 修复后:
    if (typeof localStorage !== 'undefined') {
      localStorage.setItem('key', 'value');
    } else if (typeof wx !== 'undefined') {
      wx.setStorageSync('key', 'value');
    }
    ```

❌ UI组件兼容性问题
  - 位置: src/components/DatePicker.vue:45
  - 问题: input type="date"在小程序中显示异常
  - 影响平台: 所有小程序平台
  - 修复建议: 使用uni-app的picker组件替代

【警告问题】
⚠️  依赖包版本冲突
  - 包名: axios@1.6.0
  - 问题: 微信小程序需要特殊配置
  - 修复建议: 添加小程序适配配置

...

💡 优化建议:
1. 建议使用平台适配层统一API调用
2. 考虑使用条件编译优化包体积
3. 建议添加平台兼容性测试用例

是否立即应用修复建议? (Y/n)
```

### 专项检查模式

```bash
# API兼容性专项检查
/platform-check api-only "ios,android,weapp"

🔍 API兼容性检查结果:

📱 平台API支持情况:
+------------------+-------+----------+--------+
| API名称          | iOS   | Android  | WeApp  |
+------------------+-------+----------+--------+
| Geolocation      | ✅    | ✅       | ⚠️     |
| Camera           | ✅    | ✅       | ✅     |
| Push Notification| ✅    | ✅       | ❌     |
| Bluetooth        | ✅    | ✅       | ⚠️     |
| File System      | ⚠️    | ✅       | ❌     |
+------------------+-------+----------+--------+

⚠️  需要注意的API差异:

1. Geolocation (地理位置)
   - 微信小程序: 需要用户授权，API接口不同
   - 解决方案: 使用统一的定位API封装

2. Push Notification (推送通知)  
   - 微信小程序: 不支持主动推送，使用模板消息
   - 解决方案: 平台适配的消息推送方案

3. File System (文件系统)
   - iOS: 沙盒限制，路径访问受限
   - 微信小程序: 不支持文件系统API
   - 解决方案: 使用平台适配的存储方案
```

## 🛠️ 技术实现

### 兼容性检查引擎

```typescript
interface CompatibilityChecker {
  // API兼容性检查
  checkAPICompatibility(code: string, platforms: Platform[]): APICompatibilityResult;
  
  // UI组件兼容性检查
  checkUICompatibility(components: UIComponent[], platforms: Platform[]): UICompatibilityResult;
  
  // 依赖包兼容性检查
  checkDependencyCompatibility(dependencies: Dependency[], platforms: Platform[]): DependencyCompatibilityResult;
  
  // 生成兼容性报告
  generateReport(results: CompatibilityResult[]): CompatibilityReport;
}

class SmartCompatibilityChecker implements CompatibilityChecker {
  private platformAPIs: Map<Platform, APIDefinition[]> = new Map();
  private compatibilityRules: CompatibilityRule[] = [];
  
  constructor() {
    this.initializePlatformAPIs();
    this.loadCompatibilityRules();
  }
  
  checkAPICompatibility(code: string, platforms: Platform[]): APICompatibilityResult {
    const ast = this.parseCode(code);
    const apiCalls = this.extractAPICalls(ast);
    const issues: APICompatibilityIssue[] = [];
    
    apiCalls.forEach(apiCall => {
      platforms.forEach(platform => {
        const support = this.checkAPISupport(apiCall, platform);
        if (!support.isSupported) {
          issues.push({
            type: 'api_not_supported',
            api: apiCall.name,
            platform,
            line: apiCall.line,
            severity: support.severity,
            message: support.message,
            fixSuggestion: support.fixSuggestion
          });
        }
      });
    });
    
    return {
      totalAPIs: apiCalls.length,
      issues,
      score: this.calculateCompatibilityScore(issues, apiCalls.length)
    };
  }
  
  private checkAPISupport(apiCall: APICall, platform: Platform): APISupportResult {
    const platformAPIs = this.platformAPIs.get(platform);
    const apiDefinition = platformAPIs.find(api => api.name === apiCall.name);
    
    if (!apiDefinition) {
      return {
        isSupported: false,
        severity: 'error',
        message: `API ${apiCall.name} not supported on ${platform}`,
        fixSuggestion: this.generateFixSuggestion(apiCall, platform)
      };
    }
    
    // 检查API版本兼容性
    if (!this.isVersionCompatible(apiCall.version, apiDefinition.supportedVersions)) {
      return {
        isSupported: false,
        severity: 'warning',
        message: `API version ${apiCall.version} not supported`,
        fixSuggestion: `Update to supported version: ${apiDefinition.supportedVersions.join(', ')}`
      };
    }
    
    return { isSupported: true };
  }
  
  private generateFixSuggestion(apiCall: APICall, platform: Platform): string {
    const alternatives = this.getAPIAlternatives(apiCall.name, platform);
    if (alternatives.length > 0) {
      return `Use ${alternatives[0].name} instead: ${alternatives[0].example}`;
    }
    
    return `Consider using a polyfill or platform-specific implementation`;
  }
}
```

### UI组件兼容性分析

```typescript
class UICompatibilityAnalyzer {
  private componentSupport: Map<Platform, ComponentSupport[]> = new Map();
  
  analyzeComponentCompatibility(component: UIComponent, platforms: Platform[]): UICompatibilityResult {
    const issues: UICompatibilityIssue[] = [];
    const suggestions: OptimizationSuggestion[] = [];
    
    platforms.forEach(platform => {
      // 检查组件基础支持
      const basicSupport = this.checkBasicSupport(component, platform);
      if (!basicSupport.isSupported) {
        issues.push(this.createCompatibilityIssue(component, platform, basicSupport));
      }
      
      // 检查样式兼容性
      const styleCompatibility = this.checkStyleCompatibility(component.styles, platform);
      issues.push(...styleCompatibility.issues);
      
      // 检查交互事件兼容性
      const eventCompatibility = this.checkEventCompatibility(component.events, platform);
      issues.push(...eventCompatibility.issues);
      
      // 生成优化建议
      const optimization = this.generateOptimizationSuggestions(component, platform);
      suggestions.push(...optimization);
    });
    
    return {
      component: component.name,
      issues,
      suggestions,
      compatibilityScore: this.calculateUICompatibilityScore(issues, platforms.length)
    };
  }
  
  private checkStyleCompatibility(styles: CSSStyles, platform: Platform): StyleCompatibilityResult {
    const issues: StyleCompatibilityIssue[] = [];
    const unsupportedProperties = this.getUnsupportedStyleProperties(platform);
    
    Object.entries(styles).forEach(([property, value]) => {
      if (unsupportedProperties.includes(property)) {
        issues.push({
          type: 'unsupported_style_property',
          property,
          value,
          platform,
          severity: 'warning',
          alternative: this.getStyleAlternative(property, platform)
        });
      }
      
      // 检查属性值兼容性
      const valueCompatibility = this.checkStyleValueCompatibility(property, value, platform);
      if (!valueCompatibility.isCompatible) {
        issues.push({
          type: 'incompatible_style_value',
          property,
          value,
          platform,
          severity: 'error',
          message: valueCompatibility.message,
          fixSuggestion: valueCompatibility.fixSuggestion
        });
      }
    });
    
    return { issues };
  }
}
```

### 依赖包冲突检测

```typescript
class DependencyCompatibilityChecker {
  private packageRegistry: PackageRegistry;
  private platformConstraints: Map<Platform, PackageConstraint[]> = new Map();
  
  checkDependencies(dependencies: PackageDependency[], platforms: Platform[]): DependencyCompatibilityResult {
    const conflicts: DependencyConflict[] = [];
    const warnings: DependencyWarning[] = [];
    const suggestions: DependencySuggestion[] = [];
    
    // 检查包版本冲突
    const versionConflicts = this.detectVersionConflicts(dependencies);
    conflicts.push(...versionConflicts);
    
    // 检查平台支持
    dependencies.forEach(dep => {
      platforms.forEach(platform => {
        const platformSupport = this.checkPlatformSupport(dep, platform);
        if (!platformSupport.isSupported) {
          conflicts.push({
            type: 'platform_not_supported',
            package: dep.name,
            version: dep.version,
            platform,
            severity: platformSupport.severity,
            message: platformSupport.message,
            alternative: platformSupport.alternative
          });
        }
      });
    });
    
    // 生成优化建议
    suggestions.push(...this.generateDependencyOptimizations(dependencies, platforms));
    
    return {
      totalDependencies: dependencies.length,
      conflicts,
      warnings,
      suggestions,
      healthScore: this.calculateDependencyHealthScore(conflicts, warnings, dependencies.length)
    };
  }
  
  private detectVersionConflicts(dependencies: PackageDependency[]): DependencyConflict[] {
    const conflicts: DependencyConflict[] = [];
    const versionMap = new Map<string, PackageDependency[]>();
    
    // 按包名分组
    dependencies.forEach(dep => {
      if (!versionMap.has(dep.name)) {
        versionMap.set(dep.name, []);
      }
      versionMap.get(dep.name).push(dep);
    });
    
    // 检查版本冲突
    versionMap.forEach((versions, packageName) => {
      if (versions.length > 1) {
        const distinctVersions = [...new Set(versions.map(v => v.version))];
        if (distinctVersions.length > 1) {
          conflicts.push({
            type: 'version_conflict',
            package: packageName,
            versions: distinctVersions,
            severity: 'error',
            message: `Multiple versions of ${packageName} detected: ${distinctVersions.join(', ')}`,
            resolution: this.suggestVersionResolution(versions)
          });
        }
      }
    });
    
    return conflicts;
  }
}
```

## 📊 检查报告生成

### 综合兼容性报告

```typescript
interface CompatibilityReport {
  summary: CompatibilitySummary;
  apiCompatibility: APICompatibilityResult;
  uiCompatibility: UICompatibilityResult[];
  dependencyCompatibility: DependencyCompatibilityResult;
  performanceImpact: PerformanceImpactAnalysis;
  securityIssues: SecurityIssue[];
  recommendations: CompatibilityRecommendation[];
}

class ReportGenerator {
  generateHTML(report: CompatibilityReport): string {
    return `
      <!DOCTYPE html>
      <html>
      <head>
        <title>Platform Compatibility Report</title>
        <style>
          ${this.getReportStyles()}
        </style>
      </head>
      <body>
        <div class="report-container">
          ${this.renderSummary(report.summary)}
          ${this.renderAPICompatibility(report.apiCompatibility)}
          ${this.renderUICompatibility(report.uiCompatibility)}
          ${this.renderDependencyCompatibility(report.dependencyCompatibility)}
          ${this.renderRecommendations(report.recommendations)}
        </div>
        <script>
          ${this.getInteractiveScripts()}
        </script>
      </body>
      </html>
    `;
  }
  
  generateMarkdown(report: CompatibilityReport): string {
    return `
# Platform Compatibility Report

## 📊 Summary
- **Overall Score**: ${report.summary.overallScore}/100
- **Platforms Checked**: ${report.summary.platformsChecked.join(', ')}
- **Total Issues**: ${report.summary.totalIssues}
- **Critical Issues**: ${report.summary.criticalIssues}

## 🔍 API Compatibility
${this.renderAPICompatibilityMarkdown(report.apiCompatibility)}

## 🎨 UI Compatibility  
${this.renderUICompatibilityMarkdown(report.uiCompatibility)}

## 📦 Dependency Compatibility
${this.renderDependencyCompatibilityMarkdown(report.dependencyCompatibility)}

## 💡 Recommendations
${this.renderRecommendationsMarkdown(report.recommendations)}
    `;
  }
  
  generateJSON(report: CompatibilityReport): string {
    return JSON.stringify(report, null, 2);
  }
}
```

### 实时修复建议

```typescript
class AutoFixEngine {
  private fixStrategies: Map<string, FixStrategy> = new Map();
  
  constructor() {
    this.initializeFixStrategies();
  }
  
  generateFixes(issues: CompatibilityIssue[]): FixSuggestion[] {
    return issues.map(issue => {
      const strategy = this.fixStrategies.get(issue.type);
      if (strategy) {
        return strategy.generateFix(issue);
      }
      return this.generateGenericFix(issue);
    });
  }
  
  applyAutoFixes(fixes: FixSuggestion[], options: AutoFixOptions): FixResult[] {
    const results: FixResult[] = [];
    
    fixes.forEach(fix => {
      try {
        if (options.dryRun) {
          results.push(this.simulateFix(fix));
        } else {
          results.push(this.applyFix(fix));
        }
      } catch (error) {
        results.push({
          fix,
          success: false,
          error: error.message
        });
      }
    });
    
    return results;
  }
  
  private initializeFixStrategies() {
    // API不兼容修复策略
    this.fixStrategies.set('api_not_supported', {
      generateFix: (issue: APICompatibilityIssue) => ({
        type: 'code_replacement',
        description: `Replace ${issue.api} with platform-compatible alternative`,
        changes: [{
          file: issue.file,
          line: issue.line,
          oldCode: issue.originalCode,
          newCode: this.generatePlatformCompatibleCode(issue.api, issue.platform)
        }],
        confidence: 0.8
      })
    });
    
    // UI组件修复策略  
    this.fixStrategies.set('unsupported_component', {
      generateFix: (issue: UICompatibilityIssue) => ({
        type: 'component_replacement',
        description: `Replace ${issue.component} with compatible alternative`,
        changes: [{
          file: issue.file,
          line: issue.line,
          oldCode: issue.originalCode,
          newCode: this.generateCompatibleComponent(issue.component, issue.platform)
        }],
        confidence: 0.9
      })
    });
  }
}
```

## 🎯 检查类型详解

### API兼容性检查

```typescript
// 支持的API检查类型
const APICheckTypes = {
  // 存储API
  storage: {
    issues: ['localStorage不支持', 'sessionStorage限制', '存储容量差异'],
    solutions: ['使用uni.storage', '平台适配层', '容量检查']
  },
  
  // 网络请求API
  network: {
    issues: ['CORS限制', 'Request Header限制', '上传文件API差异'],
    solutions: ['代理配置', 'Header适配', '统一上传接口']
  },
  
  // 设备API
  device: {
    issues: ['权限申请方式不同', 'API参数差异', '返回数据格式不同'],
    solutions: ['权限适配层', '参数标准化', '数据格式统一']
  },
  
  // 位置服务API
  location: {
    issues: ['定位精度差异', '权限要求不同', 'API接口不统一'],
    solutions: ['精度配置', '权限封装', '接口抽象']
  }
};
```

### UI组件兼容性检查

```typescript
// UI兼容性检查项目
const UICheckItems = {
  // 表单组件
  forms: {
    input: ['placeholder显示差异', 'focus状态不同', '键盘弹起行为'],
    picker: ['选择器样式差异', '数据格式要求', '事件触发时机'],
    upload: ['文件选择方式', '上传进度显示', '文件类型限制']
  },
  
  // 布局组件
  layout: {
    flexbox: ['flex兼容性', 'align-items支持', 'flex-wrap表现'],
    grid: ['grid支持程度', '网格间距', '响应式表现'],
    position: ['fixed定位', 'sticky定位', 'z-index层级']
  },
  
  // 交互组件
  interaction: {
    scroll: ['滚动惯性', '下拉刷新', '滚动监听'],
    touch: ['触摸事件', '手势识别', '长按交互'],
    animation: ['动画性能', '动画API', 'CSS动画支持']
  }
};
```

## 📈 兼容性评分算法

```typescript
class CompatibilityScorer {
  calculateOverallScore(results: CompatibilityCheckResult[]): number {
    const weights = {
      critical: 0.4,    // 严重问题权重40%
      warning: 0.3,     // 警告问题权重30%
      suggestion: 0.2,  // 建议优化权重20%
      bonus: 0.1        // 额外加分权重10%
    };
    
    let score = 100;
    
    // 扣分项
    results.forEach(result => {
      result.issues.forEach(issue => {
        switch (issue.severity) {
          case 'critical':
            score -= 15 * weights.critical;
            break;
          case 'error':
            score -= 10 * weights.critical;
            break;
          case 'warning':
            score -= 5 * weights.warning;
            break;
          case 'info':
            score -= 2 * weights.suggestion;
            break;
        }
      });
    });
    
    // 加分项
    const bonusPoints = this.calculateBonusPoints(results);
    score += bonusPoints * weights.bonus;
    
    return Math.max(0, Math.min(100, Math.round(score)));
  }
  
  private calculateBonusPoints(results: CompatibilityCheckResult[]): number {
    let bonus = 0;
    
    // 完美兼容某个平台
    if (results.some(r => r.issues.length === 0)) {
      bonus += 10;
    }
    
    // 使用了推荐的兼容性方案
    if (results.some(r => r.hasCompatibilityBestPractices)) {
      bonus += 15;
    }
    
    // 有完善的平台适配代码
    if (results.some(r => r.hasPlatformAdaptation)) {
      bonus += 20;
    }
    
    return bonus;
  }
}
```

## 🔧 自动修复功能

```typescript
interface AutoFixCapability {
  // 自动添加平台适配代码
  addPlatformAdaptation(issue: CompatibilityIssue): Promise<FixResult>;
  
  // 自动替换不兼容API
  replaceIncompatibleAPI(apiCall: APICall, platform: Platform): Promise<FixResult>;
  
  // 自动添加条件编译
  addConditionalCompilation(code: string, platforms: Platform[]): Promise<FixResult>;
  
  // 自动更新依赖版本
  updateDependencyVersions(conflicts: DependencyConflict[]): Promise<FixResult>;
}

class IntelligentAutoFixer implements AutoFixCapability {
  async addPlatformAdaptation(issue: CompatibilityIssue): Promise<FixResult> {
    const adaptationCode = this.generateAdaptationCode(issue);
    const result = await this.applyCodeChange({
      file: issue.file,
      line: issue.line,
      insertCode: adaptationCode,
      type: 'platform_adaptation'
    });
    
    return {
      success: result.success,
      message: `Added platform adaptation for ${issue.api}`,
      changes: result.changes
    };
  }
  
  private generateAdaptationCode(issue: CompatibilityIssue): string {
    switch (issue.platform) {
      case Platform.WeChat:
        return this.generateWeChatAdaptation(issue);
      case Platform.Alipay:
        return this.generateAlipayAdaptation(issue);
      case Platform.H5:
        return this.generateH5Adaptation(issue);
      default:
        return this.generateGenericAdaptation(issue);
    }
  }
  
  private generateWeChatAdaptation(issue: CompatibilityIssue): string {
    return `
// #ifdef MP-WEIXIN
// 微信小程序适配代码
${issue.api.replace(/^web\./, 'wx.')}
// #endif

// #ifndef MP-WEIXIN
// 其他平台代码
${issue.originalCode}
// #endif
    `.trim();
  }
}
```

## 🎯 预期效果

### 兼容性问题检出率
- **API问题检出**: 95%以上的API兼容性问题
- **UI问题检出**: 90%以上的UI组件问题  
- **依赖问题检出**: 98%以上的依赖冲突问题
- **性能问题预警**: 85%以上的性能隐患

### 修复效率提升
- **自动修复率**: 70%以上的问题可自动修复
- **修复准确率**: 92%以上的自动修复正确
- **时间节省**: 节省80%的兼容性调试时间
- **质量提升**: 减少90%的兼容性相关Bug

### 团队协作改善
- **标准化**: 统一的兼容性检查标准
- **可视化**: 直观的兼容性报告
- **知识沉淀**: 兼容性最佳实践库
- **持续改进**: 兼容性问题趋势分析

---

## 🔗 相关命令

- `mobile-project-init` - 移动端项目初始化
- `mobile-performance-analyze` - 移动端性能分析
- `code-migration-assistant` - 代码迁移助手

---

*让跨平台兼容性问题无所遁形！*