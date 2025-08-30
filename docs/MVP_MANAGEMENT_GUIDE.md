# MVP管理和自动备份完整指南

## 🎯 概述

MVP（Minimum Viable Product）管理是AI开发规范的核心组件之一，确保每个最小功能迭代都有完整的版本记录，避免功能迭代无记录的问题。

---

## 🚀 快速开始

### 一键使用MVP工具

所有集成了AI开发规范的项目都自动包含MVP管理工具：

```bash
# 检查MVP状态
./mvp-tools.sh check

# 完成功能后立即备份
./mvp-tools.sh backup "完成用户登录功能"

# 查看当前MVP状态
./mvp-tools.sh status
```

### 核心命令

| 命令 | 缩写 | 功能 | 示例 |
|------|------|------|------|
| `backup` | `b` | 执行MVP备份 | `./mvp-tools.sh b "新功能完成"` |
| `check` | `c` | 检查MVP状态 | `./mvp-tools.sh c` |
| `status` | `s` | 显示MVP状态 | `./mvp-tools.sh s` |

---

## 📋 MVP备份功能详解

### 自动备份脚本

```bash
# 基础用法
./scripts/mvp-backup.sh "功能描述"

# 高级用法
./scripts/mvp-backup.sh -v "v1.2.0" -t "feature" --tag "完成AI对话功能"

# 仅备份不推送
./scripts/mvp-backup.sh --no-push "临时功能保存"

# 仅创建本地备份
./scripts/mvp-backup.sh --backup-only "开发中功能"
```

### 参数详解

| 参数 | 说明 | 示例 |
|------|------|------|
| `-v, --version` | 指定版本号 | `-v "v1.2.0"` |
| `-t, --type` | MVP类型 | `-t "feature"` |
| `-n, --no-push` | 不推送到远程 | `--no-push` |
| `-b, --backup-only` | 仅创建备份 | `--backup-only` |
| `-r, --remote` | 指定远程仓库 | `-r origin` |
| `--tag` | 创建Git标签 | `--tag` |

### MVP类型说明

- **feature**: 新功能开发（默认）
- **bugfix**: Bug修复
- **enhancement**: 功能增强

---

## 📊 自动生成的内容

### MVP里程碑文档

每次备份会自动生成详细的里程碑记录：

```
docs/mvp-milestones/MVP-v1.2.0-20250830.md
```

**包含内容：**
- 📋 基本信息（版本、时间、开发者）
- 🎯 MVP功能描述
- 📊 项目状态快照（代码统计、目录结构）
- 🔄 主要变更（自动从Git提取）
- 🧪 测试状态模板
- 📈 性能指标模板
- 🐛 已知问题记录
- 📝 下一步计划

### 项目状态文件

根目录的`MVP_STATUS.md`实时更新：

```markdown
# 项目MVP状态

## 🎯 当前版本
- **最新版本**: v1.2.0
- **更新时间**: 2025-08-30 14:30:00
- **功能描述**: 完成AI对话核心功能

## 📈 版本历史
- MVP-v1.2.0-20250830.md
- MVP-v1.1.0-20250825.md
- MVP-v1.0.0-20250820.md
```

---

## 🤖 GitHub自动化集成

### 自动触发场景

1. **手动触发**: GitHub Actions界面手动执行
2. **定期检查**: 每天晚上10点自动检查MVP状态
3. **代码推送**: 主分支有代码提交时智能评估

### GitHub Actions工作流

#### MVP自动备份工作流

```yaml
# .github/workflows/mvp-backup.yml
name: MVP自动备份和版本管理

on:
  workflow_dispatch:
    inputs:
      mvp_description:
        description: 'MVP功能描述'
        required: true
  schedule:
    - cron: '0 22 * * *'  # 每天22:00
  push:
    branches: [ main, master, develop ]
```

**功能特色:**
- 🤖 自动检测是否需要备份
- 📊 生成备份推荐度评分
- 🏷️ 自动创建Git标签
- 🔄 自动推送到GitHub
- 📋 创建Pull Request（非主分支）

#### 项目健康度检查

```yaml
# .github/workflows/project-health.yml  
name: 项目健康度检查

on:
  schedule:
    - cron: '0 9 * * 1'  # 每周一09:00
  pull_request:
    branches: [ main, master, develop ]
```

**检查项目:**
- ✅ AI开发规范集成状态
- 📊 MVP管理状态
- 💻 代码质量指标
- 🤖 Agent项目专用检查
- 🏥 自动生成健康度评分

---

## 📈 MVP状态检查

### 自动状态评估

```bash
./scripts/mvp-check.sh
```

**检查维度:**
- 📅 最后备份时间
- 📝 未提交更改数量
- 🚀 待推送提交数量
- 🆕 新功能提交数量
- 🐛 Bug修复提交数量

### 备份推荐评分

系统根据以下规则计算备份推荐度（0-100分）：

| 条件 | 加分 | 说明 |
|------|------|------|
| 有新功能提交 | +30 | feat:类型的提交 |
| Bug修复较多 | +20 | fix:类型提交>2个 |
| 最近提交活跃 | +25 | 3天内提交>5个 |
| 距上次备份较久 | +25 | 距上次备份>7天 |

**评分说明:**
- **70-100分**: 🚨 强烈建议立即备份
- **50-69分**: ⚠️  建议考虑备份
- **30-49分**: ✅ 当前进度适中
- **0-29分**: ✅ 项目状态良好

---

## 🎯 Agent项目专用功能

### Agent MVP特殊记录

Agent项目的MVP备份包含专用指标：

```markdown
### Agent项目专用指标
- **意图识别准确率**: ___%
- **任务完成率**: ___%
- **用户满意度**: ___分
- **平均对话轮次**: ___轮
```

### Agent专用检查

- 🤖 Agent PRD文档完整性
- 📋 Agent开发检查清单进度
- 🔄 Agent相关提交统计
- 💬 对话流程测试状态

---

## 🔄 典型工作流程

### 日常开发流程

```bash
# 1. 开始开发前检查状态
./mvp-tools.sh check

# 2. 进行功能开发
# ... 编码工作 ...

# 3. 完成一个MVP功能后
git add .
git commit -m "feat: 完成用户认证功能"

# 4. 立即备份MVP
./mvp-tools.sh backup "完成用户认证功能"

# 5. 查看备份状态
./mvp-tools.sh status
```

### 团队协作流程

```bash
# 团队成员A完成功能
./mvp-tools.sh backup --tag "完成核心功能v1.0"

# 自动推送到GitHub，触发Actions检查

# 团队成员B查看最新状态
git pull
./mvp-tools.sh status

# 查看详细的MVP历史
ls docs/mvp-milestones/
```

### 版本发布流程

```bash
# 1. 检查当前MVP状态
./mvp-tools.sh check

# 2. 如果需要，完成最终备份
./mvp-tools.sh backup -v "v2.0.0" --tag "正式版本发布"

# 3. GitHub Actions自动执行
# - 创建Git标签
# - 推送到远程仓库  
# - 生成发布记录
# - 更新项目文档

# 4. 团队通知和部署
```

---

## ⚙️ 高级配置

### 自定义备份策略

编辑项目的`CLAUDE.md`文件添加MVP配置：

```markdown
## 🔄 MVP管理配置

### 备份策略
- **自动备份间隔**: 每周
- **重要功能标签**: 立即创建
- **版本号规则**: 语义化版本
- **推送策略**: 自动推送主分支

### 团队约定
- 每完成一个用户故事进行备份
- 重要Bug修复必须备份
- 版本发布前完整备份
```

### GitHub Actions配置

修改`.github/workflows/mvp-backup.yml`：

```yaml
# 自定义触发条件
on:
  push:
    paths:
      - 'src/**'        # 只关注源码变更
      - 'docs/**'       # 和文档变更
  schedule:
    - cron: '0 18 * * 5'  # 改为每周五18:00
```

### 通知集成

添加Slack或企业微信通知：

```yaml
- name: 发送通知
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: "MVP备份完成: ${{ github.repository }}"
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 🛠️ 故障排除

### 常见问题

#### 1. 备份脚本权限错误

```bash
# 解决方法
chmod +x scripts/mvp-backup.sh
chmod +x scripts/mvp-check.sh
chmod +x mvp-tools.sh
```

#### 2. Git远程仓库未配置

```bash
# 检查远程仓库
git remote -v

# 添加远程仓库
git remote add origin https://github.com/username/repo.git
```

#### 3. GitHub Actions权限问题

在GitHub仓库设置中确保Actions有写权限：
- Settings → Actions → General
- Workflow permissions → Read and write permissions

#### 4. MVP目录不存在

```bash
# 手动创建MVP目录
mkdir -p docs/mvp-milestones

# 重新初始化项目
./scripts/init-project.sh $(pwd)
```

### 调试模式

```bash
# 开启调试模式运行脚本
bash -x ./scripts/mvp-backup.sh "调试备份"

# 查看详细输出
./mvp-tools.sh check 2>&1 | tee debug.log
```

---

## 📚 最佳实践

### MVP备份时机

**推荐备份时机:**
1. ✅ 完成一个用户故事
2. ✅ 修复重要Bug
3. ✅ 完成重构或优化
4. ✅ 版本发布前
5. ✅ 周末工作结束时

**不推荐备份时机:**
1. ❌ 每次小的代码修改
2. ❌ 调试过程中
3. ❌ 实验性功能开发中

### 团队协作规范

1. **统一备份频率**: 建议每个用户故事完成后备份
2. **规范提交信息**: 使用标准格式便于自动分析
3. **及时推送远程**: 确保团队同步最新状态
4. **定期检查状态**: 使用`mvp-check`命令监控项目健康度

### Agent项目特殊建议

1. **对话测试记录**: 每次备份包含对话测试结果
2. **用户反馈收集**: 记录用户对Agent回答的满意度
3. **知识库更新**: 备份时记录知识库变更
4. **性能指标跟踪**: 监控响应时间和准确率变化

---

## 🔗 相关资源

### 核心文档
- [AI开发规范完整指南](./AI_AGENT_DEVELOPMENT_GUIDE.md)
- [自动集成使用指南](./AUTO_INTEGRATION_GUIDE.md)
- [开发最佳实践](./DEVELOPMENT_BEST_PRACTICES.md)

### 模板文件
- [MVP里程碑模板](../templates/MVP_MILESTONE_TEMPLATE.md)
- [Agent PRD模板](../templates/AGENT_PRD_TEMPLATE.md)
- [项目配置模板](../templates/CLAUDE_PROJECT_TEMPLATE.md)

### 工具脚本
- [MVP备份脚本](../scripts/mvp-backup.sh)
- [MVP检查脚本](../scripts/mvp-check.sh)
- [项目初始化脚本](../scripts/init-project.sh)

---

**通过MVP管理，确保每个功能迭代都有完整记录，让开发历程清晰可追溯！** 🚀

*最后更新: 2025-08-30*  
*维护者: AI开发团队*