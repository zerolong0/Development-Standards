#!/bin/bash

# AI开发知识文档库启动脚本

echo "🚀 启动AI开发知识文档库..."

# 检查Python
if ! command -v python3 &> /dev/null; then
    echo "❌ 需要Python3环境"
    exit 1
fi

# 检查并安装markdown依赖
if ! python3 -c "import markdown" 2> /dev/null; then
    echo "📦 安装markdown依赖..."
    pip3 install markdown
fi

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo "📁 文档目录: $SCRIPT_DIR"
echo "🌐 启动本地服务器..."

# 启动Python服务器
python3 scripts/start-wiki.py