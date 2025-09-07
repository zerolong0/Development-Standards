# 组件化设计系统

## 🎯 概述

组件化设计系统是AI驱动设计的基础架构。通过标准化的组件库、Design Tokens和Registry系统，实现设计与代码的完美同步，让AI能够准确理解和生成符合规范的代码。

## 🏗️ 核心架构

### 设计系统层次结构

```
┌─────────────────────────────────────┐
│         Design Tokens               │ <- 设计基础变量
├─────────────────────────────────────┤
│         Base Components             │ <- 原子组件
├─────────────────────────────────────┤
│        Composite Components         │ <- 分子组件
├─────────────────────────────────────┤
│           Templates                 │ <- 模板页面
├─────────────────────────────────────┤
│         AI Generation Layer         │ <- AI生成层
└─────────────────────────────────────┘
```

## 📦 shadcn/ui 基础架构

### 核心理念
shadcn/ui不是传统的组件库，而是一个可复制粘贴的组件集合，提供：
- **完全控制权**: 代码在你的项目中，可自由修改
- **类型安全**: 完整的TypeScript支持
- **无依赖负担**: 只引入需要的组件
- **AI友好**: 结构清晰，易于AI理解和生成

### 初始化配置

```bash
# 1. 初始化shadcn/ui
npx shadcn-ui@latest init

# 2. 配置文件 components.json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.js",
    "css": "app/globals.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
```

### 组件安装和使用

```bash
# 安装单个组件
npx shadcn-ui@latest add button

# 安装多个组件
npx shadcn-ui@latest add dialog card select

# 安装所有组件
npx shadcn-ui@latest add --all
```

### 组件结构示例

```typescript
// components/ui/button.tsx
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input bg-background hover:bg-accent",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
```

## 🤖 AI Elements 组件库

### 概述
Vercel AI Elements是专为AI应用设计的React UI组件库，基于shadcn/ui构建，提供：
- **AI专用组件**: 消息线程、输入框、推理面板等
- **状态管理集成**: 与Vercel AI SDK无缝配合
- **完全可定制**: 基于shadcn/ui的设计理念

### 安装和配置

```bash
# 安装AI Elements
npm install @vercel/ai-elements

# 安装依赖
npm install ai @ai-sdk/openai
```

### 核心组件

#### 1. Message Thread（消息线程）
```typescript
import { Thread, Message, MessageInput } from '@vercel/ai-elements'

export function ChatInterface() {
  const { messages, input, handleSubmit, handleInputChange } = useChat()
  
  return (
    <Thread>
      {messages.map((message) => (
        <Message
          key={message.id}
          role={message.role}
          content={message.content}
        />
      ))}
      <MessageInput
        value={input}
        onChange={handleInputChange}
        onSubmit={handleSubmit}
      />
    </Thread>
  )
}
```

#### 2. Reasoning Panel（推理面板）
```typescript
import { ReasoningPanel, Step } from '@vercel/ai-elements'

export function AIReasoning({ steps }) {
  return (
    <ReasoningPanel>
      {steps.map((step, index) => (
        <Step
          key={index}
          title={step.title}
          status={step.status}
          content={step.content}
        />
      ))}
    </ReasoningPanel>
  )
}
```

#### 3. Response Actions（响应操作）
```typescript
import { ResponseActions, CopyButton, RegenerateButton } from '@vercel/ai-elements'

export function MessageActions({ message, onRegenerate }) {
  return (
    <ResponseActions>
      <CopyButton content={message.content} />
      <RegenerateButton onClick={onRegenerate} />
    </ResponseActions>
  )
}
```

## 🎨 Design Tokens 自动化

### Design Tokens 概念
Design Tokens是设计系统的原子单位，包含所有设计决策的值：
- **颜色**: 主色、辅助色、语义色
- **间距**: 边距、内边距、间隙
- **字体**: 字体族、大小、行高
- **阴影**: 投影效果
- **动画**: 过渡时间、缓动函数

### Style Dictionary 配置

```javascript
// style-dictionary.config.js
module.exports = {
  source: ['tokens/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'build/css/',
      files: [{
        destination: 'variables.css',
        format: 'css/variables',
        options: {
          outputReferences: true
        }
      }]
    },
    js: {
      transformGroup: 'js',
      buildPath: 'build/js/',
      files: [{
        destination: 'tokens.js',
        format: 'javascript/es6'
      }]
    },
    scss: {
      transformGroup: 'scss',
      buildPath: 'build/scss/',
      files: [{
        destination: '_variables.scss',
        format: 'scss/variables'
      }]
    }
  }
}
```

### Token 定义示例

```json
// tokens/color.json
{
  "color": {
    "primary": {
      "50": { "value": "#eff6ff" },
      "100": { "value": "#dbeafe" },
      "500": { "value": "#3b82f6" },
      "900": { "value": "#1e3a8a" }
    },
    "semantic": {
      "error": { "value": "{color.red.500}" },
      "warning": { "value": "{color.yellow.500}" },
      "success": { "value": "{color.green.500}" }
    }
  }
}
```

### 自动同步工作流

```yaml
# .github/workflows/design-tokens.yml
name: Sync Design Tokens

on:
  push:
    paths:
      - 'tokens/**'
  
jobs:
  build-tokens:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
      - name: Install dependencies
        run: npm ci
      - name: Build tokens
        run: npm run build:tokens
      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add .
          git commit -m "Update design tokens" || exit 0
          git push
```

## 🔗 Registry 系统构建

### Registry 概念
Registry是组件、样式和配置的中央存储库，使AI能够：
- 理解项目的设计系统
- 生成符合规范的代码
- 保持一致性

### 自定义Registry结构

```typescript
// registry/index.ts
export const registry = {
  // 组件注册
  components: {
    Button: {
      name: 'Button',
      path: '@/components/ui/button',
      dependencies: ['@radix-ui/react-slot'],
      devDependencies: ['@types/react'],
      registryDependencies: [],
      files: ['button.tsx'],
      type: 'component'
    },
    Card: {
      name: 'Card',
      path: '@/components/ui/card',
      dependencies: [],
      devDependencies: [],
      registryDependencies: [],
      files: ['card.tsx'],
      type: 'component'
    }
  },
  
  // 样式注册
  styles: {
    globals: {
      css: `
        @layer base {
          :root {
            --background: 0 0% 100%;
            --foreground: 222.2 84% 4.9%;
          }
        }
      `
    }
  },
  
  // 主题注册
  themes: {
    light: {
      colors: {
        background: 'hsl(0 0% 100%)',
        foreground: 'hsl(222.2 84% 4.9%)'
      }
    },
    dark: {
      colors: {
        background: 'hsl(222.2 84% 4.9%)',
        foreground: 'hsl(210 40% 98%)'
      }
    }
  },
  
  // 块注册（预构建的组件组合）
  blocks: {
    'hero-section': {
      name: 'Hero Section',
      dependencies: ['Button', 'Typography'],
      code: `
        export function HeroSection() {
          return (
            <section className="py-24">
              <Typography variant="h1">Welcome</Typography>
              <Button>Get Started</Button>
            </section>
          )
        }
      `
    }
  }
}
```

### v0 Registry 集成

```javascript
// v0.registry.json
{
  "$schema": "https://v0.app/schema/registry.json",
  "name": "my-design-system",
  "version": "1.0.0",
  "components": [
    {
      "name": "button",
      "files": [
        {
          "path": "components/ui/button.tsx",
          "content": "// Button component code"
        }
      ],
      "dependencies": {
        "@radix-ui/react-slot": "^1.0.2"
      }
    }
  ],
  "hooks": [
    {
      "name": "use-toast",
      "files": [
        {
          "path": "hooks/use-toast.ts",
          "content": "// Toast hook code"
        }
      ]
    }
  ]
}
```

## 🔄 MCP 协议集成

### Model Context Protocol 概述
MCP（Model Context Protocol）是一个开放协议，让AI模型能够：
- 访问项目上下文
- 理解代码结构
- 生成一致的代码

### MCP 服务器配置

```typescript
// mcp-server.ts
import { MCPServer } from '@modelcontextprotocol/server'

const server = new MCPServer({
  name: 'design-system-mcp',
  version: '1.0.0',
  
  // 提供组件信息
  resources: {
    '/components': {
      async list() {
        return Object.keys(registry.components)
      },
      async get(name: string) {
        return registry.components[name]
      }
    },
    
    // 提供设计令牌
    '/tokens': {
      async get() {
        return designTokens
      }
    }
  },
  
  // 工具定义
  tools: {
    'generate-component': {
      description: 'Generate a new component',
      parameters: {
        name: { type: 'string', required: true },
        props: { type: 'object' }
      },
      async execute({ name, props }) {
        // 组件生成逻辑
        return generateComponent(name, props)
      }
    }
  }
})

server.start()
```

### 客户端集成

```typescript
// 在Cursor/Windsurf中使用
// .cursorrules 或 .windsurfrules
{
  "mcp_servers": {
    "design-system": {
      "command": "node",
      "args": ["./mcp-server.js"]
    }
  }
}
```

## 🎯 最佳实践

### 1. 组件设计原则

#### 单一职责
每个组件只负责一个功能：
```typescript
// ✅ 好的设计
<Button onClick={handleClick}>Submit</Button>
<LoadingSpinner isLoading={isLoading} />

// ❌ 不好的设计
<SubmitButtonWithLoading 
  onClick={handleClick} 
  isLoading={isLoading} 
/>
```

#### 组合优于继承
使用组合模式构建复杂组件：
```typescript
// 组合模式
<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
  </CardHeader>
  <CardContent>
    Content
  </CardContent>
</Card>
```

### 2. Token 管理策略

#### 语义化命名
```json
{
  "color": {
    // ✅ 语义化
    "text-primary": { "value": "{color.gray.900}" },
    "text-secondary": { "value": "{color.gray.600}" },
    
    // ❌ 非语义化
    "dark-gray": { "value": "#1a1a1a" },
    "light-gray": { "value": "#f5f5f5" }
  }
}
```

#### 分层管理
```
基础层 → 语义层 → 组件层
  ↓        ↓         ↓
colors → text →  button
sizes  → spacing → card
```

### 3. Registry 维护

#### 版本控制
```json
{
  "version": "1.2.0",
  "changelog": {
    "1.2.0": "Added new Button variants",
    "1.1.0": "Updated color tokens",
    "1.0.0": "Initial release"
  }
}
```

#### 文档同步
```typescript
// 组件文档自动生成
/**
 * @component Button
 * @description Primary button component
 * @example
 * <Button variant="primary" size="md">
 *   Click me
 * </Button>
 */
```

## 📊 性能优化

### 1. 代码分割
```typescript
// 动态导入组件
const Button = lazy(() => import('./components/ui/button'))
const Dialog = lazy(() => import('./components/ui/dialog'))
```

### 2. Tree Shaking
```javascript
// 只导入需要的组件
import { Button } from '@/components/ui/button'
// 而不是
import * as UI from '@/components/ui'
```

### 3. CSS优化
```css
/* 使用CSS变量减少重复 */
:root {
  --button-height: 2.5rem;
  --button-padding: 0 1rem;
}

.button {
  height: var(--button-height);
  padding: var(--button-padding);
}
```

## 🔧 工具链集成

### Storybook 集成
```typescript
// Button.stories.tsx
export default {
  title: 'UI/Button',
  component: Button,
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['default', 'destructive', 'outline']
    }
  }
}

export const Default = {
  args: {
    children: 'Button'
  }
}
```

### 测试配置
```typescript
// Button.test.tsx
import { render, screen } from '@testing-library/react'
import { Button } from './button'

describe('Button', () => {
  it('renders correctly', () => {
    render(<Button>Test</Button>)
    expect(screen.getByText('Test')).toBeInTheDocument()
  })
})
```

## 📚 参考资源

- [shadcn/ui官方文档](https://ui.shadcn.com)
- [Vercel AI Elements](https://vercel.com/ai/elements)
- [Style Dictionary](https://amzn.github.io/style-dictionary)
- [MCP协议规范](https://modelcontextprotocol.org)

---

*最后更新: 2025-09-07*