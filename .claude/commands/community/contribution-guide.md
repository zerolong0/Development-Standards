# 开源贡献指南生成器

自动生成标准化的开源项目贡献指南，促进社区协作和代码质量。

## 使用方式

请为当前项目生成贡献指南: $ARGUMENTS

## 🎯 贡献指南内容

### 标准贡献流程
1. **问题报告** - Bug报告、功能请求、改进建议
2. **代码贡献** - Fork、开发、测试、提交PR
3. **文档贡献** - 文档改进、翻译、示例补充
4. **社区参与** - 讨论、代码审查、帮助新手

### 代码规范要求
- **代码风格** - 遵循项目既定的代码规范
- **提交规范** - 使用约定式提交格式
- **测试要求** - 新功能必须包含相应测试
- **文档更新** - 重要变更需要更新文档

## 📝 贡献指南模板

### 完整贡献指南
```markdown
# 贡献指南

感谢您对本项目的兴趣！我们欢迎任何形式的贡献，无论是代码、文档还是问题报告。

## 🚀 快速开始

### 环境准备
\`\`\`bash
# 1. Fork 项目到您的GitHub账户
# 2. 克隆项目到本地
git clone https://github.com/YOUR_USERNAME/PROJECT_NAME.git
cd PROJECT_NAME

# 3. 安装依赖
npm install
# 或 
pnpm install
# 或
yarn install

# 4. 启动开发服务器
npm run dev
\`\`\`

### 开发工作流
1. **创建功能分支**
   \`\`\`bash
   git checkout -b feature/your-feature-name
   \`\`\`

2. **进行开发**
   - 编写代码
   - 添加测试
   - 确保测试通过
   - 更新文档

3. **提交代码**
   \`\`\`bash
   git add .
   git commit -m "feat: add your feature description"
   \`\`\`

4. **推送并创建PR**
   \`\`\`bash
   git push origin feature/your-feature-name
   \`\`\`

## 📋 贡献类型

### 🐛 Bug报告
使用以下模板报告Bug：

\`\`\`markdown
**Bug描述**
简洁清晰地描述问题是什么

**重现步骤**
1. 前往 '...'
2. 点击 '....'
3. 滚动到 '....'
4. 看到错误

**期望行为**
清晰简洁地描述您期望发生什么

**截图**
如果可能，添加截图来帮助解释问题

**环境信息**
 - OS: [例如 iOS]
 - Browser: [例如 chrome, safari]
 - Version: [例如 22]
 - Node版本: [例如 18.0.0]

**其他上下文**
在这里添加关于问题的任何其他上下文
\`\`\`

### ✨ 功能请求
使用以下模板请求新功能：

\`\`\`markdown
**功能描述**
清晰简洁地描述您希望实现的功能

**问题背景**
描述这个功能将解决什么问题

**解决方案**
描述您希望实现的解决方案

**替代方案**
描述您考虑过的任何替代解决方案或功能

**其他上下文**
在这里添加关于功能请求的任何其他上下文或屏幕截图
\`\`\`

### 💻 代码贡献

#### Pull Request检查清单
在提交PR之前，请确认以下事项：

- [ ] 代码遵循项目的代码规范
- [ ] 进行了自我代码审查
- [ ] 代码有适当的注释，特别是在难以理解的区域
- [ ] 对文档进行了相应的更改
- [ ] 更改不会生成新的警告
- [ ] 添加了证明修复有效或功能正常的测试
- [ ] 新的和现有的单元测试在本地通过
- [ ] 任何依赖更改都已合并和发布

#### 代码规范

**TypeScript/JavaScript**
\`\`\`typescript
// ✅ 推荐的代码风格
interface UserProfile {
  id: string;
  username: string;
  email: string;
  createdAt: Date;
}

class UserService {
  async createUser(profile: Omit<UserProfile, 'id' | 'createdAt'>): Promise<UserProfile> {
    const user = {
      id: generateId(),
      createdAt: new Date(),
      ...profile
    };
    
    return await this.userRepository.save(user);
  }
}

// ❌ 避免的代码风格
class userservice {
  createuser(data) {
    const user = Object.assign({}, data, {
      id: Math.random(),
      created: new Date()
    });
    return this.repo.save(user);
  }
}
\`\`\`

**提交信息格式**
使用[约定式提交](https://www.conventionalcommits.org/zh-hans/)格式：

\`\`\`
<类型>[可选的作用域]: <描述>

[可选的正文]

[可选的脚注]
\`\`\`

类型说明：
- \`feat\`: 新功能
- \`fix\`: 修复bug
- \`docs\`: 文档变更
- \`style\`: 代码格式（不影响代码运行的变动）
- \`refactor\`: 重构（既不是新功能，也不是修改bug的代码变动）
- \`test\`: 增加测试
- \`chore\`: 构建过程或辅助工具的变动

示例：
\`\`\`
feat(auth): add OAuth2 login support

- Implement Google OAuth2 integration
- Add user profile synchronization
- Update login UI components

Closes #123
\`\`\`

## 🧪 测试要求

### 单元测试
\`\`\`bash
# 运行所有测试
npm test

# 运行特定测试文件
npm test -- UserService.test.ts

# 运行测试并生成覆盖率报告
npm run test:coverage
\`\`\`

### 测试规范
- 测试覆盖率应保持在80%以上
- 每个公共方法都应有相应的测试
- 测试应该清晰描述测试场景

\`\`\`typescript
// ✅ 好的测试示例
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      const userData = {
        username: 'testuser',
        email: 'test@example.com'
      };
      
      const result = await userService.createUser(userData);
      
      expect(result.id).toBeDefined();
      expect(result.username).toBe(userData.username);
      expect(result.email).toBe(userData.email);
      expect(result.createdAt).toBeInstanceOf(Date);
    });
    
    it('should throw error when email already exists', async () => {
      const userData = {
        username: 'testuser',
        email: 'existing@example.com'
      };
      
      await expect(userService.createUser(userData))
        .rejects.toThrow('Email already exists');
    });
  });
});
\`\`\`

## 📚 文档贡献

### 文档类型
- **API文档**: 接口说明和示例
- **使用指南**: 功能使用说明
- **开发文档**: 开发环境和架构说明
- **示例代码**: 实际使用案例

### 文档规范
- 使用清晰的标题层次
- 提供代码示例
- 包含实际的使用场景
- 保持更新和准确性

## 🔍 代码审查

### 审查重点
1. **功能正确性** - 代码是否实现了预期功能
2. **代码质量** - 是否遵循最佳实践
3. **性能考虑** - 是否存在性能问题
4. **安全性** - 是否存在安全隐患
5. **可维护性** - 代码是否易于理解和维护

### 审查礼仪
- 提供建设性的反馈
- 解释改进建议的原因
- 识别和赞赏好的代码
- 保持友好和专业的态度

## 🏆 贡献者认可

### 贡献类型认可
- **代码贡献者** - 提交代码修改
- **文档贡献者** - 改进文档质量
- **测试贡献者** - 添加或改进测试
- **设计贡献者** - UI/UX设计改进
- **社区管理者** - 帮助维护社区秩序

### 认可方式
- README中的贡献者列表
- 发布日志中的致谢
- 社交媒体的感谢
- 特殊贡献者徽章

## 📞 联系方式

如果您有任何问题或需要帮助：

- 📧 邮箱: [project-email@example.com]
- 💬 讨论: [GitHub Discussions](https://github.com/username/project/discussions)
- 🐛 问题: [GitHub Issues](https://github.com/username/project/issues)
- 📱 社交: [Twitter @project](https://twitter.com/project)

## 📄 许可证

通过贡献代码，您同意您的贡献将在与项目相同的许可证下授权。

---

再次感谢您的贡献！🎉 您的参与让这个项目变得更好。
\`\`\`

## 💡 社区建设最佳实践

### 新贡献者引导
```markdown
# 新贡献者指南

## 👋 欢迎新人
- 友好的欢迎消息
- 简化的第一次贡献流程
- "good first issue"标签
- 导师计划

## 🎯 渐进式参与
1. **观察阶段** - 熟悉项目和社区
2. **小贡献** - 修复typo、改进文档
3. **功能贡献** - 实现小功能或bug修复
4. **核心贡献** - 参与重要功能开发
5. **维护者** - 承担项目维护职责

## 🤝 导师制度
- 为新贡献者分配导师
- 定期沟通和指导
- 渐进式技能培养
- 经验分享和交流
```

### 社区行为准则
```markdown
# 社区行为准则

## 我们的承诺
为了营造开放和包容的环境，我们作为贡献者和维护者承诺：让每个人都能无骚扰地参与我们的项目和社区。

## 我们的标准
积极行为包括：
* 使用包容性语言
* 尊重不同的观点和经历
* 优雅地接受建设性批评
* 关注对社区最有利的事情
* 对社区其他成员表示同理心

不当行为包括：
* 使用与性有关的言语或图像
* 恶意评论、人身攻击或政治攻击
* 公开或私下的骚扰
* 发布他人隐私信息
* 其他在专业环境中不当的行为

## 执行
社区维护者有权删除、编辑或拒绝评论、提交、代码、Wiki编辑、问题和其他贡献。
```

请开始生成贡献指南。