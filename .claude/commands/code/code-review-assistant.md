# AI代码审查助手

智能化代码审查工具，提供全面的代码质量分析和改进建议。

## 使用方式

请对以下代码进行全面审查: $ARGUMENTS

## 🎯 审查维度

### 代码质量检查
1. **代码规范** - 命名规范、格式规范、注释规范
2. **架构设计** - 设计模式、SOLID原则、依赖关系
3. **性能优化** - 算法复杂度、内存使用、IO优化
4. **安全漏洞** - 注入攻击、权限控制、数据验证
5. **可维护性** - 代码重复、耦合度、测试覆盖

### 最佳实践检查
- **语言特定** - 各编程语言的最佳实践
- **框架规范** - React/Vue/Angular等框架约定
- **工程化** - 构建配置、部署脚本、CI/CD
- **团队协作** - Git规范、文档完整性

## 🔍 代码审查报告

### 审查报告模板
```markdown
# 🔍 代码审查报告

## 📊 总体评分
**代码质量评分**: ⭐⭐⭐⭐☆ (8.5/10)

| 维度 | 评分 | 说明 |
|------|------|------|
| 代码规范 | 9/10 | 命名清晰，格式统一 |
| 架构设计 | 8/10 | 结构合理，可扩展性良好 |
| 性能表现 | 7/10 | 存在优化空间 |
| 安全性 | 9/10 | 安全措施到位 |
| 可维护性 | 8/10 | 代码清晰，测试充分 |

## ✅ 代码优点
1. **清晰的代码结构** - 文件组织合理，职责分离明确
2. **良好的命名规范** - 变量和函数命名语义化
3. **完整的类型定义** - TypeScript类型覆盖完整
4. **适当的错误处理** - 异常情况处理得当

## ⚠️ 需要改进的问题

### 🔴 严重问题 (必须修复)
1. **安全漏洞 - SQL注入风险**
   ```typescript
   // ❌ 问题代码 (第45行)
   const query = `SELECT * FROM users WHERE id = ${userId}`;
   
   // ✅ 建议修复
   const query = 'SELECT * FROM users WHERE id = ?';
   const result = await db.query(query, [userId]);
   ```
   **影响**: 可能导致数据库被恶意访问
   **建议**: 使用参数化查询防止SQL注入

2. **内存泄漏风险**
   ```typescript
   // ❌ 问题代码 (第78行)
   useEffect(() => {
     const interval = setInterval(() => {
       fetchData();
     }, 1000);
     // 缺少清理函数
   }, []);
   
   // ✅ 建议修复
   useEffect(() => {
     const interval = setInterval(() => {
       fetchData();
     }, 1000);
     
     return () => clearInterval(interval);
   }, []);
   ```

### 🟡 中等问题 (建议修复)
1. **性能优化 - 重复渲染**
   ```typescript
   // ❌ 问题代码 (第92行)
   const UserList = ({ users }) => {
     return (
       <div>
         {users.map(user => (
           <UserCard key={user.id} user={user} />
         ))}
       </div>
     );
   };
   
   // ✅ 建议优化
   const UserList = React.memo(({ users }) => {
     return (
       <div>
         {users.map(user => (
           <UserCard key={user.id} user={user} />
         ))}
       </div>
     );
   });
   ```

2. **代码重复**
   ```typescript
   // ❌ 重复代码
   const validateEmail = (email: string): boolean => {
     const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
     return emailRegex.test(email);
   };
   
   const validateUserEmail = (email: string): boolean => {
     const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
     return emailRegex.test(email);
   };
   
   // ✅ 建议重构
   const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
   
   const validateEmail = (email: string): boolean => {
     return EMAIL_REGEX.test(email);
   };
   ```

### 🟢 轻微问题 (可选修复)
1. **命名改进**
   ```typescript
   // ❌ 命名不够清晰
   const data = await fetchUserData();
   const result = processData(data);
   
   // ✅ 建议改进
   const userData = await fetchUserData();
   const processedUserData = processUserData(userData);
   ```

2. **注释补充**
   ```typescript
   // ❌ 缺少注释的复杂逻辑
   const calculateScore = (metrics: Metrics[]): number => {
     return metrics.reduce((acc, metric) => {
       return acc + (metric.value * metric.weight * 0.85);
     }, 0) / metrics.length;
   };
   
   // ✅ 建议添加注释
   /**
    * 计算加权平均分数
    * @param metrics 指标数组
    * @returns 计算后的平均分数，应用0.85的调整系数
    */
   const calculateScore = (metrics: Metrics[]): number => {
     return metrics.reduce((acc, metric) => {
       // 应用权重和调整系数计算单项得分
       return acc + (metric.value * metric.weight * 0.85);
     }, 0) / metrics.length;
   };
   ```

## 🚀 优化建议

### 性能优化建议
1. **使用React.memo优化组件渲染**
2. **实现虚拟滚动处理大列表**
3. **添加适当的缓存机制**
4. **优化数据库查询，添加索引**

### 架构改进建议
1. **引入状态管理库管理全局状态**
2. **实现错误边界处理组件错误**
3. **添加日志系统便于问题排查**
4. **考虑使用依赖注入提高可测试性**

### 安全加固建议
1. **所有用户输入都需要验证和清理**
2. **敏感数据传输使用HTTPS加密**
3. **实现适当的访问控制和权限检查**
4. **定期更新依赖库，修复安全漏洞**

## 📝 后续行动项
- [ ] 修复SQL注入安全漏洞 (优先级: 高)
- [ ] 添加内存泄漏清理逻辑 (优先级: 高)
- [ ] 优化组件渲染性能 (优先级: 中)
- [ ] 重构重复代码 (优先级: 中)
- [ ] 改进命名和注释 (优先级: 低)

---
**审查完成时间**: 2025-08-30 10:30:00
**审查者**: AI代码审查助手
**建议复审时间**: 修复完成后
```

## 🤖 智能审查引擎

### 代码分析器
```typescript
// 代码质量分析器
interface CodeAnalysisResult {
  score: QualityScore;
  issues: CodeIssue[];
  suggestions: Suggestion[];
  metrics: CodeMetrics;
}

interface CodeIssue {
  severity: 'critical' | 'major' | 'minor';
  category: 'security' | 'performance' | 'maintainability' | 'style';
  message: string;
  file: string;
  line: number;
  column?: number;
  rule: string;
  fix?: AutoFix;
}

interface Suggestion {
  type: 'refactor' | 'optimize' | 'security' | 'style';
  title: string;
  description: string;
  before: string;
  after: string;
  impact: 'high' | 'medium' | 'low';
  effort: 'high' | 'medium' | 'low';
}

class CodeAnalyzer {
  async analyzeCode(code: string, language: string): Promise<CodeAnalysisResult> {
    const ast = this.parseCode(code, language);
    const issues = await this.findIssues(ast, code);
    const suggestions = this.generateSuggestions(issues, ast);
    const metrics = this.calculateMetrics(ast, code);
    const score = this.calculateScore(issues, metrics);
    
    return {
      score,
      issues: this.prioritizeIssues(issues),
      suggestions: this.rankSuggestions(suggestions),
      metrics
    };
  }
  
  private async findIssues(ast: AST, code: string): Promise<CodeIssue[]> {
    const issues: CodeIssue[] = [];
    
    // 安全问题检查
    issues.push(...this.findSecurityIssues(ast));
    
    // 性能问题检查
    issues.push(...this.findPerformanceIssues(ast));
    
    // 可维护性问题检查
    issues.push(...this.findMaintainabilityIssues(ast));
    
    // 代码风格检查
    issues.push(...this.findStyleIssues(code));
    
    return issues;
  }
  
  private findSecurityIssues(ast: AST): CodeIssue[] {
    const issues: CodeIssue[] = [];
    
    // 检查SQL注入
    ast.traverse(node => {
      if (node.type === 'TemplateString' && 
          this.containsSQLKeywords(node.value)) {
        issues.push({
          severity: 'critical',
          category: 'security',
          message: '潜在的SQL注入漏洞，使用参数化查询',
          file: node.file,
          line: node.line,
          rule: 'no-sql-injection',
          fix: {
            type: 'replace',
            original: node.value,
            replacement: this.generateParameterizedQuery(node.value)
          }
        });
      }
    });
    
    // 检查XSS漏洞
    ast.traverse(node => {
      if (node.type === 'JSXElement' && 
          node.props.dangerouslySetInnerHTML) {
        issues.push({
          severity: 'major',
          category: 'security',
          message: '使用dangerouslySetInnerHTML存在XSS风险',
          file: node.file,
          line: node.line,
          rule: 'no-dangerous-html'
        });
      }
    });
    
    return issues;
  }
  
  private findPerformanceIssues(ast: AST): CodeIssue[] {
    const issues: CodeIssue[] = [];
    
    // 检查渲染优化
    ast.traverse(node => {
      if (node.type === 'FunctionComponent' && 
          !this.hasMemoization(node)) {
        issues.push({
          severity: 'minor',
          category: 'performance', 
          message: '考虑使用React.memo优化组件渲染',
          file: node.file,
          line: node.line,
          rule: 'react-memo-optimization'
        });
      }
    });
    
    // 检查循环复杂度
    ast.traverse(node => {
      if (node.type === 'ForStatement' || node.type === 'WhileStatement') {
        const complexity = this.calculateCyclomaticComplexity(node);
        if (complexity > 10) {
          issues.push({
            severity: 'major',
            category: 'performance',
            message: `循环复杂度过高 (${complexity})，考虑重构`,
            file: node.file,
            line: node.line,
            rule: 'max-complexity'
          });
        }
      }
    });
    
    return issues;
  }
}
```

### 自动修复建议
```typescript
// 自动修复引擎
interface AutoFix {
  type: 'replace' | 'insert' | 'delete' | 'move';
  original: string;
  replacement?: string;
  position?: Position;
  description: string;
}

class AutoFixEngine {
  generateFixes(issues: CodeIssue[]): AutoFix[] {
    return issues
      .filter(issue => issue.fix)
      .map(issue => issue.fix!)
      .filter(Boolean);
  }
  
  // 常见修复模式
  generateCommonFixes(): Record<string, AutoFix> {
    return {
      // SQL注入修复
      'sql-injection': {
        type: 'replace',
        original: 'SELECT * FROM users WHERE id = ${id}',
        replacement: 'SELECT * FROM users WHERE id = ?',
        description: '使用参数化查询防止SQL注入'
      },
      
      // 内存泄漏修复
      'memory-leak-interval': {
        type: 'insert',
        original: 'useEffect(() => { setInterval(...) }, [])',
        replacement: 'useEffect(() => { const interval = setInterval(...); return () => clearInterval(interval); }, [])',
        description: '添加清理函数防止内存泄漏'
      },
      
      // 性能优化
      'react-memo': {
        type: 'replace',
        original: 'const Component = (props) => { ... }',
        replacement: 'const Component = React.memo((props) => { ... })',
        description: '使用React.memo优化渲染性能'
      },
      
      // 类型安全
      'add-type-annotation': {
        type: 'replace',
        original: 'const data = await fetchData()',
        replacement: 'const data: ApiResponse = await fetchData()',
        description: '添加类型注解提高类型安全'
      }
    };
  }
  
  // 批量应用修复
  async applyFixes(code: string, fixes: AutoFix[]): Promise<string> {
    let fixedCode = code;
    
    // 按位置倒序排列，避免位置偏移
    const sortedFixes = fixes.sort((a, b) => 
      (b.position?.line || 0) - (a.position?.line || 0)
    );
    
    for (const fix of sortedFixes) {
      switch (fix.type) {
        case 'replace':
          fixedCode = fixedCode.replace(fix.original, fix.replacement || '');
          break;
          
        case 'insert':
          fixedCode = this.insertAtPosition(fixedCode, fix.replacement!, fix.position!);
          break;
          
        case 'delete':
          fixedCode = fixedCode.replace(fix.original, '');
          break;
      }
    }
    
    return fixedCode;
  }
}
```

## 📊 代码度量分析

### 复杂度分析
```typescript
// 代码复杂度计算器
interface ComplexityMetrics {
  cyclomaticComplexity: number;
  cognitiveComplexity: number;
  maintainabilityIndex: number;
  halsteadMetrics: HalsteadMetrics;
}

class ComplexityAnalyzer {
  calculateCyclomaticComplexity(ast: AST): number {
    let complexity = 1; // 基础复杂度
    
    ast.traverse(node => {
      // 条件语句增加复杂度
      if (['IfStatement', 'WhileStatement', 'ForStatement', 
           'SwitchCase', 'ConditionalExpression'].includes(node.type)) {
        complexity++;
      }
      
      // 逻辑运算符增加复杂度
      if (node.type === 'LogicalExpression' && 
          ['&&', '||'].includes(node.operator)) {
        complexity++;
      }
      
      // Try-catch语句
      if (node.type === 'CatchClause') {
        complexity++;
      }
    });
    
    return complexity;
  }
  
  calculateCognitiveComplexity(ast: AST): number {
    let complexity = 0;
    let nestingLevel = 0;
    
    ast.traverse(node => {
      const previousNesting = nestingLevel;
      
      // 计算嵌套级别
      if (['IfStatement', 'WhileStatement', 'ForStatement'].includes(node.type)) {
        nestingLevel++;
        complexity += nestingLevel; // 嵌套越深，复杂度增加越多
      }
      
      // 特殊情况
      if (node.type === 'SwitchStatement') {
        complexity += 1;
      }
      
      // 递归调用
      if (node.type === 'CallExpression' && this.isRecursiveCall(node)) {
        complexity += 1;
      }
      
      // 恢复嵌套级别
      if (['IfStatement', 'WhileStatement', 'ForStatement'].includes(node.type)) {
        nestingLevel = previousNesting;
      }
    });
    
    return complexity;
  }
  
  calculateMaintainabilityIndex(
    linesOfCode: number,
    cyclomaticComplexity: number,
    halstead: HalsteadMetrics
  ): number {
    // 微软维护性指数公式
    const maintainabilityIndex = Math.max(0, 
      171 - 5.2 * Math.log(halstead.volume) - 
      0.23 * cyclomaticComplexity - 
      16.2 * Math.log(linesOfCode)
    ) * 100 / 171;
    
    return Math.round(maintainabilityIndex);
  }
}
```

## 💡 最佳实践检查器

### 框架特定检查
```typescript
// React最佳实践检查器
class ReactBestPracticesChecker {
  checkComponent(component: ComponentAST): BestPracticeIssue[] {
    const issues: BestPracticeIssue[] = [];
    
    // 检查Hook使用
    issues.push(...this.checkHookUsage(component));
    
    // 检查组件性能
    issues.push(...this.checkPerformance(component));
    
    // 检查可访问性
    issues.push(...this.checkAccessibility(component));
    
    return issues;
  }
  
  private checkHookUsage(component: ComponentAST): BestPracticeIssue[] {
    const issues: BestPracticeIssue[] = [];
    
    // 检查useEffect依赖
    component.hooks.useEffect.forEach(effect => {
      if (effect.dependencies && this.hasMissingDependencies(effect)) {
        issues.push({
          type: 'hook-dependencies',
          severity: 'major',
          message: 'useEffect依赖数组可能缺少依赖项',
          suggestion: '添加所有在effect中使用的变量到依赖数组'
        });
      }
    });
    
    // 检查useState初始值
    component.hooks.useState.forEach(state => {
      if (state.initialValue && this.isExpensiveComputation(state.initialValue)) {
        issues.push({
          type: 'expensive-initial-state',
          severity: 'minor', 
          message: 'useState初始值存在昂贵计算',
          suggestion: '使用惰性初始状态或useMemo优化'
        });
      }
    });
    
    return issues;
  }
  
  private checkPerformance(component: ComponentAST): BestPracticeIssue[] {
    const issues: BestPracticeIssue[] = [];
    
    // 检查是否需要memo
    if (!component.isMemoized && this.shouldUseMemo(component)) {
      issues.push({
        type: 'missing-memo',
        severity: 'minor',
        message: '组件可能受益于React.memo优化',
        suggestion: '使用React.memo包装组件以避免不必要的重渲染'
      });
    }
    
    // 检查key属性
    component.lists.forEach(list => {
      if (!list.hasKey || this.isIndexUsedAsKey(list.key)) {
        issues.push({
          type: 'missing-key',
          severity: 'major',
          message: '列表项缺少合适的key属性',
          suggestion: '使用稳定且唯一的标识符作为key'
        });
      }
    });
    
    return issues;
  }
}

// Node.js最佳实践检查器
class NodejsBestPracticesChecker {
  checkAPI(apiCode: APICodeAST): BestPracticeIssue[] {
    const issues: BestPracticeIssue[] = [];
    
    // 检查错误处理
    issues.push(...this.checkErrorHandling(apiCode));
    
    // 检查安全性
    issues.push(...this.checkSecurity(apiCode));
    
    // 检查性能
    issues.push(...this.checkPerformance(apiCode));
    
    return issues;
  }
  
  private checkErrorHandling(apiCode: APICodeAST): BestPracticeIssue[] {
    const issues: BestPracticeIssue[] = [];
    
    // 检查未处理的Promise
    apiCode.asyncFunctions.forEach(func => {
      if (!func.hasTryCatch && !func.hasErrorHandler) {
        issues.push({
          type: 'unhandled-promise',
          severity: 'major',
          message: '异步函数缺少错误处理',
          suggestion: '添加try-catch块或.catch()处理器'
        });
      }
    });
    
    // 检查全局错误处理
    if (!apiCode.hasGlobalErrorHandler) {
      issues.push({
        type: 'missing-global-error-handler',
        severity: 'major',
        message: '缺少全局错误处理中间件',
        suggestion: '添加全局错误处理中间件捕获未处理的错误'
      });
    }
    
    return issues;
  }
}
```

请开始代码审查。