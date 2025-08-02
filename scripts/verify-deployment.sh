#!/bin/bash

# 部署验证脚本

echo "🔍 验证 Uniswap V2 子图部署状态..."

# 检查服务状态
echo "📡 检查服务状态..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ 所有Docker服务正在运行"
else
    echo "❌ Docker服务未运行"
    exit 1
fi

# 检查Graph节点
echo "🌐 检查Graph节点..."
if curl -s http://localhost:8000 > /dev/null; then
    echo "✅ Graph节点可访问"
else
    echo "❌ Graph节点不可访问"
    exit 1
fi

# 测试子图查询
echo "🔍 测试子图查询..."

echo "1. 测试交易对查询..."
PAIRS_RESPONSE=$(curl -s -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \
  -H "Content-Type: application/json" \
  -d '{"query": "{ pairs(first: 5) { id token0 token1 } }"}')

if echo "$PAIRS_RESPONSE" | grep -q "data"; then
    echo "✅ 交易对查询成功"
else
    echo "❌ 交易对查询失败"
fi

echo "2. 测试交换事件查询..."
SWAPS_RESPONSE=$(curl -s -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \
  -H "Content-Type: application/json" \
  -d '{"query": "{ swaps(first: 5) { id pair sender } }"}')

if echo "$SWAPS_RESPONSE" | grep -q "data"; then
    echo "✅ 交换事件查询成功"
else
    echo "❌ 交换事件查询失败"
fi

echo "3. 测试代币查询..."
TOKENS_RESPONSE=$(curl -s -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \
  -H "Content-Type: application/json" \
  -d '{"query": "{ tokens(first: 5) { id symbol name } }"}')

if echo "$TOKENS_RESPONSE" | grep -q "data"; then
    echo "✅ 代币查询成功"
else
    echo "❌ 代币查询失败"
fi

# 检查Graph节点日志
echo "📊 检查Graph节点状态..."
RECENT_LOGS=$(docker-compose logs --tail 10 graph-node)
if echo "$RECENT_LOGS" | grep -q "subgraph"; then
    echo "✅ Graph节点正在处理子图"
else
    echo "⚠️ 未检测到子图活动"
fi

echo ""
echo "🎉 部署验证完成！"
echo ""
echo "📝 访问信息："
echo "- Graph Playground: http://localhost:8000"
echo "- 子图端点: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor"
echo "- 查询端点: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql"
echo ""
echo "📊 示例查询："
echo "curl -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"query\": \"{ pairs(first: 10) { id token0 token1 reserve0 reserve1 } }\"}'" 