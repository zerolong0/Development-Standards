#!/usr/bin/env python3
"""
AI开发知识文档库简单服务器
不依赖第三方库，使用Python内置功能
"""

import http.server
import socketserver
import os
import sys
import webbrowser
import threading
import time
import re
from pathlib import Path
from urllib.parse import unquote

# 配置
PORT = 1024
WIKI_DIR = Path(__file__).parent.parent

# 简单的Markdown到HTML转换
def simple_markdown_to_html(md_content):
    """简单的Markdown转HTML，不依赖第三方库"""
    html = md_content
    
    # 标题
    html = re.sub(r'^# (.*)', r'<h1>\1</h1>', html, flags=re.MULTILINE)
    html = re.sub(r'^## (.*)', r'<h2>\1</h2>', html, flags=re.MULTILINE)
    html = re.sub(r'^### (.*)', r'<h3>\1</h3>', html, flags=re.MULTILINE)
    html = re.sub(r'^#### (.*)', r'<h4>\1</h4>', html, flags=re.MULTILINE)
    
    # 粗体
    html = re.sub(r'\*\*(.*?)\*\*', r'<strong>\1</strong>', html)
    
    # 斜体
    html = re.sub(r'\*(.*?)\*', r'<em>\1</em>', html)
    
    # 内联代码
    html = re.sub(r'`([^`]+)`', r'<code>\1</code>', html)
    
    # 链接
    html = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', html)
    
    # 代码块
    html = re.sub(r'```(\w*)\n(.*?)\n```', r'<pre><code class="language-\1">\2</code></pre>', html, flags=re.DOTALL)
    
    # 无序列表
    html = re.sub(r'^- (.*)', r'<li>\1</li>', html, flags=re.MULTILINE)
    html = re.sub(r'(<li>.*</li>)', r'<ul>\1</ul>', html, flags=re.DOTALL)
    
    # 有序列表  
    html = re.sub(r'^\d+\. (.*)', r'<li>\1</li>', html, flags=re.MULTILINE)
    
    # 表格（简单处理）
    lines = html.split('\n')
    in_table = False
    new_lines = []
    
    for line in lines:
        if '|' in line and line.strip().startswith('|'):
            if not in_table:
                new_lines.append('<table border="1">')
                in_table = True
            
            cells = [cell.strip() for cell in line.split('|')[1:-1]]
            if all(cell.strip().replace('-', '') == '' for cell in cells):
                continue  # Skip separator line
            
            if line.count('**') > 0:  # Header row
                new_lines.append('<tr>' + ''.join(f'<th>{cell}</th>' for cell in cells) + '</tr>')
            else:
                new_lines.append('<tr>' + ''.join(f'<td>{cell}</td>' for cell in cells) + '</tr>')
        else:
            if in_table:
                new_lines.append('</table>')
                in_table = False
            new_lines.append(line)
    
    if in_table:
        new_lines.append('</table>')
    
    # 段落
    html = '\n'.join(new_lines)
    paragraphs = html.split('\n\n')
    html_paragraphs = []
    
    for p in paragraphs:
        p = p.strip()
        if p and not p.startswith('<'):
            p = f'<p>{p}</p>'
        html_paragraphs.append(p)
    
    return '\n'.join(html_paragraphs)

TEMPLATE = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - AI开发知识文档库</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f8f9fa;
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }}
        
        .header h1 {{
            margin: 0;
            font-size: 2.5em;
        }}
        
        .header p {{
            margin: 10px 0 0 0;
            opacity: 0.9;
        }}
        
        .content {{
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }}
        
        .nav-bar {{
            background: #2c3e50;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }}
        
        .nav-bar a {{
            color: #ecf0f1;
            text-decoration: none;
            margin-right: 20px;
            padding: 8px 16px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }}
        
        .nav-bar a:hover {{
            background-color: #34495e;
        }}
        
        .nav-bar a.home {{
            background-color: #3498db;
        }}
        
        h1, h2, h3, h4, h5, h6 {{
            color: #2c3e50;
            margin-top: 30px;
            margin-bottom: 15px;
        }}
        
        h1 {{
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
        }}
        
        h2 {{
            border-bottom: 2px solid #e74c3c;
            padding-bottom: 8px;
        }}
        
        h3 {{
            color: #e67e22;
        }}
        
        code {{
            background: #f1f2f6;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Monaco', 'Menlo', monospace;
            font-size: 0.9em;
        }}
        
        pre {{
            background: #2d3748;
            color: #e2e8f0;
            padding: 20px;
            border-radius: 8px;
            overflow-x: auto;
            margin: 20px 0;
        }}
        
        pre code {{
            background: none;
            padding: 0;
            color: inherit;
        }}
        
        table {{
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }}
        
        th, td {{
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }}
        
        th {{
            background: #3498db;
            color: white;
        }}
        
        tr:nth-child(even) {{
            background: #f2f2f2;
        }}
        
        ul, ol {{
            margin: 15px 0;
            padding-left: 30px;
        }}
        
        li {{
            margin: 8px 0;
        }}
        
        a {{
            color: #3498db;
            text-decoration: none;
        }}
        
        a:hover {{
            text-decoration: underline;
        }}
        
        .footer {{
            margin-top: 50px;
            padding: 20px;
            text-align: center;
            color: #7f8c8d;
            border-top: 1px solid #ecf0f1;
        }}
        
        .file-tree {{
            background: #f8f9fa;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin: 20px 0;
            font-family: monospace;
        }}
        
        @media (max-width: 768px) {{
            body {{
                padding: 10px;
            }}
            .header h1 {{
                font-size: 2em;
            }}
            .content {{
                padding: 20px;
            }}
        }}
    </style>
</head>
<body>
    <div class="header">
        <h1>🤖 AI开发知识文档库</h1>
        <p>AI Agent产品开发 · 最佳实践 · 工程方法论</p>
    </div>
    
    <div class="nav-bar">
        <a href="/" class="home">🏠 首页</a>
        <a href="/docs/AI_AGENT_DEVELOPMENT_GUIDE.md">📖 Agent开发指南</a>
        <a href="/templates/AGENT_PRD_TEMPLATE.md">📝 PRD模板</a>
        <a href="/examples/Insurance-Agent-PRD-Example.md">💼 实践案例</a>
        <a href="/docs/">📚 所有文档</a>
    </div>
    
    <div class="content">
        {content}
    </div>
    
    <div class="footer">
        <p>📄 AI开发知识文档库 · 🚀 让AI Agent开发更简单 · ⏰ 最后更新: 2025-08-29</p>
        <p>💡 基于Claude Code实际经验构建 · 🌟 持续更新中</p>
    </div>
</body>
</html>
"""

class SimpleWikiHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WIKI_DIR), **kwargs)
    
    def do_GET(self):
        """处理GET请求"""
        path = unquote(self.path.lstrip('/'))
        
        # 首页重定向
        if path == '' or path == 'index.html':
            path = 'wiki-index.md'
        
        full_path = WIKI_DIR / path
        
        try:
            if path.endswith('.md') and full_path.exists():
                self.render_markdown(full_path)
            elif full_path.is_dir():
                self.render_directory(full_path)
            else:
                super().do_GET()
        except Exception as e:
            self.send_error(500, f"Internal server error: {e}")
    
    def render_markdown(self, file_path):
        """渲染Markdown文件"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            html_content = simple_markdown_to_html(content)
            title = file_path.stem.replace('-', ' ').replace('_', ' ').title()
            
            # 生成完整HTML
            html = TEMPLATE.format(
                title=title,
                content=html_content
            )
            
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()
            self.wfile.write(html.encode('utf-8'))
            
        except Exception as e:
            self.send_error(500, f"Error rendering markdown: {e}")
    
    def render_directory(self, dir_path):
        """渲染目录列表"""
        try:
            files = []
            dirs = []
            
            for item in sorted(dir_path.iterdir()):
                if item.name.startswith('.'):
                    continue
                    
                if item.is_dir():
                    dirs.append(f'📁 <a href="{self.path.rstrip("/")}/{item.name}/">{item.name}/</a>')
                elif item.suffix == '.md':
                    files.append(f'📄 <a href="{self.path.rstrip("/")}/{item.name}">{item.name}</a>')
                else:
                    files.append(f'📎 <a href="{self.path.rstrip("/")}/{item.name}">{item.name}</a>')
            
            content = f"""
            <h1>📂 目录: {dir_path.name}</h1>
            <div class="file-tree">
            {'<br>'.join(dirs + files)}
            </div>
            """
            
            html = TEMPLATE.format(
                title=f"目录 - {dir_path.name}",
                content=content
            )
            
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.end_headers()
            self.wfile.write(html.encode('utf-8'))
            
        except Exception as e:
            self.send_error(500, f"Error listing directory: {e}")

def open_browser():
    """延迟打开浏览器"""
    time.sleep(1)
    webbrowser.open(f'http://localhost:{PORT}')

def main():
    """启动wiki服务器"""
    # 切换到wiki目录
    os.chdir(WIKI_DIR)
    
    # 启动服务器
    with socketserver.TCPServer(("", PORT), SimpleWikiHandler) as httpd:
        print(f"""
🚀 AI开发知识文档库已启动！

📍 本地地址: http://localhost:{PORT}
📁 文档目录: {WIKI_DIR}
🎯 主要功能:
   • Markdown自动渲染（内置转换）
   • 响应式设计
   • 智能链接导航
   • 目录自动生成

📖 快速导航:
   • 首页: http://localhost:{PORT}/
   • Agent开发指南: http://localhost:{PORT}/docs/AI_AGENT_DEVELOPMENT_GUIDE.md
   • PRD模板: http://localhost:{PORT}/templates/AGENT_PRD_TEMPLATE.md
   • 实践案例: http://localhost:{PORT}/examples/Insurance-Agent-PRD-Example.md

💡 使用提示:
   • 支持.md文件直接访问
   • 目录自动生成文件列表
   • 所有链接都可点击导航

🛑 停止服务: Ctrl+C
        """)
        
        # 自动打开浏览器
        browser_thread = threading.Thread(target=open_browser)
        browser_thread.daemon = True
        browser_thread.start()
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n\n👋 感谢使用AI开发知识文档库！")

if __name__ == "__main__":
    main()