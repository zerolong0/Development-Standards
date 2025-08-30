# 智能测试生成器

基于代码分析自动生成全面的测试用例，支持单元测试、集成测试和E2E测试。

## 使用方式

请为以下代码生成完整的测试用例: $ARGUMENTS

## 🎯 测试生成范围

### 测试类型
1. **单元测试 (Unit Tests)**
   - 函数/方法级别测试
   - 边界条件覆盖
   - 异常情况处理
   - Mock和Stub使用

2. **集成测试 (Integration Tests)**
   - API接口测试
   - 数据库交互测试
   - 第三方服务集成
   - 组件间协作测试

3. **端到端测试 (E2E Tests)**
   - 用户流程测试
   - 浏览器自动化
   - 跨平台兼容性
   - 性能和可用性

## 🧪 测试框架支持

### JavaScript/TypeScript
```typescript
// Jest + Testing Library 配置
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { jest } from '@jest/globals';
import userEvent from '@testing-library/user-event';

// Vitest 配置
import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';

// Playwright E2E
import { test, expect as playwrightExpect } from '@playwright/test';

// Cypress E2E  
describe('User Authentication Flow', () => {
  it('should login successfully with valid credentials', () => {
    cy.visit('/login');
    cy.get('[data-cy=email]').type('user@example.com');
    cy.get('[data-cy=password]').type('password123');
    cy.get('[data-cy=login-btn]').click();
    cy.url().should('include', '/dashboard');
  });
});
```

### Python
```python
# pytest + FastAPI TestClient
import pytest
from fastapi.testclient import TestClient
from unittest.mock import Mock, patch
import asyncio

# Django Test Framework
from django.test import TestCase, Client
from django.contrib.auth.models import User

# Selenium WebDriver
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
```

### Java
```java
// JUnit 5 + Mockito + Spring Boot Test
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

// TestNG
import org.testng.annotations.Test;
import org.testng.annotations.BeforeMethod;
import org.testng.Assert;
```

## 📝 测试生成模板

### React组件测试
```typescript
// 组件: UserProfile.tsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserProfile } from './UserProfile';

describe('UserProfile Component', () => {
  const mockProps = {
    user: {
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      avatar: 'avatar.jpg'
    },
    onEdit: jest.fn(),
    onDelete: jest.fn()
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering', () => {
    it('should render user information correctly', () => {
      render(<UserProfile {...mockProps} />);
      
      expect(screen.getByText('John Doe')).toBeInTheDocument();
      expect(screen.getByText('john@example.com')).toBeInTheDocument();
      expect(screen.getByAltText('User avatar')).toHaveAttribute('src', 'avatar.jpg');
    });

    it('should render edit and delete buttons', () => {
      render(<UserProfile {...mockProps} />);
      
      expect(screen.getByRole('button', { name: /edit/i })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: /delete/i })).toBeInTheDocument();
    });
  });

  describe('User Interactions', () => {
    it('should call onEdit when edit button is clicked', async () => {
      const user = userEvent.setup();
      render(<UserProfile {...mockProps} />);
      
      await user.click(screen.getByRole('button', { name: /edit/i }));
      
      expect(mockProps.onEdit).toHaveBeenCalledTimes(1);
      expect(mockProps.onEdit).toHaveBeenCalledWith(mockProps.user.id);
    });

    it('should call onDelete when delete button is clicked', async () => {
      const user = userEvent.setup();
      render(<UserProfile {...mockProps} />);
      
      await user.click(screen.getByRole('button', { name: /delete/i }));
      
      expect(mockProps.onDelete).toHaveBeenCalledTimes(1);
      expect(mockProps.onDelete).toHaveBeenCalledWith(mockProps.user.id);
    });
  });

  describe('Edge Cases', () => {
    it('should handle missing avatar gracefully', () => {
      const propsWithoutAvatar = {
        ...mockProps,
        user: { ...mockProps.user, avatar: null }
      };
      
      render(<UserProfile {...propsWithoutAvatar} />);
      
      expect(screen.getByAltText('User avatar')).toHaveAttribute('src', '/default-avatar.png');
    });

    it('should disable buttons when user is undefined', () => {
      const propsWithoutUser = { ...mockProps, user: undefined };
      
      render(<UserProfile {...propsWithoutUser} />);
      
      expect(screen.getByRole('button', { name: /edit/i })).toBeDisabled();
      expect(screen.getByRole('button', { name: /delete/i })).toBeDisabled();
    });
  });

  describe('Accessibility', () => {
    it('should have proper ARIA labels', () => {
      render(<UserProfile {...mockProps} />);
      
      expect(screen.getByLabelText('User profile')).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'Edit user profile' })).toBeInTheDocument();
    });

    it('should support keyboard navigation', async () => {
      const user = userEvent.setup();
      render(<UserProfile {...mockProps} />);
      
      await user.tab();
      expect(screen.getByRole('button', { name: /edit/i })).toHaveFocus();
      
      await user.tab();
      expect(screen.getByRole('button', { name: /delete/i })).toHaveFocus();
    });
  });
});
```

### API接口测试
```typescript
// API测试: userService.test.ts
import { UserService } from './userService';
import axios from 'axios';

jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    userService = new UserService();
    jest.clearAllMocks();
  });

  describe('getUsers', () => {
    it('should fetch users successfully', async () => {
      const mockUsers = [
        { id: 1, name: 'John Doe', email: 'john@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
      ];
      
      mockedAxios.get.mockResolvedValue({ 
        data: { data: mockUsers, status: 'success' }
      });

      const result = await userService.getUsers();

      expect(mockedAxios.get).toHaveBeenCalledWith('/api/users', {
        params: { page: 1, limit: 20 }
      });
      expect(result).toEqual(mockUsers);
    });

    it('should handle API errors gracefully', async () => {
      const errorResponse = {
        response: { 
          status: 404, 
          data: { error: 'NOT_FOUND', message: 'Users not found' }
        }
      };
      
      mockedAxios.get.mockRejectedValue(errorResponse);

      await expect(userService.getUsers()).rejects.toThrow('Users not found');
      expect(mockedAxios.get).toHaveBeenCalledTimes(1);
    });

    it('should handle network errors', async () => {
      mockedAxios.get.mockRejectedValue(new Error('Network Error'));

      await expect(userService.getUsers()).rejects.toThrow('Network Error');
    });
  });

  describe('createUser', () => {
    const newUserData = {
      name: 'New User',
      email: 'newuser@example.com',
      password: 'password123'
    };

    it('should create user successfully', async () => {
      const createdUser = { id: 3, ...newUserData };
      mockedAxios.post.mockResolvedValue({ 
        data: { data: createdUser, status: 'success' }
      });

      const result = await userService.createUser(newUserData);

      expect(mockedAxios.post).toHaveBeenCalledWith('/api/users', newUserData);
      expect(result).toEqual(createdUser);
    });

    it('should handle validation errors', async () => {
      const validationError = {
        response: {
          status: 400,
          data: {
            error: 'VALIDATION_ERROR',
            message: 'Validation failed',
            details: ['Email is required', 'Password is too short']
          }
        }
      };
      
      mockedAxios.post.mockRejectedValue(validationError);

      await expect(userService.createUser(newUserData)).rejects.toThrow('Validation failed');
    });
  });

  describe('Error Handling', () => {
    it('should retry on 5xx errors', async () => {
      mockedAxios.get
        .mockRejectedValueOnce({ response: { status: 500 } })
        .mockRejectedValueOnce({ response: { status: 503 } })
        .mockResolvedValue({ data: { data: [], status: 'success' } });

      const result = await userService.getUsers();

      expect(mockedAxios.get).toHaveBeenCalledTimes(3);
      expect(result).toEqual([]);
    });

    it('should not retry on 4xx errors', async () => {
      mockedAxios.get.mockRejectedValue({ response: { status: 401 } });

      await expect(userService.getUsers()).rejects.toThrow();
      expect(mockedAxios.get).toHaveBeenCalledTimes(1);
    });
  });
});
```

### E2E测试生成
```typescript
// Playwright E2E测试
import { test, expect } from '@playwright/test';

test.describe('User Management Flow', () => {
  test.beforeEach(async ({ page }) => {
    // 登录前置条件
    await page.goto('/login');
    await page.fill('[data-testid=email]', 'admin@example.com');
    await page.fill('[data-testid=password]', 'admin123');
    await page.click('[data-testid=login-button]');
    await expect(page).toHaveURL('/dashboard');
  });

  test('should create a new user successfully', async ({ page }) => {
    // 导航到用户管理页面
    await page.click('nav a[href="/users"]');
    await expect(page).toHaveURL('/users');

    // 点击创建用户按钮
    await page.click('[data-testid=create-user-btn]');
    await expect(page.locator('[data-testid=user-form]')).toBeVisible();

    // 填写用户表单
    await page.fill('[data-testid=username]', 'testuser');
    await page.fill('[data-testid=email]', 'testuser@example.com');
    await page.fill('[data-testid=password]', 'password123');
    await page.selectOption('[data-testid=role]', 'user');

    // 提交表单
    await page.click('[data-testid=submit-btn]');
    
    // 验证成功消息
    await expect(page.locator('[data-testid=success-message]')).toBeVisible();
    await expect(page.locator('[data-testid=success-message]')).toContainText('用户创建成功');

    // 验证用户在列表中出现
    await expect(page.locator('table tbody tr').last()).toContainText('testuser');
    await expect(page.locator('table tbody tr').last()).toContainText('testuser@example.com');
  });

  test('should validate form fields', async ({ page }) => {
    await page.goto('/users');
    await page.click('[data-testid=create-user-btn]');

    // 提交空表单
    await page.click('[data-testid=submit-btn]');

    // 验证错误消息
    await expect(page.locator('[data-testid=username-error]')).toContainText('用户名不能为空');
    await expect(page.locator('[data-testid=email-error]')).toContainText('邮箱不能为空');
    await expect(page.locator('[data-testid=password-error]')).toContainText('密码不能为空');
  });

  test('should edit user information', async ({ page }) => {
    await page.goto('/users');
    
    // 点击第一个用户的编辑按钮
    await page.click('table tbody tr:first-child [data-testid=edit-btn]');
    await expect(page.locator('[data-testid=user-form]')).toBeVisible();

    // 修改用户信息
    await page.fill('[data-testid=username]', 'updateduser');
    await page.click('[data-testid=submit-btn]');

    // 验证更新成功
    await expect(page.locator('[data-testid=success-message]')).toBeVisible();
    await expect(page.locator('table tbody tr:first-child')).toContainText('updateduser');
  });

  test('should delete user with confirmation', async ({ page }) => {
    await page.goto('/users');
    
    const userCountBefore = await page.locator('table tbody tr').count();
    
    // 点击删除按钮
    await page.click('table tbody tr:first-child [data-testid=delete-btn]');
    
    // 确认删除对话框
    await expect(page.locator('[data-testid=confirm-dialog]')).toBeVisible();
    await expect(page.locator('[data-testid=confirm-dialog]')).toContainText('确定要删除这个用户吗？');
    
    await page.click('[data-testid=confirm-delete-btn]');
    
    // 验证用户被删除
    await expect(page.locator('[data-testid=success-message]')).toBeVisible();
    
    const userCountAfter = await page.locator('table tbody tr').count();
    expect(userCountAfter).toBe(userCountBefore - 1);
  });
});
```

## 🎯 测试策略生成

### 测试金字塔策略
```markdown
## 测试策略

### 单元测试 (70%)
- **覆盖范围**: 所有纯函数、工具类、业务逻辑
- **测试重点**: 边界条件、异常处理、算法逻辑
- **Mock策略**: 外部依赖、API调用、数据库操作
- **覆盖率目标**: 90%+

### 集成测试 (20%)  
- **覆盖范围**: API接口、数据库交互、第三方服务
- **测试重点**: 组件协作、数据流转、错误传播
- **环境配置**: 测试数据库、Mock服务、测试配置
- **覆盖率目标**: 80%+

### E2E测试 (10%)
- **覆盖范围**: 关键用户流程、核心业务场景
- **测试重点**: 用户体验、跨浏览器兼容、性能表现
- **自动化程度**: 完全自动化，CI/CD集成
- **覆盖率目标**: 主要用户路径100%
```

### 测试数据管理
```typescript
// 测试数据工厂
export class TestDataFactory {
  static createUser(overrides?: Partial<User>): User {
    return {
      id: faker.datatype.uuid(),
      username: faker.internet.userName(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      role: 'user',
      created_at: faker.date.past().toISOString(),
      updated_at: faker.date.recent().toISOString(),
      ...overrides
    };
  }

  static createUsers(count: number, overrides?: Partial<User>): User[] {
    return Array.from({ length: count }, () => this.createUser(overrides));
  }
}

// 测试场景构建器
export class TestScenarioBuilder {
  private users: User[] = [];
  private posts: Post[] = [];

  withUsers(count: number): this {
    this.users = TestDataFactory.createUsers(count);
    return this;
  }

  withAdminUser(): this {
    this.users.push(TestDataFactory.createUser({ role: 'admin' }));
    return this;
  }

  build(): TestScenario {
    return {
      users: this.users,
      posts: this.posts
    };
  }
}
```

## 📊 测试覆盖率分析

### 覆盖率报告生成
```bash
# Jest覆盖率配置
{
  "collectCoverage": true,
  "collectCoverageFrom": [
    "src/**/*.{ts,tsx}",
    "!src/**/*.d.ts",
    "!src/test/**/*"
  ],
  "coverageThreshold": {
    "global": {
      "branches": 80,
      "functions": 80,
      "lines": 80,
      "statements": 80
    }
  },
  "coverageReporters": ["text", "lcov", "html"]
}
```

### 质量门禁设置
```yaml
# GitHub Actions质量门禁
- name: Test Coverage Check
  run: |
    npm run test:coverage
    npx c8 check-coverage --branches 80 --functions 80 --lines 80
```

## 💡 测试最佳实践

### 1. 测试命名规范
```typescript
// 好的测试命名
describe('UserService.createUser', () => {
  it('should create user with valid data', () => {});
  it('should throw ValidationError when email is invalid', () => {});
  it('should hash password before saving to database', () => {});
});

// 避免的命名
describe('UserService', () => {
  it('test1', () => {});
  it('should work', () => {});
});
```

### 2. 测试组织结构
```
tests/
├── unit/           # 单元测试
│   ├── services/
│   ├── utils/
│   └── components/
├── integration/    # 集成测试
│   ├── api/
│   └── database/
├── e2e/           # 端到端测试
│   ├── user-flows/
│   └── pages/
└── fixtures/      # 测试数据
    ├── users.json
    └── posts.json
```

### 3. Mock策略
```typescript
// 好的Mock实践
const mockUserService = {
  getUser: jest.fn(),
  createUser: jest.fn(),
  updateUser: jest.fn()
};

// 避免过度Mock
// 不要Mock你正在测试的代码
// 优先Mock外部依赖和副作用
```

请开始智能测试生成。