# Claude AI协作配置文件模板

## 🎯 项目信息
- **项目名称**: [项目名称]
- **项目类型**: [agent/web/mobile/general]
- **项目描述**: [项目简要描述]
- **技术栈**: [主要技术栈]
- **开发者**: [开发者姓名]
- **创建时间**: [YYYY-MM-DD]

## 📋 开发规范
本项目遵循AI开发标准，相关规范文档位于 `docs/standards/` 目录。

### 核心规范文件
- [开发最佳实践](./docs/standards/DEVELOPMENT_BEST_PRACTICES.md)
- [项目工作流程](./docs/standards/PROJECT_WORKFLOW.md)  
- [技术决策模板](./docs/standards/TECHNICAL_DECISIONS_TEMPLATE.md)
- [上下文工程指南](./docs/standards/CONTEXT_ENGINEERING_GUIDE.md)
<!-- Agent项目专用 -->
- [AI Agent开发指南](./docs/standards/AI_AGENT_DEVELOPMENT_GUIDE.md)
- [Agent PRD模板](./docs/templates/AGENT_PRD_TEMPLATE.md)

## 🤖 Claude协作指南

### 上下文信息
当与Claude协作时，请提供以下上下文：

1. **项目背景**: [项目背景描述]
2. **技术栈**: [具体技术栈]
3. **当前任务**: [请在每次对话时明确当前要解决的具体问题]
4. **相关文件**: [请指出相关的代码文件或文档]

### 工作流程
1. **问题描述**: 清晰描述要解决的问题
2. **现状分析**: 提供相关的代码片段或错误信息
3. **期望结果**: 明确期望达到的目标
4. **约束条件**: 说明技术限制或业务要求

### 代码规范要求
- 遵循项目现有的代码风格
- 添加必要的注释和文档
- 确保代码的可测试性
- 考虑错误处理和边界情况
<!-- Agent项目专用要求 -->
- 遵循Agent产品开发方法论
- 明确Agent能力边界和交互设计

## 📊 项目检查清单

### 开发准备
- [ ] 阅读开发规范文档
- [ ] 配置开发环境
- [ ] 设置Git hooks
- [ ] 配置IDE设置

### Agent项目专用检查清单
- [ ] 完成Agent身份设计
- [ ] 定义能力边界和转接条件
- [ ] 设计对话交互流程
- [ ] 建立知识体系架构
- [ ] 实现工具调用能力
- [ ] 设置测试验证框架
- [ ] 建立成功指标体系

### 质量保证
- [ ] 代码审查完成
- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] 文档更新完整

## 🔗 相关资源
- [AI开发规范Wiki](http://localhost:1024) - 本地知识库
- [技术决策记录](./docs/decisions/) - 项目技术决策历史
- [开发模板](./docs/templates/) - 常用开发模板

## 🎯 项目专用配置

### [根据项目类型添加专用配置]

#### Web项目配置
```json
{
  "framework": "具体框架",
  "buildTool": "构建工具",
  "packageManager": "包管理器"
}
```

#### Agent项目配置  
```json
{
  "agentType": "Agent类型",
  "domain": "应用领域", 
  "capabilities": ["能力列表"],
  "integrations": ["集成服务"]
}
```

#### 移动应用配置
```json
{
  "platform": "平台类型",
  "targetOS": "目标系统版本",
  "buildTools": ["构建工具列表"]
}
```

---
*此文件由AI开发规范自动生成，请根据项目实际情况调整*
*最后更新: [自动生成时间]*