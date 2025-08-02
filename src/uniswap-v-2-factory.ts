import { BigInt, BigDecimal, Address } from "@graphprotocol/graph-ts"
import { PairCreated as PairCreatedEvent } from "../generated/UniswapV2Factory/UniswapV2Factory"
import { PairCreated, Pair, Token } from "../generated/schema"

export function handlePairCreated(event: PairCreatedEvent): void {
  let entity = new PairCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token0 = event.params.token0
  entity.token1 = event.params.token1
  entity.pair = event.params.pair
  entity.param3 = event.params.param3

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()

  // 创建配对实体
  let pair = new Pair(event.params.pair)
  pair.token0 = event.params.token0
  pair.token1 = event.params.token1
  pair.reserve0 = BigInt.fromI32(0)
  pair.reserve1 = BigInt.fromI32(0)
  pair.totalSupply = BigInt.fromI32(0)
  pair.token0Price = BigDecimal.fromString("0")
  pair.token1Price = BigDecimal.fromString("0")
  pair.volumeUSD = BigDecimal.fromString("0")
  pair.txCount = BigInt.fromI32(0)
  pair.createdAtTimestamp = event.block.timestamp
  pair.createdAtBlockNumber = event.block.number
  pair.save()

  // 创建或更新代币实体
  let token0 = Token.load(event.params.token0)
  if (token0 == null) {
    token0 = new Token(event.params.token0)
    token0.symbol = ""
    token0.name = ""
    token0.decimals = BigInt.fromI32(0)
    token0.totalSupply = BigInt.fromI32(0)
    token0.volume = BigDecimal.fromString("0")
    token0.txCount = BigInt.fromI32(0)
    token0.pairCount = BigInt.fromI32(0)
  }
  token0.pairCount = token0.pairCount.plus(BigInt.fromI32(1))
  token0.save()

  let token1 = Token.load(event.params.token1)
  if (token1 == null) {
    token1 = new Token(event.params.token1)
    token1.symbol = ""
    token1.name = ""
    token1.decimals = BigInt.fromI32(0)
    token1.volume = BigDecimal.fromString("0")
    token1.txCount = BigInt.fromI32(0)
    token1.pairCount = BigInt.fromI32(0)
  }
  token1.pairCount = token1.pairCount.plus(BigInt.fromI32(1))
  token1.save()
}
