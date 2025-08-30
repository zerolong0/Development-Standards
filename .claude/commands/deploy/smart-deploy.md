# 智能部署工具

智能化部署和发布管理，支持多环境、零停机、回滚策略。

## 使用方式

请执行智能部署: $ARGUMENTS

## 🎯 部署策略支持

### 部署模式
1. **蓝绿部署** - 零停机切换，快速回滚
2. **滚动更新** - 渐进式部署，降低风险
3. **金丝雀发布** - 小流量验证，逐步放量
4. **A/B测试部署** - 并行版本，数据对比

### 环境管理
- **开发环境** (dev): 功能开发和单元测试
- **测试环境** (test): 集成测试和QA验证
- **预生产环境** (staging): 生产前最后验证
- **生产环境** (prod): 线上正式环境

## 🚀 部署配置模板

### Docker容器化部署
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  app:
    image: ${APP_IMAGE}:${VERSION}
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 30s
        failure_action: rollback
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
      
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
      
  redis:
    image: redis:alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
      
volumes:
  redis_data:
```

### Kubernetes部署配置
```yaml
# k8s-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
  labels:
    app: myapp
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:${VERSION}
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
            
---
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: LoadBalancer
```

## 🔧 CI/CD Pipeline配置

### GitHub Actions工作流
```yaml
# .github/workflows/deploy.yml
name: Deploy Application

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  DOCKER_REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm test -- --coverage
        
      - name: Run ESLint
        run: npm run lint
        
      - name: Type check
        run: npm run type-check
        
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4
      
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.DOCKER_REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha,prefix={{branch}}-
            
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment: staging
    steps:
      - name: Deploy to staging
        run: |
          echo "Deploying to staging environment"
          # 这里添加具体的部署命令
          
  deploy-production:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying to production environment"
          # 蓝绿部署或滚动更新
```

### GitLab CI/CD配置
```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy-staging
  - deploy-production

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

test:
  stage: test
  image: node:20-alpine
  cache:
    paths:
      - node_modules/
  before_script:
    - npm ci
  script:
    - npm test
    - npm run lint
    - npm run build
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

build:
  stage: build
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  only:
    - main
    - develop

deploy-staging:
  stage: deploy-staging
  image: alpine:latest
  before_script:
    - apk add --no-cache curl
  script:
    - |
      curl -X POST \
        -H "Content-Type: application/json" \
        -d "{\"image\":\"$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA\"}" \
        "$STAGING_DEPLOY_WEBHOOK"
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop

deploy-production:
  stage: deploy-production
  image: alpine:latest
  before_script:
    - apk add --no-cache curl
  script:
    - |
      # 蓝绿部署脚本
      curl -X POST \
        -H "Content-Type: application/json" \
        -d "{\"image\":\"$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA\",\"strategy\":\"blue-green\"}" \
        "$PRODUCTION_DEPLOY_WEBHOOK"
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main
```

## 📊 部署监控和验证

### 健康检查配置
```typescript
// 应用健康检查端点
import { Request, Response } from 'express';

interface HealthCheckResult {
  status: 'healthy' | 'unhealthy';
  timestamp: string;
  version: string;
  uptime: number;
  checks: {
    database: 'pass' | 'fail';
    redis: 'pass' | 'fail';
    externalAPI: 'pass' | 'fail';
  };
}

export class HealthChecker {
  async checkHealth(): Promise<HealthCheckResult> {
    const checks = {
      database: await this.checkDatabase(),
      redis: await this.checkRedis(),
      externalAPI: await this.checkExternalAPI()
    };
    
    const isHealthy = Object.values(checks).every(check => check === 'pass');
    
    return {
      status: isHealthy ? 'healthy' : 'unhealthy',
      timestamp: new Date().toISOString(),
      version: process.env.APP_VERSION || '1.0.0',
      uptime: process.uptime(),
      checks
    };
  }
  
  private async checkDatabase(): Promise<'pass' | 'fail'> {
    try {
      await this.db.query('SELECT 1');
      return 'pass';
    } catch (error) {
      logger.error('Database health check failed:', error);
      return 'fail';
    }
  }
  
  private async checkRedis(): Promise<'pass' | 'fail'> {
    try {
      await this.redis.ping();
      return 'pass';
    } catch (error) {
      logger.error('Redis health check failed:', error);
      return 'fail';
    }
  }
}

// Express路由
app.get('/health', async (req: Request, res: Response) => {
  const healthChecker = new HealthChecker();
  const result = await healthChecker.checkHealth();
  
  const statusCode = result.status === 'healthy' ? 200 : 503;
  res.status(statusCode).json(result);
});

app.get('/ready', async (req: Request, res: Response) => {
  // 就绪检查 - 检查应用是否准备好接收流量
  const isReady = await checkApplicationReadiness();
  res.status(isReady ? 200 : 503).json({ ready: isReady });
});
```

### 部署验证脚本
```bash
#!/bin/bash
# deploy-verify.sh - 部署后验证脚本

set -e

APP_URL=${1:-"https://your-app.com"}
TIMEOUT=${2:-30}
RETRY_COUNT=${3:-5}

echo "🚀 开始部署验证: $APP_URL"

# 等待应用启动
echo "⏳ 等待应用启动..."
for i in $(seq 1 $RETRY_COUNT); do
  if curl -f -s "$APP_URL/health" > /dev/null; then
    echo "✅ 健康检查通过"
    break
  fi
  
  if [ $i -eq $RETRY_COUNT ]; then
    echo "❌ 健康检查失败，应用未正常启动"
    exit 1
  fi
  
  echo "⏳ 重试中... ($i/$RETRY_COUNT)"
  sleep 10
done

# 功能验证
echo "🧪 执行功能验证..."

# API接口测试
echo "测试主要API接口..."
response=$(curl -s -w "HTTP_CODE:%{http_code}" "$APP_URL/api/users" || true)
http_code=$(echo "$response" | grep -o "HTTP_CODE:[0-9]*" | cut -d: -f2)

if [ "$http_code" != "200" ]; then
  echo "❌ API接口测试失败: HTTP $http_code"
  exit 1
fi

# 数据库连接测试
echo "测试数据库连接..."
db_status=$(curl -s "$APP_URL/health" | jq -r '.checks.database')
if [ "$db_status" != "pass" ]; then
  echo "❌ 数据库连接测试失败"
  exit 1
fi

# 缓存服务测试
echo "测试缓存服务..."
cache_status=$(curl -s "$APP_URL/health" | jq -r '.checks.redis')
if [ "$cache_status" != "pass" ]; then
  echo "❌ 缓存服务测试失败"
  exit 1
fi

# 性能基准测试
echo "📈 执行性能基准测试..."
avg_response_time=$(curl -w "@curl-format.txt" -s -o /dev/null "$APP_URL" | grep "time_total")
echo "平均响应时间: $avg_response_time 秒"

echo "✅ 部署验证完成，应用运行正常"
```

## 🔄 回滚和恢复策略

### 自动回滚配置
```yaml
# 自动回滚Webhook配置
apiVersion: v1
kind: ConfigMap
metadata:
  name: rollback-config
data:
  rollback-policy.yml: |
    triggers:
      - type: health_check_failure
        threshold: 3
        window: 5m
      - type: error_rate_spike  
        threshold: 0.05
        window: 2m
      - type: response_time_spike
        threshold: 2000ms
        window: 5m
    
    rollback_strategy: "immediate"
    notification_channels:
      - slack
      - email
      - pagerduty
```

### 回滚脚本
```bash
#!/bin/bash
# rollback.sh - 应用回滚脚本

ENVIRONMENT=${1:-staging}
PREVIOUS_VERSION=${2}

echo "🔄 开始回滚到环境: $ENVIRONMENT"

if [ -z "$PREVIOUS_VERSION" ]; then
  # 获取上一个版本
  PREVIOUS_VERSION=$(get_previous_version.sh $ENVIRONMENT)
  echo "📋 自动检测到上一版本: $PREVIOUS_VERSION"
fi

# 执行回滚
case $ENVIRONMENT in
  "production")
    echo "🚨 生产环境回滚需要确认"
    read -p "确定要回滚到版本 $PREVIOUS_VERSION 吗? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
      echo "❌ 回滚已取消"
      exit 1
    fi
    ;;
  "staging")
    echo "📝 暂存环境回滚，无需确认"
    ;;
esac

# 蓝绿切换回滚
echo "🔄 执行蓝绿切换回滚..."
kubectl set image deployment/app app=myapp:$PREVIOUS_VERSION

# 等待回滚完成
kubectl rollout status deployment/app

# 验证回滚结果
echo "✅ 回滚完成，执行验证..."
./deploy-verify.sh

# 发送通知
send_notification.sh "rollback" "$ENVIRONMENT" "$PREVIOUS_VERSION"

echo "✅ 回滚操作完成"
```

## 💡 部署最佳实践

### 部署安全检查清单
- ✅ 敏感信息使用环境变量或密钥管理
- ✅ 容器镜像安全扫描通过
- ✅ 网络安全策略配置正确
- ✅ 资源限制和配额设置合理
- ✅ 监控和日志收集配置完整
- ✅ 备份和恢复策略已验证

### 生产环境部署注意事项
1. **流量切换策略** - 使用负载均衡器平滑切换
2. **数据库迁移** - 向后兼容的数据库变更
3. **缓存预热** - 部署后主动预热缓存
4. **监控告警** - 部署期间加强监控
5. **回滚准备** - 确保快速回滚能力

### 多环境管理
```typescript
// 环境配置管理
interface EnvironmentConfig {
  name: string;
  domain: string;
  database: DatabaseConfig;
  redis: RedisConfig;
  monitoring: MonitoringConfig;
  resources: ResourceConfig;
}

const environments: Record<string, EnvironmentConfig> = {
  development: {
    name: 'dev',
    domain: 'dev.example.com',
    database: { host: 'dev-db', replicas: 1 },
    redis: { host: 'dev-redis', cluster: false },
    monitoring: { level: 'basic' },
    resources: { cpu: '250m', memory: '256Mi' }
  },
  
  staging: {
    name: 'staging', 
    domain: 'staging.example.com',
    database: { host: 'staging-db', replicas: 2 },
    redis: { host: 'staging-redis', cluster: true },
    monitoring: { level: 'detailed' },
    resources: { cpu: '500m', memory: '512Mi' }
  },
  
  production: {
    name: 'prod',
    domain: 'example.com',
    database: { host: 'prod-db', replicas: 3 },
    redis: { host: 'prod-redis', cluster: true },
    monitoring: { level: 'comprehensive' },
    resources: { cpu: '1000m', memory: '1Gi' }
  }
};
```

请开始智能部署流程。