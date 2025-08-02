#!/bin/bash

# 部署检查脚本

echo "🔍 检查 Uniswap V2 子图部署状态..."

# 检查 Graph Node 是否运行
echo "📡 检查 Graph Node 状态..."
if curl -s http://localhost:8000 > /dev/null; then
    echo "✅ Graph Node 正在运行"
else
    echo "❌ Graph Node 未运行，请先启动服务"
    echo "运行: ./scripts/start.sh"
    exit 1
fi

# 检查 IPFS 是否运行
echo "📦 检查 IPFS 状态..."
if curl -s http://localhost:5001 > /dev/null; then
    echo "✅ IPFS 正在运行"
else
    echo "❌ IPFS 未运行"
fi

# 检查 PostgreSQL 是否运行
echo "🗄️ 检查 PostgreSQL 状态..."
if docker ps | grep -q postgres; then
    echo "✅ PostgreSQL 正在运行"
else
    echo "❌ PostgreSQL 未运行"
fi

# 检查子图是否已创建
echo "📊 检查子图状态..."
if curl -s "http://localhost:8000/subgraphs/name/uni-swap-v2-monitor" > /dev/null; then
    echo "✅ 子图已创建"
else
    echo "⚠️ 子图未创建，运行: npm run create-local"
fi

# 检查构建状态
echo "🔨 检查构建状态..."
if [ -d "build" ]; then
    echo "✅ 项目已构建"
else
    echo "❌ 项目未构建，运行: npm run build"
fi

echo ""
echo "📝 下一步操作："
echo "1. 如果子图未创建: npm run create-local"
echo "2. 如果项目未构建: npm run build"
echo "3. 部署子图: npm run deploy-local"
echo "4. 访问 Playground: http://localhost:8000" 