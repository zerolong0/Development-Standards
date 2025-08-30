# API文档自动生成器

基于代码分析自动生成完整的API文档，支持多种格式输出。

## 使用方式

请为以下API代码生成完整的文档: $ARGUMENTS

## 🎯 文档生成范围

### API文档类型
1. **RESTful API文档**
   - 端点列表和描述
   - 请求/响应格式
   - 状态码说明
   - 认证授权方式

2. **GraphQL API文档**
   - Schema定义
   - Query和Mutation
   - 类型系统说明
   - 订阅功能文档

3. **WebSocket API文档**
   - 连接建立流程
   - 消息格式规范
   - 事件类型说明
   - 错误处理机制

## 📝 文档格式标准

### OpenAPI 3.0 规范
```yaml
openapi: 3.0.3
info:
  title: [API名称]
  description: [API描述]
  version: 1.0.0
  contact:
    name: [联系人]
    email: [邮箱]
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://api.example.com/v1
    description: 生产环境
  - url: https://staging-api.example.com/v1
    description: 测试环境

paths:
  /users:
    get:
      summary: 获取用户列表
      description: 分页获取系统中的用户列表
      tags:
        - 用户管理
      parameters:
        - name: page
          in: query
          description: 页码
          required: false
          schema:
            type: integer
            default: 1
            minimum: 1
        - name: limit
          in: query
          description: 每页数量
          required: false
          schema:
            type: integer
            default: 20
            minimum: 1
            maximum: 100
      responses:
        '200':
          description: 成功返回用户列表
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '400':
          description: 请求参数错误
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    User:
      type: object
      required:
        - id
        - username
        - email
      properties:
        id:
          type: string
          format: uuid
          description: 用户唯一标识
          example: "123e4567-e89b-12d3-a456-426614174000"
        username:
          type: string
          description: 用户名
          minLength: 3
          maxLength: 50
          example: "johndoe"
        email:
          type: string
          format: email
          description: 邮箱地址
          example: "john@example.com"
        created_at:
          type: string
          format: date-time
          description: 创建时间
          example: "2025-08-30T10:30:00Z"
    
    Pagination:
      type: object
      properties:
        page:
          type: integer
          description: 当前页码
        limit:
          type: integer
          description: 每页数量
        total:
          type: integer
          description: 总记录数
        total_pages:
          type: integer
          description: 总页数
    
    Error:
      type: object
      properties:
        error:
          type: string
          description: 错误类型
        message:
          type: string
          description: 错误信息
        details:
          type: array
          items:
            type: string
          description: 详细错误信息

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    apiKey:
      type: apiKey
      in: header
      name: X-API-Key

security:
  - bearerAuth: []
```

### Markdown文档格式
```markdown
# [API名称] 接口文档

## 概述

**Base URL**: `https://api.example.com/v1`  
**认证方式**: Bearer Token (JWT)  
**响应格式**: JSON  
**字符编码**: UTF-8  

## 认证

所有API请求需要在请求头中包含访问令牌：

```http
Authorization: Bearer your-jwt-token
```

## 通用响应格式

### 成功响应
```json
{
  "data": { ... },
  "message": "操作成功",
  "status": "success"
}
```

### 错误响应
```json
{
  "error": "VALIDATION_ERROR",
  "message": "请求参数验证失败", 
  "details": ["用户名不能为空", "邮箱格式不正确"],
  "status": "error"
}
```

## 状态码说明

| 状态码 | 说明 | 描述 |
|-------|------|------|
| 200 | OK | 请求成功 |
| 201 | Created | 资源创建成功 |
| 400 | Bad Request | 请求参数错误 |
| 401 | Unauthorized | 未认证或token无效 |
| 403 | Forbidden | 权限不足 |
| 404 | Not Found | 资源不存在 |
| 429 | Too Many Requests | 请求频率超限 |
| 500 | Internal Server Error | 服务器内部错误 |

## 用户管理 API

### 获取用户列表

**请求**
```http
GET /api/users?page=1&limit=20
Authorization: Bearer your-jwt-token
```

**参数**
- `page` (可选): 页码，默认为1
- `limit` (可选): 每页数量，默认为20，最大100
- `search` (可选): 搜索关键词
- `role` (可选): 用户角色筛选

**响应**
```json
{
  "data": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "username": "johndoe", 
      "email": "john@example.com",
      "role": "user",
      "created_at": "2025-08-30T10:30:00Z",
      "updated_at": "2025-08-30T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "total_pages": 8
  },
  "status": "success"
}
```

### 创建用户

**请求**
```http
POST /api/users
Content-Type: application/json
Authorization: Bearer your-jwt-token

{
  "username": "newuser",
  "email": "newuser@example.com",
  "password": "securepassword123",
  "role": "user"
}
```

**验证规则**
- `username`: 必填，3-50字符，只能包含字母、数字、下划线
- `email`: 必填，有效的邮箱格式，系统内唯一
- `password`: 必填，最少8位，包含大小写字母和数字
- `role`: 可选，枚举值: `user`, `admin`, `moderator`

**响应**
```json
{
  "data": {
    "id": "456e7890-e89b-12d3-a456-426614174000",
    "username": "newuser",
    "email": "newuser@example.com", 
    "role": "user",
    "created_at": "2025-08-30T11:00:00Z"
  },
  "message": "用户创建成功",
  "status": "success"
}
```

## 代码示例

### JavaScript/TypeScript
```typescript
// API客户端示例
class APIClient {
  private baseURL = 'https://api.example.com/v1';
  private token: string;

  constructor(token: string) {
    this.token = token;
  }

  private async request<T>(
    endpoint: string, 
    options: RequestInit = {}
  ): Promise<T> {
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }

    return response.json();
  }

  async getUsers(params?: {
    page?: number;
    limit?: number;
    search?: string;
  }): Promise<UserListResponse> {
    const query = new URLSearchParams(params as any).toString();
    return this.request(`/users?${query}`);
  }

  async createUser(userData: CreateUserRequest): Promise<UserResponse> {
    return this.request('/users', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }
}

// 类型定义
interface User {
  id: string;
  username: string;
  email: string;
  role: 'user' | 'admin' | 'moderator';
  created_at: string;
  updated_at: string;
}

interface UserListResponse {
  data: User[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    total_pages: number;
  };
  status: 'success';
}
```

### Python
```python
import requests
from typing import Optional, Dict, Any

class APIClient:
    def __init__(self, token: str, base_url: str = "https://api.example.com/v1"):
        self.base_url = base_url
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[Any, Any]:
        response = requests.request(
            method, 
            f"{self.base_url}{endpoint}",
            headers=self.headers,
            **kwargs
        )
        response.raise_for_status()
        return response.json()
    
    def get_users(self, page: int = 1, limit: int = 20, 
                  search: Optional[str] = None) -> Dict[Any, Any]:
        params = {"page": page, "limit": limit}
        if search:
            params["search"] = search
        
        return self._request("GET", "/users", params=params)
    
    def create_user(self, username: str, email: str, 
                   password: str, role: str = "user") -> Dict[Any, Any]:
        data = {
            "username": username,
            "email": email,
            "password": password,
            "role": role
        }
        return self._request("POST", "/users", json=data)

# 使用示例
client = APIClient("your-jwt-token")
users = client.get_users(page=1, limit=10)
new_user = client.create_user("testuser", "test@example.com", "password123")
```

## 错误处理

### 常见错误码

| 错误码 | HTTP状态码 | 描述 | 解决方案 |
|-------|-----------|------|---------|
| VALIDATION_ERROR | 400 | 请求参数验证失败 | 检查请求参数格式和必填项 |
| UNAUTHORIZED | 401 | 认证失败或token过期 | 重新登录获取有效token |
| FORBIDDEN | 403 | 权限不足 | 联系管理员分配相应权限 |
| NOT_FOUND | 404 | 请求的资源不存在 | 检查资源ID是否正确 |
| RATE_LIMIT_EXCEEDED | 429 | 请求频率超出限制 | 降低请求频率，稍后重试 |

### 重试策略建议

```typescript
async function requestWithRetry<T>(
  requestFn: () => Promise<T>,
  maxRetries: number = 3,
  delay: number = 1000
): Promise<T> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await requestFn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      
      // 对于服务器错误或网络错误进行重试
      if (error.status >= 500 || error.code === 'NETWORK_ERROR') {
        await new Promise(resolve => setTimeout(resolve, delay * Math.pow(2, i)));
        continue;
      }
      
      // 对于客户端错误不进行重试
      throw error;
    }
  }
}
```

## 更新日志

### v1.0.0 (2025-08-30)
- 初始版本发布
- 实现用户管理基础功能
- 支持JWT认证
- 添加请求频率限制

---

**技术支持**: api-support@example.com  
**文档更新**: 2025-08-30  
**API版本**: v1.0.0
```

## 🔧 代码扫描和文档生成

### 自动扫描API端点
```typescript
// 扫描Express.js路由
function scanExpressRoutes(app: Express.Application): APIEndpoint[] {
  const routes: APIEndpoint[] = [];
  
  app._router.stack.forEach((layer: any) => {
    if (layer.route) {
      const route = layer.route;
      const methods = Object.keys(route.methods);
      
      methods.forEach(method => {
        routes.push({
          method: method.toUpperCase(),
          path: route.path,
          middleware: layer.handle.name || 'anonymous',
          params: extractPathParams(route.path),
          description: extractJSDocComments(layer.handle)
        });
      });
    }
  });
  
  return routes;
}

// 扫描FastAPI路由
def scan_fastapi_routes(app: FastAPI) -> List[APIEndpoint]:
    routes = []
    for route in app.routes:
        if hasattr(route, 'methods'):
            for method in route.methods:
                routes.append({
                    'method': method,
                    'path': route.path,
                    'name': route.name,
                    'summary': getattr(route, 'summary', ''),
                    'description': getattr(route, 'description', ''),
                    'tags': getattr(route, 'tags', [])
                })
    return routes
```

### 类型定义提取
```typescript
// 从TypeScript类型生成JSON Schema
function generateSchemaFromType(typeName: string): JSONSchema {
  // 使用typescript-json-schema库
  const program = ts.createProgram([filePath], compilerOptions);
  const generator = JsonSchemaGenerator.fromProgram(program);
  return generator.getSchemaForSymbol(typeName);
}

// 示例输出
{
  "type": "object",
  "properties": {
    "id": {"type": "string", "format": "uuid"},
    "username": {"type": "string", "minLength": 3, "maxLength": 50},
    "email": {"type": "string", "format": "email"}
  },
  "required": ["id", "username", "email"]
}
```

## 📊 文档生成输出选项

### 1. Swagger UI 交互文档
- 在线API测试界面
- 实时请求/响应验证
- 认证配置支持
- 多环境切换

### 2. Postman Collection
- 完整的请求集合
- 环境变量配置
- 自动化测试脚本
- 团队协作支持

### 3. 静态HTML文档  
- 离线可访问文档
- 搜索功能支持
- 响应式设计
- PDF导出功能

### 4. Markdown文档
- Git版本控制友好
- 易于维护和更新
- 支持代码高亮
- 可集成到文档站点

请开始API文档生成。