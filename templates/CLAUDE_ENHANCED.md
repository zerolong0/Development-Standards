# 项目配置 - Claude Code增强版

## 🎯 项目核心信息
**项目名称**: [填入项目名称]
**技术架构**: [如：Next.js 14 + TypeScript + PostgreSQL + Redis]
**业务领域**: [如：金融科技 / 电商平台 / AI工具]
**开发阶段**: [如：MVP / 成长期 / 成熟期]

## 📐 系统架构图
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │    │   Backend   │    │  Database   │
│  [技术栈]   │◄──►│   [技术栈]   │◄──►│ [数据库类型] │
│             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 🔧 开发环境配置
- **Node版本**: [如：18.x]
- **包管理器**: [如：pnpm / npm / yarn]
- **代码规范**: ESLint + Prettier + Husky
- **测试框架**: [如：Jest + React Testing Library + Cypress]
- **部署平台**: [如：Vercel / AWS / Docker + K8s]
- **CI/CD**: [如：GitHub Actions / GitLab CI]

## 📋 关键API接口
### 认证相关
- POST /api/auth/login - 用户登录
- POST /api/auth/register - 用户注册  
- POST /api/auth/refresh - Token刷新
- DELETE /api/auth/logout - 用户登出

### [其他业务模块]
- GET /api/[module]/list - 列表查询
- POST /api/[module]/create - 创建资源
- PUT /api/[module]/{id} - 更新资源
- DELETE /api/[module]/{id} - 删除资源

## 🎨 UI/UX设计规范
- **设计系统**: [如：shadcn/ui + Tailwind CSS / Ant Design]
- **颜色主题**: [如：Ocean Depth Palette / 自定义品牌色]
- **交互标准**: Smooth micro-interactions + Hover states
- **响应式**: Mobile-first + Desktop enhanced
- **组件库**: [如：React + TypeScript + Storybook]

## 🧪 测试策略  
- **单元测试**: 最低80%覆盖率，重点测试业务逻辑
- **集成测试**: API端点全覆盖，数据库交互验证
- **E2E测试**: 关键用户流程自动化测试
- **性能测试**: Core Web Vitals + API响应时间
- **安全测试**: OWASP Top 10 + 自动漏洞扫描

## 🔐 安全要求
- **认证方式**: [如：JWT + Refresh Token / OAuth 2.0]
- **授权模型**: [如：RBAC角色权限 / ABAC属性权限]
- **数据加密**: AES-256 + HTTPS + 敏感字段加密
- **安全标准**: [如：SOC2 / GDPR / 等保二级]
- **漏洞扫描**: 每次PR自动检查，定期渗透测试

## 📊 性能指标
- **首屏加载**: < 2秒 (LCP)
- **交互响应**: < 100ms (FID)  
- **布局稳定**: < 0.1 (CLS)
- **API响应**: < 500ms (95th percentile)
- **内存使用**: < 512MB (服务端)
- **Bundle大小**: < 500KB (前端初始包)

## 🔄 多Agent协作配置
### Agent角色分工
- **分析Agent**: 需求理解、技术方案设计、风险评估
- **开发Agent**: 代码编写、功能实现、单元测试
- **质量Agent**: 代码审查、安全扫描、性能优化

### 协作模式
```yaml
collaboration:
  orchestrator: claude-4-sonnet
  max_concurrent_agents: 10
  task_distribution: automatic
  quality_gates: [security_scan, test_coverage, performance_check]
```

## 🚨 项目特殊要求
### [业务相关]
- **合规要求**: [如：金融牌照、医疗HIPAA、教育FERPA]
- **数据处理**: [如：GDPR用户数据删除、数据出境审批]
- **服务等级**: [如：99.9%可用性、RTO<1小时、RPO<15分钟]

### [技术相关]  
- **监控告警**: [如：Prometheus + Grafana + PagerDuty]
- **日志系统**: [如：ELK Stack / Datadog / 自建方案]
- **备份策略**: [如：每日自动备份、跨区域容灾]

## 🐛 已知问题和TODO
### 🔥 高优先级
- [ ] [具体技术债务或问题描述]
- [ ] [性能瓶颈优化项]
- [ ] [安全加固措施]

### 📋 中优先级  
- [ ] [功能完善项目]
- [ ] [用户体验优化]
- [ ] [代码重构计划]

### 💡 未来规划
- [ ] [新功能开发计划] 
- [ ] [技术栈升级计划]
- [ ] [架构演进方向]

## 📚 相关资源链接
- **项目文档**: [Confluence/Notion链接]
- **设计稿**: [Figma/Sketch链接]
- **API文档**: [Swagger/Postman链接]  
- **部署环境**: [生产/预发/测试环境地址]
- **监控面板**: [Grafana/DataDog链接]

## 🎯 开发工作流
### 代码提交规范
```
feat: 新功能
fix: Bug修复  
docs: 文档更新
style: 代码格式调整
refactor: 重构代码
test: 测试相关
chore: 构建工具、辅助工具变动
agent: Agent相关功能和优化
```

### 分支管理策略
- **main**: 生产环境代码
- **develop**: 开发主分支
- **feature/****: 功能开发分支
- **hotfix/****: 紧急修复分支

### Claude Code最佳实践
- 使用 `/multi-agent` 进行复杂功能开发
- 每次PR前运行 `/security-review` 
- UI开发使用 `/ui-design` 生成专业组件
- 定期执行 `/performance-audit` 优化性能

---

**📌 备注**：
1. 请根据实际项目情况填充具体信息
2. 定期更新此文档以反映项目最新状态
3. 确保团队成员了解并遵循上述规范
4. 有问题及时在团队群组讨论和更新

*最后更新: [更新日期]*
*更新人: [更新人员]*