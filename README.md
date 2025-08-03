# Uniswap V2 Subgraph Monitor

[English](README.md) · [中文](README.zh-CN.md)

A subgraph project for monitoring Uniswap V2 protocol events, tracking pair creation, token swaps, liquidity provision, and removal events.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://docker.com/)
[![Graph Protocol](https://img.shields.io/badge/Graph-Protocol-purple.svg)](https://thegraph.com/)

## ✨ Features

- Monitor Uniswap V2 factory contract pair creation events
- Track all trading pair swap, mint, and burn events
- Real-time token price and liquidity data updates
- Local deployment and testing support
- GraphQL Playground for visual query interface
- Comprehensive event indexing and data processing
- Docker-based local development environment

## 🏗️ Project Structure

```
├── src/                    # Source code directory
│   ├── uniswap-v-2-factory.ts  # Factory contract event handlers
│   ├── uniswap-v-2-pair.ts     # Pair contract event handlers
│   └── utils.ts                 # Utility functions
├── abis/                  # Contract ABI files
├── generated/             # Auto-generated type files
├── tests/                 # Test files
├── scripts/               # Automation scripts
├── queries/               # Example queries
├── schema.graphql         # GraphQL schema definition
├── subgraph.yaml          # Subgraph configuration
├── docker-compose.yml     # Local deployment configuration
├── README.md              # English documentation
├── README.zh-CN.md        # Chinese documentation
└── package.json           # Project dependencies
```

## 🚀 Complete Local Deployment Guide

### Prerequisites

- Node.js (recommended v16+)
- Docker and Docker Compose
- Graph CLI

### Step 1: Environment Setup

First, install Graph CLI:
```bash
npm install -g @graphprotocol/graph-cli
```

### Step 2: Project Setup

1. **Install dependencies**:
```bash
npm install
```

2. **Generate code**:
```bash
npm run codegen
```

3. **Build project**:
```bash
npm run build
```

### Step 3: Start Local Graph Node

1. **Start Docker services**:
```bash
docker-compose up -d
```

2. **Check service status**:
```bash
docker-compose ps
```

Expected output:
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

### Step 4: Configure Ethereum Network Connection

**Important**: Ensure the Ethereum RPC configuration in docker-compose.yml is correct:

```yaml
environment:
  ethereum: "mainnet:https://mainnet.infura.io/v3/YOUR_PROJECT_ID"
```

If you encounter network connection issues, try these RPC endpoints:
- Infura: `https://mainnet.infura.io/v3/YOUR_PROJECT_ID`
- Alchemy: `https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY`
- Ankr: `https://rpc.ankr.com/eth`

### Step 5: Deploy Subgraph

1. **Create subgraph**:
```bash
graph create uni-swap-v2-monitor --node http://localhost:8020
```

2. **Deploy subgraph**:
```bash
graph deploy uni-swap-v2-monitor --ipfs http://localhost:5001 --node http://localhost:8020
```

## 📊 Data Entities

### PairCreated
Records new trading pair creation events

### Pair
Trading pair information including reserves, prices, volume, etc.

### Token
Token information including symbol, name, decimals, etc.

### Swap
Swap event records

### Mint
Liquidity provision event records

### Burn
Liquidity removal event records

## 🔍 Example Queries

### Query Trading Pairs
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

### Query Swap Events
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

### Query Token Information
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

### Query Mint Events
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

### Query Burn Events
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

## 🌐 Remote Access Configuration

### 1. Server Firewall Configuration
```bash
# Open GraphQL query port
sudo ufw allow 8000/tcp

# Open GraphQL Playground port  
sudo ufw allow 8001/tcp

# Check port status
sudo ufw status
```

### 2. Security Recommendations
- Use HTTPS in production environments
- Configure Nginx reverse proxy
- Add API access restrictions
- Monitor API usage

## 🔧 Port Configuration

docker-compose.yml port configuration:
```yaml
ports:
  - "8000:8000" # HTTP queries - main query port
  - "8001:8001" # GraphQL playground - visual query interface
  - "8020:8020" # JSON-RPC admin - management interface
  - "8030:8030" # Index node server
  - "8040:8040" # Metrics server
```

## 🛠️ Development Guide

### Adding New Event Handlers

1. Define new entities in `schema.graphql`
2. Add event handlers in `subgraph.yaml`
3. Implement event handling logic in corresponding handler files
4. Run `npm run codegen` to regenerate types
5. Run `npm run build` to build the project

### Debugging Tips

- Use GraphQL Playground to query data
- View Docker logs: `docker-compose logs graph-node`
- Use test files to validate logic

## 📁 Access Information

- **GraphQL Playground**: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql
- **Subgraph Endpoint**: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor
- **GraphQL Query Endpoint**: http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql

## 🔧 Troubleshooting

### Common Issues

1. **Port Conflicts**
   **Problem**: `Bind for 0.0.0.0:5432 failed: port is already allocated`
   
   **Solution**:
   ```bash
   # Stop existing containers
   docker-compose down
   
   # Check processes using ports
   ss -tlnp | grep -E ":(5432|5001)"
   
   # Stop related processes and restart
   docker-compose up -d
   ```

2. **Ethereum Network Connection Failure**
   **Problem**: `eth_getBlockByNumber RPC call failed`
   
   **Solution**:
   1. Check ethereum configuration in docker-compose.yml
   2. Try different RPC endpoints
   3. Restart Graph node:
   ```bash
   docker-compose restart graph-node
   ```

3. **Subgraph Deployment Failure**
   **Problem**: `HTTP error deploying the subgraph ECONNRESET`
   
   **Solution**:
   1. Ensure Graph node is fully started
   2. Check Ethereum network connection
   3. Redeploy:
   ```bash
   npm run deploy-local
   ```

4. **Code Generation Errors**
   **Problem**: `@entity directive requires immutable argument`
   
   **Solution**:
   Ensure entity definitions in schema.graphql include immutable parameter:
   ```graphql
   type Pair @entity(immutable: false) {
     # ...
   }
   
   type Token @entity(immutable: false) {
     # ...
   }
   ```

5. **GraphQL Playground Unreachable**
   **Problem**: Browser cannot access GraphQL Playground
   
   **Solution**:
   1. Confirm correct access address:
      ```
      http://localhost:8000/subgraphs/name/uni-swap-v2-monitor/graphql
      ```
   2. Check firewall settings
   3. Confirm Docker containers are running

## 📄 License

[MIT License](LICENSE)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you have any questions or issues, please [open an issue](https://github.com/yy9331/uniswap-v2-monitor-subgraph/issues). 