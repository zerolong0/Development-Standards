# 项目上下文分析

深度分析项目结构、技术栈、依赖关系，提供全面的项目上下文信息。

## 使用方式

请分析当前项目的上下文信息: $ARGUMENTS

## 🎯 分析维度

### 项目基础信息
1. **项目类型识别**
   - Web应用 / 移动应用 / API服务 / 桌面应用
   - 前端 / 后端 / 全栈 / 微服务
   - 库/框架 / 工具 / 平台

2. **技术栈分析**
   - 编程语言和版本
   - 框架和库依赖
   - 构建工具和配置
   - 数据库和缓存

3. **项目架构**
   - 目录结构分析
   - 模块依赖关系
   - 设计模式应用
   - 架构风格识别

## 🔍 上下文分析报告

### 项目概览模板
```markdown
# 📊 项目上下文分析报告

## 项目基础信息
- **项目名称**: ${PROJECT_NAME}
- **项目类型**: ${PROJECT_TYPE}
- **开发语言**: ${PRIMARY_LANGUAGE}
- **框架版本**: ${FRAMEWORK_VERSION}
- **代码规模**: ${LINES_OF_CODE} 行代码，${FILE_COUNT} 个文件

## 技术栈详情
### 前端技术栈
- **框架**: React 18.2.0 + TypeScript 5.0
- **构建工具**: Vite 4.0 + SWC
- **状态管理**: Zustand + React Query
- **样式方案**: Tailwind CSS + shadcn/ui
- **路由管理**: React Router v6

### 后端技术栈  
- **运行时**: Node.js 20.0 + TypeScript
- **Web框架**: Express.js 4.18
- **数据库**: PostgreSQL 15 + Prisma ORM
- **缓存**: Redis 7.0
- **认证**: JWT + Passport.js

### 开发工具链
- **包管理**: pnpm 8.0
- **代码规范**: ESLint + Prettier + Husky
- **测试框架**: Jest + Playwright
- **CI/CD**: GitHub Actions
- **部署**: Docker + Kubernetes
```

## 🏗️ 项目结构分析

### 目录结构解析
```typescript
// 项目结构分析器
interface ProjectStructure {
  type: 'monorepo' | 'standalone' | 'multi-service';
  pattern: 'feature-based' | 'layer-based' | 'domain-driven';
  organization: DirectoryAnalysis;
}

interface DirectoryAnalysis {
  src: {
    components?: ComponentAnalysis;
    pages?: PageAnalysis;
    services?: ServiceAnalysis;
    utils?: UtilityAnalysis;
    types?: TypeAnalysis;
  };
  config: ConfigAnalysis;
  documentation: DocAnalysis;
  testing: TestAnalysis;
}

class ProjectAnalyzer {
  async analyzeStructure(projectPath: string): Promise<ProjectStructure> {
    const directories = await this.scanDirectories(projectPath);
    const packageFiles = await this.findPackageFiles(projectPath);
    const configFiles = await this.findConfigFiles(projectPath);
    
    return {
      type: this.determineProjectType(directories),
      pattern: this.identifyOrganizationPattern(directories),
      organization: await this.analyzeDirectories(directories)
    };
  }
  
  private determineProjectType(directories: string[]): ProjectStructure['type'] {
    if (directories.includes('packages') || directories.includes('apps')) {
      return 'monorepo';
    }
    if (directories.some(dir => dir.includes('service'))) {
      return 'multi-service';
    }
    return 'standalone';
  }
  
  private identifyOrganizationPattern(directories: string[]): ProjectStructure['pattern'] {
    const hasFeatureDirectories = directories.some(dir => 
      ['features', 'modules', 'domains'].includes(dir)
    );
    
    if (hasFeatureDirectories) return 'feature-based';
    
    const hasLayerDirectories = directories.some(dir =>
      ['controllers', 'services', 'repositories'].includes(dir)
    );
    
    if (hasLayerDirectories) return 'layer-based';
    
    return 'domain-driven';
  }
}
```

### 依赖关系分析
```typescript
// 依赖分析器
interface DependencyGraph {
  packages: PackageDependency[];
  devDependencies: PackageDependency[];
  peerDependencies: PackageDependency[];
  vulnerabilities: SecurityVulnerability[];
  updates: UpdateSuggestion[];
}

interface PackageDependency {
  name: string;
  version: string;
  type: 'production' | 'development' | 'peer';
  size: string;
  license: string;
  lastUpdated: string;
  isOutdated: boolean;
}

class DependencyAnalyzer {
  async analyzeDependencies(packageJsonPath: string): Promise<DependencyGraph> {
    const packageJson = await this.readPackageJson(packageJsonPath);
    
    const dependencies = await Promise.all([
      this.analyzePackages(packageJson.dependencies, 'production'),
      this.analyzePackages(packageJson.devDependencies, 'development'),
      this.analyzePackages(packageJson.peerDependencies, 'peer')
    ]);
    
    return {
      packages: dependencies[0],
      devDependencies: dependencies[1], 
      peerDependencies: dependencies[2],
      vulnerabilities: await this.scanVulnerabilities(),
      updates: await this.checkUpdates()
    };
  }
  
  private async analyzePackages(
    deps: Record<string, string>,
    type: PackageDependency['type']
  ): Promise<PackageDependency[]> {
    const packages: PackageDependency[] = [];
    
    for (const [name, version] of Object.entries(deps || {})) {
      const packageInfo = await this.getPackageInfo(name, version);
      packages.push({
        name,
        version,
        type,
        size: packageInfo.size,
        license: packageInfo.license,
        lastUpdated: packageInfo.lastUpdated,
        isOutdated: packageInfo.isOutdated
      });
    }
    
    return packages.sort((a, b) => a.name.localeCompare(b.name));
  }
}
```

## 🔧 配置文件分析

### 构建配置分析
```typescript
// 构建配置分析器
interface BuildConfiguration {
  bundler: 'webpack' | 'vite' | 'rollup' | 'parcel' | 'esbuild';
  entryPoints: string[];
  outputDir: string;
  optimization: OptimizationConfig;
  plugins: PluginConfig[];
  environment: EnvironmentConfig;
}

class BuildConfigAnalyzer {
  async analyzeConfig(projectPath: string): Promise<BuildConfiguration> {
    const configFiles = await this.findBuildConfigs(projectPath);
    const bundler = this.identifyBundler(configFiles);
    
    switch (bundler) {
      case 'vite':
        return this.analyzeViteConfig(configFiles.vite);
      case 'webpack':
        return this.analyzeWebpackConfig(configFiles.webpack);
      case 'rollup':
        return this.analyzeRollupConfig(configFiles.rollup);
      default:
        return this.analyzePackageJsonScripts(projectPath);
    }
  }
  
  private async analyzeViteConfig(configPath: string): Promise<BuildConfiguration> {
    const config = await import(configPath);
    
    return {
      bundler: 'vite',
      entryPoints: this.extractViteEntries(config),
      outputDir: config.build?.outDir || 'dist',
      optimization: this.analyzeViteOptimization(config),
      plugins: this.analyzeVitePlugins(config.plugins),
      environment: this.analyzeViteEnv(config)
    };
  }
}
```

### TypeScript配置分析
```typescript
// TypeScript配置分析
interface TypeScriptConfig {
  version: string;
  strict: boolean;
  target: string;
  module: string;
  paths: Record<string, string[]>;
  includes: string[];
  excludes: string[];
  plugins: string[];
  issues: TypeScriptIssue[];
}

class TypeScriptAnalyzer {
  async analyzeTSConfig(tsconfigPath: string): Promise<TypeScriptConfig> {
    const tsconfig = await this.readTSConfig(tsconfigPath);
    const compilerOptions = tsconfig.compilerOptions || {};
    
    return {
      version: await this.getTypeScriptVersion(),
      strict: compilerOptions.strict || false,
      target: compilerOptions.target || 'ES5',
      module: compilerOptions.module || 'CommonJS',
      paths: compilerOptions.paths || {},
      includes: tsconfig.include || [],
      excludes: tsconfig.exclude || [],
      plugins: this.extractTSPlugins(compilerOptions),
      issues: await this.analyzeTSIssues(tsconfigPath)
    };
  }
  
  private async analyzeTSIssues(configPath: string): Promise<TypeScriptIssue[]> {
    // 分析TypeScript配置问题
    const issues: TypeScriptIssue[] = [];
    
    // 检查严格模式配置
    if (!this.config.strict) {
      issues.push({
        type: 'warning',
        message: '建议启用strict模式以提高类型安全性',
        suggestion: 'compilerOptions.strict: true'
      });
    }
    
    // 检查路径映射
    if (Object.keys(this.config.paths).length > 0 && !this.config.baseUrl) {
      issues.push({
        type: 'error',
        message: '使用paths时需要配置baseUrl',
        suggestion: 'compilerOptions.baseUrl: "./"'
      });
    }
    
    return issues;
  }
}
```

## 📋 项目评估和建议

### 代码质量评估
```typescript
// 代码质量分析器
interface CodeQualityReport {
  metrics: QualityMetrics;
  issues: CodeIssue[];
  suggestions: ImprovementSuggestion[];
  score: QualityScore;
}

interface QualityMetrics {
  linesOfCode: number;
  complexity: number;
  testCoverage: number;
  duplication: number;
  maintainabilityIndex: number;
}

class CodeQualityAnalyzer {
  async analyzeProject(projectPath: string): Promise<CodeQualityReport> {
    const metrics = await this.calculateMetrics(projectPath);
    const issues = await this.scanIssues(projectPath);
    const suggestions = this.generateSuggestions(metrics, issues);
    const score = this.calculateScore(metrics, issues);
    
    return {
      metrics,
      issues,
      suggestions,
      score
    };
  }
  
  private async calculateMetrics(projectPath: string): Promise<QualityMetrics> {
    const sourceFiles = await this.findSourceFiles(projectPath);
    
    return {
      linesOfCode: await this.countLinesOfCode(sourceFiles),
      complexity: await this.calculateComplexity(sourceFiles),
      testCoverage: await this.getTestCoverage(projectPath),
      duplication: await this.detectDuplication(sourceFiles),
      maintainabilityIndex: await this.calculateMaintainability(sourceFiles)
    };
  }
  
  private generateSuggestions(
    metrics: QualityMetrics, 
    issues: CodeIssue[]
  ): ImprovementSuggestion[] {
    const suggestions: ImprovementSuggestion[] = [];
    
    if (metrics.testCoverage < 80) {
      suggestions.push({
        priority: 'high',
        category: 'testing',
        title: '提高测试覆盖率',
        description: `当前测试覆盖率${metrics.testCoverage}%，建议提高至80%以上`,
        effort: 'medium',
        impact: 'high'
      });
    }
    
    if (metrics.complexity > 10) {
      suggestions.push({
        priority: 'medium',
        category: 'refactoring',
        title: '降低代码复杂度',
        description: '存在高复杂度函数，建议重构分解',
        effort: 'high',
        impact: 'medium'
      });
    }
    
    return suggestions;
  }
}
```

### 技术栈现代化建议
```typescript
// 技术栈分析器
interface TechStackAnalysis {
  current: TechStackItem[];
  outdated: OutdatedItem[];
  security: SecurityIssue[];
  modernization: ModernizationSuggestion[];
}

interface ModernizationSuggestion {
  category: 'framework' | 'tooling' | 'dependencies';
  current: string;
  recommended: string;
  reason: string;
  effort: 'low' | 'medium' | 'high';
  benefits: string[];
  migrationPath: string[];
}

class TechStackAnalyzer {
  async analyzeTechStack(projectPath: string): Promise<TechStackAnalysis> {
    const packageJson = await this.readPackageJson(projectPath);
    const current = this.identifyTechStack(packageJson);
    const outdated = await this.findOutdatedDependencies(current);
    const security = await this.scanSecurityIssues(current);
    const modernization = this.generateModernizationSuggestions(current);
    
    return {
      current,
      outdated,
      security,
      modernization
    };
  }
  
  private generateModernizationSuggestions(
    current: TechStackItem[]
  ): ModernizationSuggestion[] {
    const suggestions: ModernizationSuggestion[] = [];
    
    // 检查React版本
    const reactItem = current.find(item => item.name === 'react');
    if (reactItem && this.compareVersions(reactItem.version, '18.0.0') < 0) {
      suggestions.push({
        category: 'framework',
        current: `React ${reactItem.version}`,
        recommended: 'React 18+',
        reason: 'React 18带来了并发特性、自动批处理等重要改进',
        effort: 'medium',
        benefits: [
          '更好的用户体验',
          '自动批处理减少重渲染',
          '并发渲染改善性能',
          '更好的服务端渲染支持'
        ],
        migrationPath: [
          '1. 升级React和ReactDOM到18.x',
          '2. 使用createRoot替代render',
          '3. 检查废弃的API使用',
          '4. 逐步采用并发特性'
        ]
      });
    }
    
    // 检查构建工具
    if (this.hasWebpack(current) && !this.hasVite(current)) {
      suggestions.push({
        category: 'tooling',
        current: 'Webpack',
        recommended: 'Vite',
        reason: 'Vite提供更快的开发服务器和构建速度',
        effort: 'medium',
        benefits: [
          '极快的冷启动',
          '即时热模块更新',
          '更简单的配置',
          'ES模块原生支持'
        ],
        migrationPath: [
          '1. 安装Vite相关依赖',
          '2. 创建vite.config.ts配置文件',
          '3. 更新package.json脚本',
          '4. 迁移Webpack特定配置'
        ]
      });
    }
    
    return suggestions;
  }
}
```

## 💡 项目优化建议

### 性能优化建议
```markdown
## 🚀 性能优化建议

### 前端性能优化
1. **Bundle优化**
   - 代码分割：按路由和功能模块拆分
   - Tree shaking：移除未使用的代码
   - 压缩优化：Terser/SWC压缩配置

2. **资源优化**
   - 图片优化：WebP格式，响应式图片
   - 字体优化：字体子集化，font-display设置
   - 静态资源CDN：提高加载速度

3. **运行时优化**
   - React.memo：防止不必要重渲染
   - useMemo/useCallback：缓存计算结果
   - 虚拟滚动：大列表性能优化

### 后端性能优化
1. **数据库优化**
   - 索引优化：为查询字段添加索引
   - 查询优化：避免N+1查询
   - 连接池：优化数据库连接管理

2. **缓存策略**
   - Redis缓存：热点数据缓存
   - 应用缓存：内存级缓存优化
   - CDN缓存：静态资源缓存

3. **架构优化**
   - 异步处理：IO密集操作异步化
   - 负载均衡：水平扩展支持
   - 监控告警：性能指标监控
```

### 安全加固建议
```markdown
## 🛡️ 安全加固建议

### 认证安全
- JWT配置：设置合理的过期时间
- 密码策略：强密码规则，哈希存储
- 多因子认证：提高账户安全性

### 数据安全  
- 输入验证：防止注入攻击
- 数据加密：敏感数据加密存储
- 访问控制：最小权限原则

### 基础设施安全
- HTTPS配置：强制SSL/TLS
- 安全头设置：CSP、HSTS等
- 依赖扫描：定期检查漏洞
```

请开始项目上下文分析。