# 上下文管理策略

> 基于Claude Code的智能上下文管理和优化技术

## 1. 上下文管理核心原理

### 1.1 上下文分层模型
```
┌─────────────────────────────────┐
│        系统上下文 (System)        │  环境信息、配置、权限
├─────────────────────────────────┤
│        会话上下文 (Session)       │  用户信息、项目状态
├─────────────────────────────────┤
│        任务上下文 (Task)         │  当前任务、目标、约束
├─────────────────────────────────┤
│        工具上下文 (Tool)         │  工具状态、执行历史
└─────────────────────────────────┘
```

### 1.2 Token效率优化策略
**Claude Code的92%压缩效率**：
- **智能摘要**：保留关键信息，丢弃冗余细节
- **上下文分片**：按相关性分组，按需加载
- **动态裁剪**：根据任务类型选择相关上下文
- **层次压缩**：不同重要级别采用不同压缩比

## 2. 上下文压缩技术

### 2.1 /compact命令实现
```python
class ContextCompressor:
    def __init__(self):
        self.compression_ratio = 0.92  # Claude Code实测数据
        self.summarization_model = "haiku-3.5"
    
    async def compress_context(self, conversation_history: List[Message]) -> str:
        # 1. 提取关键信息
        key_points = self.extract_key_points(conversation_history)
        
        # 2. 生成压缩摘要
        summary_prompt = self.build_summary_prompt(key_points)
        compressed_context = await self.call_llm(
            model=self.summarization_model,
            prompt=summary_prompt,
            max_tokens=len(conversation_history) * 0.08  # 8%原始长度
        )
        
        # 3. 验证信息完整性
        if self.validate_compression_quality(compressed_context, conversation_history):
            return compressed_context
        else:
            return self.fallback_compression(conversation_history)
```

### 2.2 分层压缩策略
```yaml
压缩层级:
  系统信息: 
    压缩比: 95%
    保留: 环境变量、工具定义、用户权限
  
  历史对话:
    压缩比: 90%
    保留: 重要决策、错误教训、成功模式
  
  当前任务:
    压缩比: 20%
    保留: 详细需求、约束条件、进度状态
  
  工具输出:
    压缩比: 95%
    保留: 核心结果、错误信息
```

## 3. 动态上下文注入

### 3.1 环境感知注入
```python
class DynamicContextInjector:
    def inject_environment_context(self, base_context: Context) -> Context:
        injections = {
            'git_status': self.get_git_status() if self.is_git_repo() else None,
            'open_files': self.get_ide_open_files() if self.is_ide_mode() else None,
            'project_structure': self.analyze_project_structure(),
            'recent_changes': self.get_recent_file_changes(),
            'active_branches': self.get_active_branches()
        }
        
        # 只注入相关信息
        for key, value in injections.items():
            if value and self.is_relevant_to_task(key, base_context.current_task):
                base_context.add_dynamic_info(key, value)
        
        return base_context
```

### 3.2 智能上下文路由
```python
class ContextRouter:
    def route_context_for_task(self, full_context: Context, task: Task) -> Context:
        relevance_scores = {}
        
        # 计算每个上下文片段的相关性
        for fragment in full_context.fragments:
            score = self.calculate_relevance(
                fragment=fragment,
                task=task,
                factors=['semantic_similarity', 'temporal_proximity', 'tool_overlap']
            )
            relevance_scores[fragment.id] = score
        
        # 选择最相关的片段
        selected_fragments = self.select_top_fragments(
            relevance_scores, 
            max_tokens=task.context_budget
        )
        
        return Context(fragments=selected_fragments)
```

## 4. 记忆持久化

### 4.1 Todo短期记忆系统
```python
class TodoMemoryManager:
    def __init__(self):
        self.storage_path = "~/.claude/todos/"
        self.memory_ttl = 86400  # 24小时
    
    def persist_todo_state(self, session_id: str, todos: List[Todo]):
        memory_file = f"{self.storage_path}/{session_id}.json"
        
        memory_data = {
            'session_id': session_id,
            'timestamp': time.time(),
            'todos': [todo.to_dict() for todo in todos],
            'context_snapshot': self.capture_context_snapshot()
        }
        
        with open(memory_file, 'w') as f:
            json.dump(memory_data, f, indent=2)
    
    def restore_todo_state(self, session_id: str) -> Optional[List[Todo]]:
        memory_file = f"{self.storage_path}/{session_id}.json"
        
        if not os.path.exists(memory_file):
            return None
        
        with open(memory_file, 'r') as f:
            memory_data = json.load(f)
        
        # 检查是否过期
        if time.time() - memory_data['timestamp'] > self.memory_ttl:
            os.remove(memory_file)
            return None
        
        return [Todo.from_dict(todo_dict) for todo_dict in memory_data['todos']]
```

### 4.2 知识图谱构建
```python
class KnowledgeGraphBuilder:
    def build_project_knowledge_graph(self, project_path: str) -> KnowledgeGraph:
        graph = KnowledgeGraph()
        
        # 构建文件关系图
        file_dependencies = self.analyze_file_dependencies(project_path)
        for file_path, dependencies in file_dependencies.items():
            file_node = graph.add_file_node(file_path)
            for dep in dependencies:
                dep_node = graph.add_file_node(dep)
                graph.add_edge(file_node, dep_node, 'depends_on')
        
        # 构建功能模块图
        modules = self.identify_functional_modules(project_path)
        for module in modules:
            module_node = graph.add_module_node(module)
            for file_path in module.files:
                file_node = graph.get_file_node(file_path)
                graph.add_edge(module_node, file_node, 'contains')
        
        return graph
```

## 5. 上下文优先级管理

### 5.1 重要性评分算法
```python
class ContextImportanceScorer:
    def score_context_fragment(self, fragment: ContextFragment, current_task: Task) -> float:
        scores = {
            'recency': self.calculate_recency_score(fragment.timestamp),
            'relevance': self.calculate_semantic_relevance(fragment.content, current_task),
            'success_impact': self.calculate_success_impact(fragment),
            'user_interaction': self.calculate_user_interaction_score(fragment),
            'error_prevention': self.calculate_error_prevention_score(fragment)
        }
        
        weights = {
            'recency': 0.2,
            'relevance': 0.4,
            'success_impact': 0.2,
            'user_interaction': 0.1,
            'error_prevention': 0.1
        }
        
        return sum(scores[key] * weights[key] for key in scores)
```

### 5.2 自适应上下文窗口
```python
class AdaptiveContextWindow:
    def __init__(self):
        self.base_window_size = 128_000  # tokens
        self.expansion_factor = 1.5
        self.compression_factor = 0.7
    
    def adjust_window_size(self, task_complexity: float, available_resources: dict) -> int:
        # 根据任务复杂度动态调整窗口大小
        if task_complexity > 0.8:  # 高复杂度任务
            target_size = int(self.base_window_size * self.expansion_factor)
        elif task_complexity < 0.3:  # 简单任务
            target_size = int(self.base_window_size * self.compression_factor)
        else:
            target_size = self.base_window_size
        
        # 考虑可用资源限制
        max_affordable_size = self.calculate_max_affordable_size(available_resources)
        
        return min(target_size, max_affordable_size)
```