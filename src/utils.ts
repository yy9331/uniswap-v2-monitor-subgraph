import { BigInt, BigDecimal } from "@graphprotocol/graph-ts"

// 常量定义
export const ZERO_BI = BigInt.fromI32(0)
export const ONE_BI = BigInt.fromI32(1)
export const ZERO_BD = BigDecimal.fromString("0")
export const ONE_BD = BigDecimal.fromString("1")

// 价格计算工具函数
export function convertTokenToDecimal(tokenAmount: BigInt, exchangeDecimals: BigInt): BigDecimal {
  if (exchangeDecimals == ZERO_BI) {
    return tokenAmount.toBigDecimal()
  }
  return tokenAmount.toBigDecimal().div(exchangeDecimals.toBigDecimal())
}

export function convertEthToDecimal(eth: BigInt): BigDecimal {
  return convertTokenToDecimal(eth, BigInt.fromI32(18))
}

export function equalToZero(value: BigDecimal): boolean {
  const ZERO = BigDecimal.fromString("0")
  return value.equals(ZERO)
}

export function isNullEthValue(value: string): boolean {
  return value == "0x0000000000000000000000000000000000000000000000000000000000000001"
}

// 计算USD价值的简化版本
export function calculateUSDValue(amount: BigInt, price: BigDecimal): BigDecimal {
  if (price.equals(ZERO_BD)) {
    return ZERO_BD
  }
  return amount.toBigDecimal().times(price)
}

// 安全除法
export function safeDiv(a: BigDecimal, b: BigDecimal): BigDecimal {
  if (b.equals(ZERO_BD)) {
    return ZERO_BD
  }
  return a.div(b)
}

// 计算价格
export function calculatePrice(reserve0: BigInt, reserve1: BigInt, decimals0: BigInt, decimals1: BigInt): BigDecimal {
  if (reserve1.equals(ZERO_BI)) {
    return ZERO_BD
  }
  
  const reserve0Decimal = convertTokenToDecimal(reserve0, decimals0)
  const reserve1Decimal = convertTokenToDecimal(reserve1, decimals1)
  
  return safeDiv(reserve0Decimal, reserve1Decimal)
} 