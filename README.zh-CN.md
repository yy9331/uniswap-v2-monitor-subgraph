# Uniswap V2 子图监控器

[English](README.md) · [中文](README.zh-CN.md)

这是一个用于监控Uniswap V2协议的子图项目，可以追踪交易对创建、代币交换、流动性提供和移除等事件。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://docker.com/)
[![Graph Protocol](https://img.shields.io/badge/Graph-Protocol-purple.svg)](https://thegraph.com/)

## ✨ 功能特性

- 监控Uniswap V2工厂合约的配对创建事件
- 追踪所有交易对的交换、铸造和销毁事件
- 实时更新代币价格和流动性数据
- 支持本地部署和测试
- 提供GraphQL Playground可视化查询界面
- 全面的事件索引和数据处理
- 基于Docker的本地开发环境

## 🏗️ 项目结构

```
├── src/                    # 源代码目录
│   ├── uniswap-v-2-factory.ts  # 工厂合约事件处理
│   ├── uniswap-v-2-pair.ts     # 配对合约事件处理
│   └── utils.ts                 # 工具函数
├── abis/                  # 合约ABI文件
├── generated/             # 自动生成的类型文件
├── tests/                 # 测试文件
├── scripts/               # 自动化脚本
├── queries/               # 示例查询
├── schema.graphql         # GraphQL模式定义
├── subgraph.yaml          # 子图配置文件
├── docker-compose.yml     # 本地部署配置
├── README.md              # 英文文档
├── README.zh-CN.md        # 中文文档
└── package.json           # 项目依赖
```

## 🚀 本地部署完整指南

### 前置要求

- Node.js (推荐 v16+)
- Docker 和 Docker Compose
- Graph CLI

### 步骤1: 环境准备

首先安装Graph CLI：
```bash
npm install -g @graphprotocol/graph-cli
```

### 步骤2: 项目设置

1. **安装依赖**：
```bash
npm install
```

2. **生成代码**：
```bash
npm run codegen
```

3. **构建项目**：
```bash
npm run build
```

### 步骤3: 启动本地Graph节点

1. **启动Docker服务**：
```bash
docker-compose up -d
```

2. **检查服务状态**：
```bash
docker-compose ps
```

预期输出：
```
              Name                            Command                  State                           Ports
---------------------------------------------------------------------------------------------------------------------------------
uni-swap-v2-monitor_graph-node_1   start                            Up             0.0.0.0:8000->8000/tcp,
                                                                                   0.0.0.0:8001->8001/tcp,
                                                                                   0.0.0.0:8020->8020/tcp,
                                                                                   0.0.0.0:8030->8030/tcp, 0.0.0.0:8040->8040/tcp
uni-swap-v2-monitor_ipfs_1         /sbin/tini -- /usr/local/b ...   Up (healthy)   4001/tcp, 4001/udp, 0.0.0.0:5001->5001/tcp,
                                                                                   8080/tcp, 8081/tcp
uni-swap-v2-monitor_postgres_1     docker-entrypoint.sh postg ...   Up             0.0.0.0:5432->5432/tcp
```

### 步骤4: 配置以太坊网络连接

**重要**：确保docker-compose.yml中的以太坊RPC配置正确：

```yaml
environment:
  ethereum: "mainnet:https://mainnet.infura.io/v3/YOUR_PROJECT_ID"
```

如果遇到网络连接问题，可以尝试以下RPC端点：
- Infura: `https://mainnet.infura.io/v3/YOUR_PROJECT_ID`
- Alchemy: `https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY`
- Ankr: `https://rpc.ankr.com/eth`

### 步骤5: 部署子图

1. **创建子图**：
```bash
graph create uni-swap-v2-monitor --node http://localhost:8020
```

2. **部署子图**：
```bash
graph deploy uni-swap-v2-monitor --ipfs http://localhost:5001 --node http://localhost:8020
```

## 📊 数据实体

### PairCreated
记录新交易对的创建事件

### Pair
交易对信息，包括储备金、价格、交易量等

### Token
代币信息，包括符号、名称、精度等

### Swap
交换事件记录

### Mint
流动性提供事件记录

### Burn
流动性移除事件记录

## 🔍 示例查询

### 查询交易对
```graphql
{
  pairs(first: 10, orderBy: createdAtTimestamp, orderDirection: desc) {
    id
    token0
    token1
    reserve0
    reserve1
    token0Price
    token1Price
    volumeUSD
    txCount
    createdAtTimestamp
  }
}
```

### 查询交换事件
```graphql
{
  swaps(first: 20, orderBy: blockTimestamp, orderDirection: desc) {
    id
    pair
    sender
    amount0In
    amount1In
    amount0Out
    amount1Out
    to
    amountUSD
    blockTimestamp
    transactionHash
  }
}
```

### 查询代币信息
```graphql
{
  tokens(first: 10) {
    id
    symbol
    name
    decimals
    totalSupply
    volume
    txCount
    pairCount
  }
}
```

### 查询铸造事件
```graphql
{
  mints(first: 10, orderBy: blockTimestamp, orderDirection: desc) {
    id
    pair
    sender
    amount0
    amount1
    blockTimestamp
    transactionHash
  }
}
```

### 查询销毁事件
```graphql
{
  burns(first: 10, orderBy: blockTimestamp, orderDirection: desc) {
    id
    pair
    sender
    amount0
    amount1
    to
    blockTimestamp
    transactionHash
  }
}
```

## 🌐 远程访问配置

### 1. 服务器防火墙配置
```bash
# 开放GraphQL查询端口
sudo ufw allow 8000/tcp

# 开放GraphQL Playground端口  
sudo ufw allow 8001/tcp

# 检查端口状态
sudo ufw status
```

### 2. 安全建议
- 在生产环境中使用HTTPS
- 配置Nginx反向代理
- 添加API访问限制
- 监控API使用情况

## 🔧 端口配置

docker-compose.yml中的端口配置：
```yaml
ports:
  - "8000:8000" # HTTP queries - 主要查询端口
  - "8001:8001" # GraphQL playground - 可视化查询界面
  - "8020:8020" # JSON-RPC admin - 管理接口
  - "8030:8030" # Index node server
  - "8040:8040" # Metrics server
```

## 🛠️ 开发指南

### 添加新事件处理

1. 在`schema.graphql`中定义新的实体
2. 在`subgraph.yaml`中添加事件处理器
3. 在对应的处理文件中实现事件处理逻辑
4. 运行`npm run codegen`重新生成类型
5. 运行`npm run build`构建项目

### 调试技巧

- 使用GraphQL Playground查询数据
- 查看Docker日志：`docker-compose logs graph-node`
- 使用测试文件验证逻辑

## 📁 访问信息

- **GraphQL Playground**: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql
- **子图端点**: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor
- **GraphQL查询端点**: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql

## 🔧 故障排除

### 常见问题

1. **端口冲突**
   **问题**：`Bind for 0.0.0.0:5432 failed: port is already allocated`
   
   **解决方案**：
   ```bash
   # 停止现有容器
   docker-compose down
   
   # 检查占用端口的进程
   ss -tlnp | grep -E ":(5432|5001)"
   
   # 停止相关进程后重新启动
   docker-compose up -d
   ```

2. **以太坊网络连接失败**
   **问题**：`eth_getBlockByNumber RPC call failed`
   
   **解决方案**：
   1. 检查docker-compose.yml中的ethereum配置
   2. 尝试不同的RPC端点
   3. 重启Graph节点：
   ```bash
   docker-compose restart graph-node
   ```

3. **子图部署失败**
   **问题**：`HTTP error deploying the subgraph ECONNRESET`
   
   **解决方案**：
   1. 确保Graph节点完全启动
   2. 检查以太坊网络连接
   3. 重新部署：
   ```bash
   npm run deploy-local
   ```

4. **代码生成错误**
   **问题**：`@entity directive requires immutable argument`
   
   **解决方案**：
   确保schema.graphql中的实体定义包含immutable参数：
   ```graphql
   type Pair @entity(immutable: false) {
     # ...
   }
   
   type Token @entity(immutable: false) {
     # ...
   }
   ```

5. **GraphQL Playground无法访问**
   **问题**：浏览器无法访问GraphQL Playground
   
   **解决方案**：
   1. 确认正确的访问地址：
      ```
      http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql
      ```
   2. 检查防火墙设置
   3. 确认Docker容器正在运行

## 📄 许可证

[MIT License](LICENSE)

## 🤝 贡献

欢迎贡献代码！请随时提交 Pull Request。

## 📞 支持

如果您有任何问题或建议，请 [提交 Issue](https://github.com/yy9331/uniswap-v2-monitor-subgraph/issues)。 