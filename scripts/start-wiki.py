#!/usr/bin/env python3
"""
AI开发知识文档库本地服务器
基于Python内置HTTP服务器，支持Markdown渲染
"""

import http.server
import socketserver
import os
import sys
import webbrowser
import threading
import time
import markdown
from pathlib import Path

# 配置
PORT = 1024
WIKI_DIR = Path(__file__).parent.parent
TEMPLATE = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - AI开发知识文档库</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.25.0/themes/prism.min.css" rel="stylesheet">
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
        
        blockquote {{
            border-left: 4px solid #3498db;
            padding: 10px 20px;
            margin: 20px 0;
            background: #f8f9ff;
            font-style: italic;
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
        
        .emoji {{
            font-size: 1.2em;
        }}
        
        .footer {{
            margin-top: 50px;
            padding: 20px;
            text-align: center;
            color: #7f8c8d;
            border-top: 1px solid #ecf0f1;
        }}
        
        .badge {{
            display: inline-block;
            padding: 4px 8px;
            background: #e74c3c;
            color: white;
            border-radius: 12px;
            font-size: 0.8em;
            margin-left: 10px;
        }}
        
        .toc {{
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }}
        
        .toc h3 {{
            margin-top: 0;
            color: #495057;
        }}
        
        .toc ul {{
            margin: 0;
            padding-left: 20px;
        }}
        
        .toc li {{
            margin: 8px 0;
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.25.0/components/prism-core.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.25.0/plugins/autoloader/prism-autoloader.min.js"></script>
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
    
    <script>
        // 自动生成目录
        document.addEventListener('DOMContentLoaded', function() {{
            const headers = document.querySelectorAll('h2, h3');
            if (headers.length > 3) {{
                let toc = '<div class="toc"><h3>📋 目录</h3><ul>';
                headers.forEach(function(header, index) {{
                    const id = 'header-' + index;
                    header.id = id;
                    const level = header.tagName === 'H2' ? '' : '&nbsp;&nbsp;';
                    toc += `<li>${{level}}<a href="#${{id}}">${{header.textContent}}</a></li>`;
                }});
                toc += '</ul></div>';
                
                const firstH2 = document.querySelector('h2');
                if (firstH2) {{
                    firstH2.insertAdjacentHTML('beforebegin', toc);
                }}
            }}
        }});
    </script>
</body>
</html>
"""

class WikiHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WIKI_DIR), **kwargs)
    
    def do_GET(self):
        """处理GET请求，支持Markdown渲染"""
        path = self.path.lstrip('/')
        
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
            
            # 配置Markdown扩展
            md = markdown.Markdown(extensions=[
                'toc',
                'tables', 
                'fenced_code',
                'codehilite',
                'attr_list',
                'def_list',
                'footnotes',
                'meta'
            ], extension_configs={
                'codehilite': {
                    'css_class': 'highlight',
                    'use_pygments': False
                },
                'toc': {
                    'permalink': True
                }
            })
            
            html_content = md.convert(content)
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
    try:
        # 检查markdown库
        import markdown
    except ImportError:
        print("❌ 缺少依赖: pip install markdown")
        sys.exit(1)
    
    # 切换到wiki目录
    os.chdir(WIKI_DIR)
    
    # 启动服务器
    with socketserver.TCPServer(("", PORT), WikiHandler) as httpd:
        print(f"""
🚀 AI开发知识文档库已启动！

📍 本地地址: http://localhost:{PORT}
📁 文档目录: {WIKI_DIR}
🎯 主要功能:
   • Markdown自动渲染
   • 响应式设计
   • 自动目录生成
   • 代码语法高亮

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
            print("💡 如有建议，欢迎反馈改进")

if __name__ == "__main__":
    main()