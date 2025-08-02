#!/bin/bash

# Uniswap V2 子图项目设置脚本

echo "🚀 开始设置 Uniswap V2 子图项目..."

# 检查 Node.js 版本
echo "📋 检查 Node.js 版本..."
node_version=$(node --version)
echo "当前 Node.js 版本: $node_version"

# 检查 Docker 是否运行
echo "🐳 检查 Docker 状态..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请启动 Docker 后重试"
    exit 1
fi
echo "✅ Docker 正在运行"

# 安装依赖
echo "📦 安装项目依赖..."
npm install

# 安装 Graph CLI（如果未安装）
echo "🔧 检查 Graph CLI..."
if ! command -v graph &> /dev/null; then
    echo "📥 安装 Graph CLI..."
    npm install -g @graphprotocol/graph-cli
else
    echo "✅ Graph CLI 已安装"
fi

# 生成代码
echo "🔨 生成代码..."
npm run codegen

# 构建项目
echo "🏗️ 构建项目..."
npm run build

# 启动 Docker 服务
echo "🐳 启动 Docker 服务..."
docker-compose up -d

echo "⏳ 等待服务启动..."
sleep 30

# 检查服务状态
echo "🔍 检查服务状态..."
if curl -s http://localhost:8000 > /dev/null; then
    echo "✅ Graph Node 已启动"
else
    echo "❌ Graph Node 启动失败，请检查 Docker 日志"
    docker-compose logs graph-node
    exit 1
fi

echo "🎉 项目设置完成！"
echo ""
echo "📝 下一步操作："
echo "1. 创建本地子图: npm run create-local"
echo "2. 部署子图: npm run deploy-local"
echo "3. 访问 Graph Playground: http://localhost:8000"
echo ""
echo "🔧 常用命令："
echo "- 查看日志: docker-compose logs -f"
echo "- 停止服务: docker-compose down"
echo "- 重新构建: npm run build" 