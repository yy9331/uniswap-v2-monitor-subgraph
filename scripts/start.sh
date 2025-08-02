#!/bin/bash

# 快速启动脚本

echo "🚀 启动 Uniswap V2 子图项目..."

# 检查是否已经构建
if [ ! -d "build" ]; then
    echo "📦 项目未构建，正在构建..."
    npm run codegen
    npm run build
fi

# 启动 Docker 服务
echo "🐳 启动 Docker 服务..."
docker-compose up -d

echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "🔍 检查服务状态..."
if curl -s http://localhost:8000 > /dev/null; then
    echo "✅ 服务已启动"
    echo ""
    echo "📝 可用操作："
    echo "1. 创建子图: npm run create-local"
    echo "2. 部署子图: npm run deploy-local"
    echo "3. 访问 Playground: http://localhost:8000"
    echo "4. 查看日志: docker-compose logs -f"
else
    echo "❌ 服务启动失败"
    docker-compose logs graph-node
fi 