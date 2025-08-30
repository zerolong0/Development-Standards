# 工作流自动化引擎

智能化开发工作流自动化，提高团队协作效率和代码质量。

## 使用方式

请设置或执行自动化工作流: $ARGUMENTS

## 🎯 自动化场景

### 开发工作流自动化
1. **代码提交自动化** - 自动代码检查、格式化、测试运行
2. **PR审查自动化** - 自动分配审查者、状态检查、合并条件
3. **发布自动化** - 版本管理、打包构建、部署发布
4. **依赖管理** - 安全扫描、版本更新、兼容性检查

### 项目管理自动化
- **Issue管理** - 自动标签分配、优先级设置、通知分发
- **项目看板** - 状态同步、进度跟踪、报告生成
- **团队协作** - 任务分配、进度提醒、绩效统计

## 🔧 GitHub Actions工作流

### 完整CI/CD流水线
```yaml
# .github/workflows/ci-cd.yml
name: 🚀 CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  release:
    types: [created]

env:
  NODE_VERSION: '20'
  PNPM_VERSION: '8'

jobs:
  # 代码质量检查
  quality-check:
    name: 📊 Quality Check
    runs-on: ubuntu-latest
    steps:
      - name: 📚 Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: 📦 Setup PNPM
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}

      - name: 🔧 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'

      - name: 📥 Install Dependencies
        run: pnpm install --frozen-lockfile

      - name: 🔍 Lint Code
        run: pnpm lint

      - name: 💅 Check Code Format
        run: pnpm format:check

      - name: 🔒 Type Check
        run: pnpm type-check

      - name: 🛡️ Security Audit
        run: pnpm audit --audit-level moderate

      - name: 📊 Code Coverage
        run: pnpm test:coverage

      - name: 📈 Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          token: ${{ secrets.CODECOV_TOKEN }}

  # 自动化测试
  test-matrix:
    name: 🧪 Test Matrix
    runs-on: ${{ matrix.os }}
    needs: quality-check
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: ['18', '20', '21']
        exclude:
          - os: windows-latest
            node-version: '18'
          - os: macos-latest
            node-version: '18'

    steps:
      - uses: actions/checkout@v4
      
      - name: 🔧 Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'pnpm'

      - run: pnpm install --frozen-lockfile
      - run: pnpm test
      - run: pnpm build

  # 性能基准测试
  performance-test:
    name: ⚡ Performance Test
    runs-on: ubuntu-latest
    needs: quality-check
    if: github.event_name == 'pull_request'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: 📦 Setup Environment
        uses: ./.github/actions/setup
        
      - name: 🏃 Run Benchmarks
        run: pnpm benchmark
        
      - name: 📊 Performance Report
        uses: benchmark-action/github-action-benchmark@v1
        with:
          tool: 'benchmarkjs'
          output-file-path: benchmark-results.json
          github-token: ${{ secrets.GITHUB_TOKEN }}
          auto-push: true

  # 自动构建
  build:
    name: 🏗️ Build
    runs-on: ubuntu-latest
    needs: [quality-check, test-matrix]
    outputs:
      version: ${{ steps.version.outputs.version }}
      
    steps:
      - uses: actions/checkout@v4
      
      - name: 📦 Setup Environment
        uses: ./.github/actions/setup
        
      - name: 📝 Generate Version
        id: version
        run: |
          if [[ ${{ github.event_name }} == 'release' ]]; then
            echo "version=${{ github.event.release.tag_name }}" >> $GITHUB_OUTPUT
          else
            echo "version=$(date +'%Y%m%d')-${{ github.sha:0:7 }}" >> $GITHUB_OUTPUT
          fi
      
      - name: 🏗️ Build Application
        run: |
          pnpm build
          echo "VERSION=${{ steps.version.outputs.version }}" > .env.production
          
      - name: 📦 Build Docker Image
        run: |
          docker build -t app:${{ steps.version.outputs.version }} .
          docker tag app:${{ steps.version.outputs.version }} app:latest
          
      - name: 💾 Archive Build Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-${{ steps.version.outputs.version }}
          path: |
            dist/
            .env.production
          retention-days: 30

  # 自动部署
  deploy-staging:
    name: 🚀 Deploy to Staging
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop'
    environment: staging
    
    steps:
      - name: 📥 Download Artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-${{ needs.build.outputs.version }}
          
      - name: 🚀 Deploy to Staging
        run: |
          echo "Deploying version ${{ needs.build.outputs.version }} to staging"
          # 添加实际部署脚本
          
      - name: 🧪 Run Smoke Tests
        run: |
          curl -f https://staging.example.com/health || exit 1
          curl -f https://staging.example.com/api/status || exit 1
          
      - name: 📢 Notify Team
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: "🚀 Staging deployment completed: ${{ needs.build.outputs.version }}"
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  deploy-production:
    name: 🌟 Deploy to Production
    runs-on: ubuntu-latest
    needs: build
    if: github.event_name == 'release'
    environment: production
    
    steps:
      - name: 🔐 Production Deployment Approval
        uses: trstringer/manual-approval@v1
        with:
          secret: ${{ github.TOKEN }}
          approvers: team-leads,senior-devs
          
      - name: 📥 Download Artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-${{ needs.build.outputs.version }}
          
      - name: 🌟 Deploy to Production
        run: |
          echo "Deploying version ${{ needs.build.outputs.version }} to production"
          # 蓝绿部署或滚动更新
          
      - name: 📊 Update Monitoring
        run: |
          curl -X POST "https://api.datadog.com/api/v1/events" \
          -H "Content-Type: application/json" \
          -H "DD-API-KEY: ${{ secrets.DD_API_KEY }}" \
          -d '{
            "title": "Production Deployment",
            "text": "Version ${{ needs.build.outputs.version }} deployed",
            "tags": ["deployment", "production"]
          }'
```

### 自动化PR管理
```yaml
# .github/workflows/pr-automation.yml
name: 🔄 PR Automation

on:
  pull_request:
    types: [opened, synchronize, reopened, closed]
  pull_request_review:
    types: [submitted]

jobs:
  pr-automation:
    name: 🤖 PR Automation
    runs-on: ubuntu-latest
    
    steps:
      - name: 📚 Checkout
        uses: actions/checkout@v4
        
      - name: 🏷️ Auto Label PR
        uses: actions/labeler@v4
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          configuration-path: .github/labeler.yml
          
      - name: 📏 Check PR Size
        uses: pascalgn/size-label-action@v0.4.3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          sizes: >
            {
              "0": "XS",
              "20": "S", 
              "100": "M",
              "500": "L",
              "1000": "XL"
            }
            
      - name: 👥 Auto Assign Reviewers
        uses: kentaro-m/auto-assign-action@v1.2.4
        with:
          configuration-path: .github/auto-assign.yml
          
      - name: 🔍 PR Quality Check
        run: |
          # 检查PR标题格式
          if [[ ! "${{ github.event.pull_request.title }}" =~ ^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+ ]]; then
            echo "❌ PR title should follow conventional commits format"
            exit 1
          fi
          
          # 检查PR描述
          if [[ -z "${{ github.event.pull_request.body }}" ]]; then
            echo "❌ PR description is required"
            exit 1
          fi
          
      - name: 📝 Add PR Template Check
        uses: Julien-Devillars/pr-check@v1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          template-path: .github/PULL_REQUEST_TEMPLATE.md
          
      - name: 🚀 Auto Merge
        if: |
          github.event.pull_request.draft == false &&
          contains(github.event.pull_request.labels.*.name, 'automerge') &&
          github.event.review.state == 'approved'
        uses: pascalgn/auto-merge-action@v0.15.6
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          MERGE_LABELS: "automerge,!work-in-progress"
          MERGE_METHOD: "squash"
```

## 🔄 自定义工作流生成器

### 工作流配置模板
```typescript
// 工作流配置生成器
interface WorkflowConfig {
  name: string;
  triggers: WorkflowTrigger[];
  jobs: WorkflowJob[];
  environment: EnvironmentConfig;
  notifications: NotificationConfig;
}

interface WorkflowTrigger {
  event: 'push' | 'pull_request' | 'release' | 'schedule' | 'workflow_dispatch';
  branches?: string[];
  paths?: string[];
  schedule?: string;
}

interface WorkflowJob {
  name: string;
  runs_on: string;
  needs?: string[];
  if?: string;
  steps: WorkflowStep[];
  outputs?: Record<string, string>;
}

class WorkflowGenerator {
  generateWorkflow(config: WorkflowConfig): string {
    return `name: ${config.name}

on:
${this.generateTriggers(config.triggers)}

${this.generateEnvironment(config.environment)}

jobs:
${config.jobs.map(job => this.generateJob(job)).join('\n\n')}`;
  }
  
  private generateTriggers(triggers: WorkflowTrigger[]): string {
    return triggers.map(trigger => {
      switch (trigger.event) {
        case 'push':
          return `  push:
    branches: [${trigger.branches?.map(b => `'${b}'`).join(', ') || 'main'}]
    paths: [${trigger.paths?.map(p => `'${p}'`).join(', ') || '"**"'}]`;
          
        case 'pull_request':
          return `  pull_request:
    branches: [${trigger.branches?.map(b => `'${b}'`).join(', ') || 'main'}]`;
          
        case 'schedule':
          return `  schedule:
    - cron: '${trigger.schedule || '0 0 * * *'}'`;
          
        case 'workflow_dispatch':
          return `  workflow_dispatch:`;
          
        default:
          return `  ${trigger.event}:`;
      }
    }).join('\n');
  }
  
  private generateJob(job: WorkflowJob): string {
    return `  ${job.name.toLowerCase().replace(/\s+/g, '-')}:
    name: ${job.name}
    runs-on: ${job.runs_on}
    ${job.needs ? `needs: [${job.needs.join(', ')}]` : ''}
    ${job.if ? `if: ${job.if}` : ''}
    ${job.outputs ? `outputs:\n${Object.entries(job.outputs).map(([k, v]) => `      ${k}: ${v}`).join('\n')}` : ''}
    
    steps:
${job.steps.map(step => this.generateStep(step)).join('\n')}`;
  }
  
  private generateStep(step: WorkflowStep): string {
    return `      - name: ${step.name}
        ${step.uses ? `uses: ${step.uses}` : ''}
        ${step.run ? `run: ${step.run}` : ''}
        ${step.with ? `with:\n${Object.entries(step.with).map(([k, v]) => `          ${k}: ${v}`).join('\n')}` : ''}
        ${step.env ? `env:\n${Object.entries(step.env).map(([k, v]) => `          ${k}: ${v}`).join('\n')}` : ''}`;
  }
}

// 使用示例
const frontendWorkflow: WorkflowConfig = {
  name: 'Frontend CI/CD',
  triggers: [
    { event: 'push', branches: ['main', 'develop'] },
    { event: 'pull_request', branches: ['main'] }
  ],
  jobs: [
    {
      name: 'Build and Test',
      runs_on: 'ubuntu-latest',
      steps: [
        { name: 'Checkout', uses: 'actions/checkout@v4' },
        { name: 'Setup Node.js', uses: 'actions/setup-node@v4', with: { 'node-version': '20' } },
        { name: 'Install Dependencies', run: 'npm ci' },
        { name: 'Run Tests', run: 'npm test' },
        { name: 'Build', run: 'npm run build' }
      ]
    }
  ],
  environment: {
    NODE_ENV: 'production',
    CI: 'true'
  },
  notifications: {
    slack: true,
    email: ['team@example.com']
  }
};
```

## 📊 自动化监控和报告

### 性能监控自动化
```yaml
# .github/workflows/performance-monitoring.yml
name: 📊 Performance Monitoring

on:
  schedule:
    - cron: '0 */6 * * *'  # 每6小时运行一次
  workflow_dispatch:

jobs:
  performance-audit:
    name: 🔍 Performance Audit
    runs-on: ubuntu-latest
    
    steps:
      - name: 🌐 Lighthouse CI
        uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            https://example.com
            https://example.com/products
            https://example.com/about
          configPath: ./lighthouserc.json
          uploadArtifacts: true
          temporaryPublicStorage: true
          
      - name: 📊 Bundle Analyzer
        run: |
          npm run analyze
          
      - name: 🐌 Load Testing
        run: |
          npx artillery run artillery-config.yml
          
      - name: 📈 Generate Report
        uses: actions/upload-artifact@v3
        with:
          name: performance-report-${{ github.run_id }}
          path: |
            lighthouse-report.html
            bundle-report.html
            artillery-report.json
            
      - name: 📢 Report to Dashboard
        run: |
          curl -X POST "${{ secrets.DASHBOARD_WEBHOOK }}" \
          -H "Content-Type: application/json" \
          -d '{
            "type": "performance",
            "data": {
              "lighthouse_score": "${{ steps.lighthouse.outputs.score }}",
              "bundle_size": "${{ steps.bundle.outputs.size }}",
              "load_time": "${{ steps.artillery.outputs.response_time }}"
            }
          }'
```

### 依赖更新自动化
```yaml
# .github/workflows/dependency-updates.yml
name: 🔄 Dependency Updates

on:
  schedule:
    - cron: '0 9 * * 1'  # 每周一上午9点
  workflow_dispatch:

jobs:
  update-dependencies:
    name: 📦 Update Dependencies
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.BOT_TOKEN }}
          
      - name: 🔍 Check for Updates
        id: updates
        run: |
          npm outdated --json > outdated.json || true
          echo "has_updates=$(jq 'length > 0' outdated.json)" >> $GITHUB_OUTPUT
          
      - name: 🛡️ Security Audit
        run: npm audit --audit-level high
        
      - name: 📊 Generate Update Plan
        if: steps.updates.outputs.has_updates == 'true'
        run: |
          echo "## 依赖更新计划" > update-plan.md
          jq -r 'to_entries[] | "- **\(.key)**: \(.value.current) → \(.value.wanted) (latest: \(.value.latest))"' outdated.json >> update-plan.md
          
      - name: 🔄 Update Dependencies
        if: steps.updates.outputs.has_updates == 'true'
        run: |
          npm update
          npm test  # 确保更新后测试通过
          
      - name: 📝 Create PR
        if: steps.updates.outputs.has_updates == 'true'
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.BOT_TOKEN }}
          commit-message: 'chore: update dependencies'
          title: '🔄 Weekly Dependency Updates'
          body-path: update-plan.md
          branch: dependency-updates
          labels: dependencies, automation
          reviewers: team-leads
```

## 💡 工作流最佳实践

### 工作流优化策略
1. **并行执行** - 合理使用job依赖和并行执行
2. **缓存策略** - 有效使用缓存减少构建时间  
3. **条件执行** - 使用条件避免不必要的执行
4. **矩阵构建** - 多环境测试确保兼容性
5. **工件管理** - 合理管理构建产物

### 安全最佳实践
```yaml
# 安全配置示例
jobs:
  secure-job:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
      
    steps:
      - name: 🔐 Harden Runner
        uses: step-security/harden-runner@v2
        with:
          egress-policy: audit
          
      - name: 🛡️ Scan for Secrets
        uses: trufflesecurity/trufflehog@v3.21.0
        with:
          path: ./
          base: main
          
      - name: 🔍 SAST Scan  
        uses: github/codeql-action/analyze@v2
        with:
          languages: javascript
```

请开始工作流自动化配置。