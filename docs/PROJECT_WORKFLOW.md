# MiniClothes 项目工作流

## 概述
本文档定义了基于AI协作开发最佳实践的项目工作流程，确保高效、高质量的开发过程。

---

## 🎯 整体开发策略

### 基于Chris Dzombak方法论的实施

#### 1. 工作流程总览
```
计划阶段 → 理解阶段 → 测试优先 → 最小实现 → 重构优化 → 审查提交 → 部署监控
   ↑                                                                        ↓
   ←←←←←←←←←←←←← 持续反馈和改进 ←←←←←←←←←←←←←←←←←←←←←←
```

#### 2. 每周迭代模板
```markdown
## Week [N]: [功能名称]

### 🎯 本周目标
- 主要功能: [具体描述]
- 成功标准: [可衡量的指标]
- 验收条件: [具体的检查点]

### 📋 任务分解 (应用Chris的3-5阶段原则)
1. Stage 1: [基础准备阶段]
   - 成功标准: 
   - 测试要求: 
   - 预计时间: 
   
2. Stage 2: [核心实现阶段]
   - 成功标准: 
   - 测试要求: 
   - 预计时间: 
   
3. Stage 3: [集成测试阶段]
   - 成功标准: 
   - 测试要求: 
   - 预计时间: 

### 🚫 风险控制 (三次尝试原则准备)
- 可能遇到的问题: [列出2-3个最可能的问题]
- 备选方案: [每个问题的Plan B]
- 寻求帮助的时机: [明确什么时候停下来寻求帮助]
```

---

## 📅 日常开发流程

### 每日工作循环

#### 🌅 晨间准备 (15分钟)
```markdown
□ 查看昨日的工作结果和遗留问题
□ 确认今日的具体目标和优先级
□ 准备完整的上下文信息 (Context Engineering)
□ 检查开发环境和工具状态
```

#### ⏰ 开发会话 (每2小时为一个时间块)
```markdown
时间块结构:
- 90分钟: 专注开发
- 15分钟: 休息和反思
- 15分钟: 记录和规划下一步

每个时间块内的微循环:
1. 理解 (10分钟): 梳理要解决的具体问题
2. 测试 (15分钟): 编写测试用例
3. 实现 (45分钟): 编写最小可用代码  
4. 审查 (10分钟): 检查代码质量
5. 提交 (5分钟): Git提交并记录
6. 回顾 (5分钟): 评估进度和问题
```

#### 🌙 晚间总结 (10分钟)
```markdown
□ 记录今日完成的功能和学习
□ 标记遇到的问题和解决方案
□ 规划明日的工作重点
□ 更新项目进度和文档
```

---

## 🔄 Context Engineering 实践

### 每次AI交互前的准备清单

#### ✅ 项目上下文
```markdown
□ 当前开发阶段: Week [N] - [阶段名称]
□ 技术栈: iOS/Swift/SwiftUI/Core ML
□ 架构模式: MVVM + Combine
□ 设计风格: 小红书风格
□ 性能要求: [具体指标]
```

#### ✅ 具体任务上下文
```markdown
□ 当前任务: [具体要实现的功能]
□ 相关文件: [涉及的源代码文件]
□ 依赖关系: [与其他模块的关系]
□ 约束条件: [技术和业务限制]
□ 测试要求: [需要的测试覆盖]
```

#### ✅ 代码上下文
```swift
// 在请求AI帮助时，提供相关代码片段
// 例如:

// 当前的数据模型
struct ClothingItem {
    let id: UUID
    let category: ClothingCategory
    // ...
}

// 需要实现的接口
protocol ImageClassifier {
    func classify(_ image: UIImage) async -> ClassificationResult
}

// 现有的实现模式
extension WardrobeManager {
    func processNewImage(_ image: UIImage) {
        // 当前的处理流程
    }
}
```

### AI对话模板

#### 🎯 功能实现请求
```markdown
## 任务: [具体功能名称]

### 背景
- 项目: MiniClothes iOS应用 (Week [N])
- 架构: SwiftUI + MVVM + Core ML
- 风格: 小红书设计风格

### 当前状态
- 已完成: [相关的已有功能]
- 进行中: [当前任务的具体阶段]
- 目标: [要实现的具体功能]

### 技术约束
- iOS 15.0+
- 本地AI模型优先
- 性能要求: [具体指标]
- 内存限制: <200MB

### 相关代码
[提供相关的现有代码片段]

### 具体需求
[详细描述要实现的功能，包括:]
- 输入输出规格
- 错误处理要求
- 性能期望
- 测试需求

### 成功标准
[可衡量的验收条件]
```

#### 🐛 问题解决请求
```markdown
## 问题: [简短描述]

### 尝试历史 (三次尝试原则)
1. 第1次尝试: [方法] → [结果]
2. 第2次尝试: [方法] → [结果]
3. 第3次尝试: [方法] → [结果]

### 错误信息
[完整的错误日志]

### 环境信息
- Xcode版本:
- iOS模拟器版本:
- 依赖版本:

### 相关代码
[问题相关的代码片段]

### 期望结果
[期望的正确行为]
```

---

## 🧪 测试驱动开发 (TDD) 流程

### TDD循环实施细节

#### 🔴 Red Phase (编写失败测试)
```swift
// 1. 先写测试，明确期望行为
func testClothingClassification_TShirt_ShouldReturnTopsCategory() {
    // Given
    let classifier = ClothingClassifier()
    let tshirtImage = loadTestImage("tshirt.jpg")
    
    // When
    let result = classifier.classify(tshirtImage)
    
    // Then
    XCTAssertEqual(result.category, .tops)
    XCTAssertGreaterThan(result.confidence, 0.7)
    XCTAssertLessThan(result.processingTime, 3.0)
}

// 2. 运行测试，确认失败
// Expected: 编译错误或测试失败
```

#### 🟢 Green Phase (最小实现)
```swift
// 3. 写最少的代码让测试通过
struct ClassificationResult {
    let category: ClothingCategory
    let confidence: Double
    let processingTime: Double
}

class ClothingClassifier {
    func classify(_ image: UIImage) -> ClassificationResult {
        // 最简单的实现 - 先让测试通过
        return ClassificationResult(
            category: .tops,
            confidence: 0.8,
            processingTime: 1.0
        )
    }
}

// 4. 运行测试，确认通过
```

#### 🔵 Refactor Phase (重构优化)
```swift
// 5. 在测试保护下重构代码
class ClothingClassifier {
    private let model: MLModel
    
    init() {
        // 加载实际的Core ML模型
        self.model = try! MobileNetV3().model
    }
    
    func classify(_ image: UIImage) async -> ClassificationResult {
        let startTime = Date()
        
        // 实际的AI识别逻辑
        let result = await performMLClassification(image)
        
        let processingTime = Date().timeIntervalSince(startTime)
        
        return ClassificationResult(
            category: result.category,
            confidence: result.confidence,
            processingTime: processingTime
        )
    }
}

// 6. 再次运行测试，确保仍然通过
```

---

## 📝 代码审查检查表

### AI生成代码审查流程

#### Phase 1: 自动化检查 (2分钟)
```bash
# 编译检查
xcodebuild -scheme MiniClothes build

# 代码格式检查
swiftlint

# 单元测试
xcodebuild test -scheme MiniClothes
```

#### Phase 2: 手动审查 (5-10分钟)
```markdown
□ 功能正确性
  - 代码逻辑是否正确?
  - 边界条件是否处理?
  - 错误情况是否考虑?

□ 架构一致性  
  - 是否符合MVVM模式?
  - 是否遵循现有命名约定?
  - 依赖注入是否正确?

□ 性能考虑
  - 是否在主线程执行耗时操作?
  - 内存使用是否合理?
  - 异步操作是否正确?

□ 安全性
  - 用户输入是否验证?
  - 敏感数据是否保护?
  - 权限检查是否完整?

□ 测试覆盖
  - 是否有对应的单元测试?
  - 测试用例是否充分?
  - 集成测试是否需要?
```

#### Phase 3: 集成验证 (3-5分钟)
```markdown
□ 在模拟器中运行应用
□ 执行相关的用户流程
□ 检查性能和响应时间
□ 验证UI和用户体验
□ 确认与现有功能的兼容性
```

---

## 📊 进度跟踪和监控

### 每日进度记录

#### 📈 量化指标跟踪
```markdown
日期: [YYYY-MM-DD]
开发时间: [实际编码时间]
代码行数: +[新增] -[删除] ~[修改]
测试覆盖: [百分比]
性能指标: [响应时间/内存使用]
```

#### 🎯 功能完成度
```markdown
本周目标功能:
□ 功能A (进度: 80% - 基本完成，待测试)
□ 功能B (进度: 40% - 核心逻辑已实现)
□ 功能C (进度: 0% - 计划明天开始)

遇到的问题:
- 问题1: [描述] - [解决方案/状态]
- 问题2: [描述] - [解决方案/状态]
```

#### 💡 学习和改进
```markdown
今日学习:
- 技术知识: [新学到的技术概念]
- 最佳实践: [应用的开发技巧]
- 问题解决: [解决问题的方法]

明日改进:
- 开发效率: [可以优化的地方]
- 代码质量: [需要注意的点]
- 协作方式: [与AI协作的改进]
```

### 每周回顾会议

#### 🔍 回顾会议模板 (30分钟)
```markdown
## Week [N] 回顾会议

### 1. 目标达成情况 (5分钟)
- 计划功能: [列表]
- 实际完成: [列表] 
- 达成率: [百分比]
- 未完成原因分析: [具体分析]

### 2. 质量指标检查 (10分钟)
- 代码覆盖率: [当前/目标]
- 性能指标: [实际/预期]
- 用户体验: [测试反馈]
- 技术债务: [评估结果]

### 3. 过程改进 (10分钟)
- 工作得很好的地方:
  - AI协作效率: [评价]
  - 开发流程: [评价]
  - 工具使用: [评价]

- 需要改进的地方:
  - 开发瓶颈: [识别]
  - 流程问题: [分析]
  - 工具缺失: [需求]

### 4. 下周计划调整 (5分钟)
- 优先级调整: [变更说明]
- 资源分配: [时间安排]
- 风险预防: [应对措施]
```

---

## 🚀 版本发布流程

### Pre-release 检查清单

#### 🔧 技术准备 (30分钟)
```bash
# 1. 代码质量检查
swiftlint --strict
xcodebuild analyze -scheme MiniClothes

# 2. 全面测试
xcodebuild test -scheme MiniClothes -destination 'platform=iOS Simulator,name=iPhone 15'

# 3. 性能测试
instruments -t "Time Profiler" ...

# 4. 内存泄漏检查  
instruments -t "Leaks" ...
```

#### 📋 功能验证 (15分钟)
```markdown
□ 核心功能流程测试
  - 拍摄 → AI识别 → 保存衣橱
  - 衣橱浏览 → 详情查看 → 编辑
  - 虚拟试穿 → 背景替换 → 保存分享

□ 边界情况测试
  - 网络中断恢复
  - 低电量模式
  - 存储空间不足
  - 权限被拒绝

□ 设备兼容性测试
  - iPhone 12/13/14/15
  - iOS 15/16/17/18
  - 不同屏幕尺寸
```

#### 📚 文档更新
```markdown
□ CHANGELOG.md更新
□ 版本号更新 (Info.plist)
□ README.md状态更新
□ API文档同步
□ 用户手册更新 (如有)
```

### Post-release 监控 (48小时)

#### 📊 关键指标监控
```markdown
监控指标:
- 应用启动成功率: >99%
- 核心功能完成率: >90%  
- 平均响应时间: <3秒
- 内存使用峰值: <200MB
- 崩溃率: <0.1%

用户反馈:
- 应用商店评分: [目标4.0+]
- 用户投诉类型: [分类统计]
- 功能使用统计: [热点功能分析]
```

#### 🚨 问题响应流程
```markdown
发现问题时:
1. 评估严重程度 (Critical/High/Medium/Low)
2. Critical问题: 2小时内响应
3. High问题: 1天内响应
4. Medium问题: 3天内响应
5. Low问题: 下版本修复

问题处理:
1. 记录问题详情和影响范围
2. 制定修复计划和时间表
3. 实施修复并测试验证
4. 发布热修复版本 (如需要)
5. 总结问题原因和预防措施
```

---

## 🎓 持续学习和改进

### 知识积累体系

#### 📚 技术学习计划
```markdown
每周技术学习 (2小时):
- iOS新技术: SwiftUI新特性, Core ML更新
- AI/ML知识: 计算机视觉, 深度学习基础
- 开发工具: Xcode技巧, 调试方法
- 最佳实践: 架构模式, 性能优化

每月深度学习 (8小时):
- 专题研究: 选择一个技术领域深入学习
- 源码阅读: 分析优秀开源项目
- 技术分享: 内部或外部技术分享
- 实验项目: 验证新技术的可行性
```

#### 🔄 经验总结机制
```markdown
每个功能完成后:
□ 记录技术难点和解决方案
□ 总结可复用的代码模式
□ 评估开发效率和质量
□ 更新最佳实践文档

每个版本发布后:
□ 用户反馈分析和改进建议
□ 性能数据分析和优化方向
□ 开发流程评估和调整
□ 团队协作效果评价
```

### 工具和环境持续优化

#### 🛠️ 开发工具链
```markdown
定期评估和升级:
- IDE和插件: Xcode, VS Code扩展
- 调试工具: Instruments, 第三方工具
- 自动化工具: 脚本, CI/CD配置
- AI协作工具: Claude Code, 其他AI工具

每月工具评估:
□ 现有工具使用效率评估
□ 新工具调研和试用
□ 工具配置优化和定制
□ 工具使用技巧分享
```

---

## 📞 寻求帮助的时机和方式

### 何时停下来寻求帮助

#### 🚫 三次尝试原则的具体应用
```markdown
技术问题:
- 尝试1: 查阅官方文档和错误信息
- 尝试2: 搜索Stack Overflow和GitHub Issues
- 尝试3: 简化问题或尝试替代方案
- 第3次后: 记录问题详情，寻求帮助

设计决策:
- 尝试1: 参考现有模式和最佳实践
- 尝试2: 分析用户需求和技术约束
- 尝试3: 创建原型验证不同方案
- 第3次后: 与产品团队讨论决策

性能问题:
- 尝试1: 使用Instruments分析瓶颈
- 尝试2: 优化算法和数据结构
- 尝试3: 调整架构或缓存策略
- 第3次后: 重新评估需求和技术选择
```

#### 📝 寻求帮助的信息准备
```markdown
准备以下信息:
1. 问题的详细描述和背景
2. 已尝试的解决方案和结果
3. 完整的错误信息和日志
4. 相关的代码片段和配置
5. 期望的结果和约束条件
6. 问题的紧急程度和影响范围
```

---

*工作流程版本: 1.0*  
*基于: Chris Dzombak, Simon Willison, Anthropic 最佳实践*  
*最后更新: 2025-08-29*  
*维护者: 项目团队*