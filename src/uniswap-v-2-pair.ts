import { BigInt, BigDecimal, Address } from "@graphprotocol/graph-ts"
import {
  Swap as SwapEvent,
  Mint as MintEvent,
  Burn as BurnEvent,
  Sync as SyncEvent,
} from "../generated/templates/UniswapV2Pair/UniswapV2Pair"
import { Pair, Token, Swap, Mint, Burn } from "../generated/schema"
import { ZERO_BD, calculateUSDValue, safeDiv } from "./utils"

export function handleSwap(event: SwapEvent): void {
  let pair = Pair.load(event.address)
  if (pair == null) {
    return
  }

  let swap = new Swap(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  swap.pair = event.address
  swap.sender = event.params.sender
  swap.amount0In = event.params.amount0In
  swap.amount1In = event.params.amount1In
  swap.amount0Out = event.params.amount0Out
  swap.amount1Out = event.params.amount1Out
  swap.to = event.params.to
  swap.logIndex = event.logIndex
  // 计算USD价值（简化版本，实际项目中需要更复杂的价格预言机）
  swap.amountUSD = ZERO_BD
  swap.blockNumber = event.block.number
  swap.blockTimestamp = event.block.timestamp
  swap.transactionHash = event.transaction.hash

  swap.save()

  // 更新配对统计
  pair.txCount = pair.txCount.plus(BigInt.fromI32(1))
  pair.save()
}

export function handleMint(event: MintEvent): void {
  let pair = Pair.load(event.address)
  if (pair == null) {
    return
  }

  let mint = new Mint(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  mint.pair = event.address
  mint.sender = event.params.sender
  mint.amount0 = event.params.amount0
  mint.amount1 = event.params.amount1
  mint.logIndex = event.logIndex
  mint.blockNumber = event.block.number
  mint.blockTimestamp = event.block.timestamp
  mint.transactionHash = event.transaction.hash

  mint.save()

  // 更新配对储备金
  pair.reserve0 = pair.reserve0.plus(event.params.amount0)
  pair.reserve1 = pair.reserve1.plus(event.params.amount1)
  pair.totalSupply = pair.totalSupply.plus(event.params.amount0.plus(event.params.amount1))
  pair.save()
}

export function handleBurn(event: BurnEvent): void {
  let pair = Pair.load(event.address)
  if (pair == null) {
    return
  }

  let burn = new Burn(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  burn.pair = event.address
  burn.sender = event.params.sender
  burn.amount0 = event.params.amount0
  burn.amount1 = event.params.amount1
  burn.logIndex = event.logIndex
  burn.blockNumber = event.block.number
  burn.blockTimestamp = event.block.timestamp
  burn.transactionHash = event.transaction.hash

  burn.save()

  // 更新配对储备金
  pair.reserve0 = pair.reserve0.minus(event.params.amount0)
  pair.reserve1 = pair.reserve1.minus(event.params.amount1)
  pair.totalSupply = pair.totalSupply.minus(event.params.amount0.plus(event.params.amount1))
  pair.save()
}

export function handleSync(event: SyncEvent): void {
  let pair = Pair.load(event.address)
  if (pair == null) {
    return
  }

  // 更新储备金
  pair.reserve0 = event.params.reserve0
  pair.reserve1 = event.params.reserve1

  // 计算价格
  if (pair.reserve1.notEqual(BigInt.fromI32(0))) {
    pair.token0Price = safeDiv(pair.reserve0.toBigDecimal(), pair.reserve1.toBigDecimal())
  }
  if (pair.reserve0.notEqual(BigInt.fromI32(0))) {
    pair.token1Price = safeDiv(pair.reserve1.toBigDecimal(), pair.reserve0.toBigDecimal())
  }

  pair.save()
} 