#!/bin/bash

# 子图测试脚本

echo "🧪 测试 Uniswap V2 子图..."

# 检查Graph节点是否运行
echo "📡 检查Graph节点状态..."
if curl -s http://localhost:8000 > /dev/null; then
    echo "✅ Graph节点正在运行"
else
    echo "❌ Graph节点未运行"
    exit 1
fi

# 测试GraphQL查询
echo "🔍 测试GraphQL查询..."

# 查询所有交易对
echo "查询交易对..."
curl -s -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ pairs(first: 5) { id token0 token1 reserve0 reserve1 } }"
  }' | jq '.'

# 查询最近的交换事件
echo "查询交换事件..."
curl -s -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ swaps(first: 5, orderBy: blockTimestamp, orderDirection: desc) { id pair sender amount0In amount1In amount0Out amount1Out } }"
  }' | jq '.'

# 查询代币信息
echo "查询代币信息..."
curl -s -X POST http://localhost:8000/subgraphs/name/uni-swap-v2-monitor \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ tokens(first: 5) { id symbol name decimals totalSupply } }"
  }' | jq '.'

echo "🎉 测试完成！"
echo ""
echo "📝 访问Graph Playground: http://localhost:8000"
echo "📊 子图名称: uni-swap-v2-monitor" 