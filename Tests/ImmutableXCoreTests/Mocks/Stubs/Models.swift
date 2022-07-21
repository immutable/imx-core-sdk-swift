import Foundation
@testable import ImmutableXCore

let tokenETHStub1 = Token(
    data: TokenData(
        decimals: 18,
        quantity: "200000000000000",
        quantityWithFees: "200000000000000"
    ),
    type: "ETH"
)

let tokenERC721Stub1 = Token(
    data: TokenData(
        quantity: "1",
        quantityWithFees: "1",
        tokenAddress: "0x6ee5c0836ba5523c9f0eee40da69befa30b3d97e",
        tokenId: "11"
    ),
    type: "ERC721"
)

let orderFilledStub1 = Order(
    amountSold: "1",
    buy: tokenETHStub1,
    expirationTimestamp: nil,
    fees: nil,
    orderId: 1,
    sell: tokenERC721Stub1,
    status: "filled",
    timestamp: nil,
    updatedTimestamp: nil,
    user: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7d"
)

let orderActiveStub2 = Order(
    amountSold: "1",
    buy: tokenETHStub1,
    expirationTimestamp: nil,
    fees: nil,
    orderId: 1,
    sell: tokenERC721Stub1,
    status: "active",
    timestamp: nil,
    updatedTimestamp: nil,
    user: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7d"
)

let signableTradeResponseStub1 = GetSignableTradeResponse(
    amountBuy: "1",
    amountSell: "10100000000000000",
    assetIdBuy: "0x0400018c7bd712ffd55027823f43277c11070bbaae94c8817552471a7abfcb01",
    assetIdSell: "0x0400018c7bd712ffd55027823f43277c11070bbaae94c8817552471a7abfcb02",
    expirationTimestamp: 1_325_765,
    nonce: 639_749_977,
    payloadHash: "tradePayloadHash",
    signableMessage: "messageForL1",
    starkKey: "0x06588251eea34f39848302f991b8bc7098e2bb5fd2eba120255f91e971a23485",
    vaultIdBuy: 1_502_450_105,
    vaultIdSell: 1_502_450_104
)

let createTradeResponseStub1 = CreateTradeResponse(
    requestId: "id1",
    status: "filled",
    tradeId: 2
)

let feeEntryStub1 = FeeEntry(
    address: "address",
    feePercentage: 2
)

let signableOrderResponseStub1 = GetSignableOrderResponse(
    amountBuy: "10100000000000000",
    amountSell: "1",
    assetIdBuy: "0x0400018c7bd712ffd55027823f43277c11070bbaae94c8817552471a7abfcb01",
    assetIdSell: "0x0400018c7bd712ffd55027823f43277c11070bbaae94c8817552471a7abfcb02",
    expirationTimestamp: 1_325_907,
    nonce: 596_252_354,
    payloadHash: "orderPayloadHash",
    signableMessage: "messageForL1",
    starkKey: "0x06588251eea34f39848302f991b8bc7098e2bb5fd2eba120255f91e971a23485",
    vaultIdBuy: 1_502_450_105,
    vaultIdSell: 1_502_450_104
)

let createOrderResponseStub1 = CreateOrderResponse(
    orderId: 1,
    status: OrderStatus.filled.rawValue,
    time: 1_325_765
)

let erc721AssetStub1 = ERC721Asset(
    tokenAddress: "0x6ee5c0826ba5523c9f0eee40da69befa30b3d97f",
    tokenId: "9"
)

let erc20AssetStub1 = ERC20Asset(
    quantity: "0.0101",
    tokenAddress: "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
    decimals: 6
)

let ethAssetStub1 = ETHAsset(
    quantity: "0.0101"
)

let signableCancelOrderResponseStub1 = GetSignableCancelOrderResponse(
    orderId: 1,
    payloadHash: "cancelOrderPayloadHash",
    signableMessage: "messageForL1"
)

let cancelOrderResponseStub1 = CancelOrderResponse(
    orderId: 1,
    status: OrderStatus.cancelled.rawValue
)
