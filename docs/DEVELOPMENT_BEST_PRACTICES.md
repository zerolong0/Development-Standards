# MiniClothes 开发最佳实践

## 概述
本文档整合了Chris Dzombak、Simon Willison和Anthropic等专家的AI协作开发经验，制定了适合MiniClothes项目的开发最佳实践。

---

## 🎯 核心原则

### 1. Context Engineering Over Prompt Engineering
> 来源: Simon Willison

**核心理念**: 上下文管理是与AI协作的核心技能，而非简单的"提示词工程"。

**实践方法**:
```markdown
✅ 好的上下文:
- 提供完整的项目背景和技术栈
- 明确当前开发阶段和目标
- 包含相关的代码示例和模式
- 说明具体的约束条件

❌ 差的上下文:
- "帮我写个相机功能"
- 缺乏背景信息的孤立请求
- 模糊的需求描述
```

### 2. 增量进步 > 大爆发
> 来源: Chris Dzombak

**核心理念**: 小步快跑，确保每次变更都能编译通过。

**实践方法**:
```
每次提交都应该:
1. 代码能够编译
2. 测试能够通过
3. 功能增量可用
4. 有清晰的提交信息
```

### 3. AI是初级开发者的增强版
> 来源: Anthropic

**核心理念**: AI像"打了兴奋剂的初级开发者"，需要保持监督和指导。

---

## 🛠️ 开发工作流

### Phase 1: 理解 (Understand)
```markdown
在开始编码前:
1. 研究现有代码模式和架构
2. 理解相关的技术约束
3. 确认与现有系统的集成点
4. 明确成功标准

示例:
"在开始实现AI识别功能前，我需要理解:
- 当前的图片处理流程
- Core ML模型的集成方式  
- 识别结果的数据模型
- 错误处理和用户反馈机制"
```

### Phase 2: 测试优先 (Test First)
```markdown
TDD流程:
1. 🔴 Red: 编写失败的测试
2. 🟢 Green: 写最少代码让测试通过  
3. 🔵 Refactor: 重构代码保持测试通过
4. 📝 Commit: 提交并记录

示例测试:
func testClothingClassification() {
    // Given: 一张T恤图片
    let testImage = loadTestImage("tshirt.jpg")
    
    // When: 进行AI识别
    let result = classifier.classify(testImage)
    
    // Then: 应该识别为"上装"类别
    XCTAssertEqual(result.category, .tops)
    XCTAssertGreaterThan(result.confidence, 0.7)
}
```

### Phase 3: 最小实现 (Minimal Implementation)
```swift
// ✅ 好的实现 - 简洁明确
func classify(image: UIImage) async -> ClassificationResult {
    guard let ciImage = CIImage(image: image) else {
        return ClassificationResult.failed("Invalid image")
    }
    
    // 核心逻辑
    return await performClassification(ciImage)
}

// ❌ 差的实现 - 一次性做太多
func classifyAndSaveAndNotify(image: UIImage) async -> Void {
    // 一个函数承担太多职责
}
```

### Phase 4: 重构 (Refactor)
```markdown
重构检查清单:
□ 函数是否单一职责?
□ 是否有重复代码?
□ 命名是否清晰?
□ 是否符合项目架构模式?
□ 错误处理是否完善?
```

### Phase 5: 提交 (Commit)
```markdown
提交信息模板:
feat(camera): add AI clothing classification

- Integrate Core ML model for clothing recognition
- Add confidence threshold validation (>70%)
- Include error handling for invalid images
- Update WardrobeManager to process results

Related to: Week 2 Development Plan
```

---

## 🚫 三次尝试原则

### 遇到问题时的处理流程:

#### 第1次尝试: 直接解决
```markdown
- 分析错误信息
- 检查常见原因
- 尝试最直观的解决方案
```

#### 第2次尝试: 换个角度
```markdown
- 重新理解问题根源
- 查找相似问题的解决方案
- 尝试不同的技术路径
```

#### 第3次尝试: 简化问题
```markdown
- 拆解复杂问题为子问题
- 实现最小可用版本
- 暂时绕过非核心功能
```

#### 第3次后: 停止并记录
```markdown
记录内容:
1. 问题的详细描述
2. 尝试过的解决方案
3. 具体的错误信息
4. 当前的假设和分析
5. 建议的下一步行动

然后寻求帮助或休息后重新思考。
```

---

## 📋 代码审查检查清单

### AI生成代码必须审查的项目:

#### ✅ 功能正确性
```markdown
□ 代码逻辑是否正确?
□ 边界条件是否处理?
□ 错误情况是否考虑?
□ 性能是否可接受?
```

#### ✅ 架构一致性
```markdown
□ 是否符合项目架构模式?
□ 是否遵循命名约定?
□ 依赖关系是否合理?
□ 接口设计是否清晰?
```

#### ✅ 安全性
```markdown
□ 输入是否经过验证?
□ 是否存在内存泄漏?
□ 权限检查是否完整?
□ 敏感数据是否安全?
```

#### ✅ 可维护性
```markdown
□ 代码是否易于理解?
□ 是否有必要的注释?
□ 函数长度是否合理?
□ 测试覆盖是否充分?
```

---

## 📚 功能性文档策略

### 文档即代码理念
> 来源: Chris Dzombak

**核心思想**: 让文档成为"负载承重的"，这样它们就不会过时。

#### 实现方式:

##### 1. README作为项目入口
```markdown
# MiniClothes

## Quick Start
1. Clone项目: `git clone ...`
2. 安装依赖: `open MiniClothes.xcodeproj`
3. 运行项目: `Cmd+R`

## 项目结构
- Models/ - 数据模型
- Views/ - UI界面
- Services/ - 业务逻辑
- Tests/ - 测试代码

## 当前开发状态
- ✅ Week 1: 基础架构 + 拍摄功能
- 🔄 Week 2: 衣橱管理 + AI识别
- 📋 Week 3: 虚拟试穿功能
- 📋 Week 4: 个人中心 + 优化
```

##### 2. 技术决策记录 (TDR)
```markdown
每个重要技术选择都要记录:
- 背景和问题
- 考虑的选项
- 决策理由
- 预期影响
- 后续评估
```

##### 3. API文档自动生成
```swift
/// 对服装图片进行AI分类识别
/// - Parameter image: 待识别的服装图片
/// - Returns: 识别结果，包含类别和置信度
/// - Note: 要求图片尺寸不小于224x224像素
func classify(image: UIImage) async throws -> ClassificationResult
```

##### 4. 测试作为活文档
```swift
func testClothingClassification_TShirt_ShouldReturnTopsCategory() {
    // 这个测试同时说明了:
    // 1. T恤应该被识别为"上装"
    // 2. 置信度应该大于0.7
    // 3. 处理时间应该小于3秒
}
```

---

## 🎨 UI开发最佳实践

### 小红书风格实现指南

#### 1. 组件化开发
```swift
// ✅ 可复用的组件
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .primaryButtonStyle() // 统一样式
        }
    }
}

// ❌ 重复的代码
Button("确定") {
    // 样式代码重复
}
```

#### 2. 设计系统一致性
```swift
// 颜色统一管理
extension Color {
    static let primaryRed = Color(hex: "FF2442")
    static let backgroundWarm = Color(hex: "FFFBF7")
}

// 间距统一定义
enum Spacing {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
}
```

#### 3. 响应式设计
```swift
struct AdaptiveCard: View {
    var body: some View {
        VStack {
            // 内容
        }
        .frame(maxWidth: .infinity)
        .padding(Device.isPad ? .large : .medium)
    }
}
```

---

## 🧪 测试策略

### 测试金字塔
```
        /\
       /UI\      <- 少量UI测试 (端到端)
      /____\
     /      \
    /集成测试 \    <- 适量集成测试 (模块间)
   /__________\
  /            \
 /   单元测试    \  <- 大量单元测试 (函数级)
/________________\
```

#### 单元测试 (70%)
```swift
// 测试AI识别逻辑
func testClassificationResult_ValidImage_ReturnsCorrectCategory() {
    let classifier = ClothingClassifier()
    let result = classifier.classify(mockTShirtImage)
    
    XCTAssertEqual(result.category, .tops)
    XCTAssertGreaterThan(result.confidence, 0.7)
}
```

#### 集成测试 (20%)
```swift
// 测试完整的保存流程
func testSaveClothing_ValidImage_SavesSuccessfully() {
    let manager = WardrobeManager()
    let image = loadTestImage("dress.jpg")
    
    manager.processNewImage(image)
    
    XCTAssertEqual(manager.clothes.count, 1)
    XCTAssertEqual(manager.clothes.first?.category, .dresses)
}
```

#### UI测试 (10%)
```swift
// 测试用户完整流程
func testCaptureAndSaveFlow() {
    app.tabBars.buttons["拍摄"].tap()
    app.buttons["拍照"].tap()
    app.buttons["添加到衣橱"].tap()
    
    XCTAssertTrue(app.staticTexts["保存成功"].exists)
}
```

---

## 🚀 性能优化指南

### 图片处理优化
```swift
// ✅ 异步处理 + 压缩
func processImage(_ image: UIImage) async -> UIImage {
    return await withTaskGroup(of: UIImage.self) { group in
        group.addTask { 
            return compressImage(image, quality: 0.8) 
        }
        return await group.first() ?? image
    }
}

// ❌ 主线程阻塞
func processImage(_ image: UIImage) -> UIImage {
    // 大图片处理会阻塞UI
    return heavyProcessing(image)
}
```

### 内存管理
```swift
// ✅ 合理的缓存策略
class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    
    init() {
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
        cache.countLimit = 100 // 最多100张图片
    }
}

// ❌ 无限制的内存使用
var allImages: [UIImage] = [] // 会导致内存溢出
```

---

## 📊 质量监控

### 自动化检查
```swift
// 在每次构建时检查
- 编译警告数量: 0
- 代码覆盖率: >70%
- 性能测试: 通过
- 内存泄漏: 无
```

### 用户反馈收集
```swift
// 嵌入简单的分析代码
struct PerformanceTracker {
    static func trackAIClassification(duration: TimeInterval, accuracy: Double) {
        // 记录AI识别性能
        UserDefaults.standard.set(duration, forKey: "lastClassificationTime")
        UserDefaults.standard.set(accuracy, forKey: "averageAccuracy")
    }
}
```

---

## 🎉 版本发布检查清单

### Pre-release检查 (每周发布前)
```markdown
□ 所有计划功能已完成
□ 单元测试通过率 > 90%
□ UI测试核心流程通过
□ 性能指标在可接受范围内
□ 内存泄漏检查通过
□ 在至少3个不同设备上测试
□ 更新文档和CHANGELOG
```

### Post-release监控 (发布后24小时)
```markdown
□ 应用启动成功率 > 99%
□ 核心功能使用率 > 80%
□ 用户反馈收集和分析
□ 性能指标监控
□ 崩溃报告分析
```

---

## 🔄 持续改进

### 每周回顾会议
```markdown
讨论内容:
1. 本周完成的功能和质量
2. 遇到的技术难题和解决方案
3. AI协作效率和改进建议
4. 用户反馈和产品方向调整
5. 下周计划和优先级调整
```

### 经验总结
```markdown
每个阶段结束后记录:
- 什么工作得很好?
- 什么可以改进?
- 学到了什么新技能?
- 有哪些可复用的模式?
- 如何避免类似问题?
```

---

## 📝 模板和工具

### 功能开发模板
```markdown
## 功能: [功能名称]

### 背景
- 用户需求: 
- 业务价值:
- 技术约束:

### 实现计划
- [ ] 设计API接口
- [ ] 编写单元测试
- [ ] 实现核心逻辑
- [ ] 集成测试
- [ ] UI实现
- [ ] 用户体验测试

### 成功标准
- 功能性: 
- 性能: 
- 质量: 

### 风险和缓解
- 风险1: 应对方案1
- 风险2: 应对方案2
```

### Bug报告模板
```markdown
## Bug: [简短描述]

### 复现步骤
1. 
2. 
3. 

### 预期结果
[应该发生什么]

### 实际结果
[实际发生什么]

### 环境信息
- iOS版本:
- 设备型号:
- 应用版本:
- 其他相关信息:

### 错误日志
```
[粘贴错误日志]
```
```

---

*文档版本: 1.0*  
*基于: Chris Dzombak, Simon Willison, Anthropic 最佳实践*  
*最后更新: 2025-08-29*  
*维护者: 开发团队*