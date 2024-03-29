import Foundation
@testable import ImmutableXCore

let coreStub1 = ImmutableX(
    base: .sandbox,
    createTradeWorkflow: CreateTradeWorkflowMock.self,
    createOrderWorkflow: CreateOrderWorkflowMock.self,
    cancelOrderWorkflow: CancelOrderWorkflowMock.self,
    transferWorkflow: TransferWorkflowMock.self,
    registerWorkflow: RegisterWorkflowMock.self
)

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

let signableTransferResponseDetailsStub1 = SignableTransferResponseDetails(
    amount: "1",
    assetId: "0x0400018c7bd712ffd55027823f43277c11070bbaae94c8817552471a7abfcb02",
    expirationTimestamp: 1_325_907,
    nonce: 596_252_354,
    payloadHash: "hash",
    receiverStarkKey: "0x06588251eea34f39848302f991b8bc7098e2bb5fd2eba120255f91e971a23485",
    receiverVaultId: 1_502_450_104,
    senderVaultId: 1_502_450_105,
    token: ERC721Asset(
        tokenAddress: "tokenAddress",
        tokenId: "tokenId"
    ).asSignableToken()
)

let signableTransferResponseStub1 = GetSignableTransferResponse(
    senderStarkKey: "0x06588251eea34f39848302f991b8bc7098e2bb5fd2eba120255f91e971a23486",
    signableMessage: "messageForL1",
    signableResponses: [signableTransferResponseDetailsStub1]
)

let signableTransferResponseStub2 = GetSignableTransferResponse(
    senderStarkKey: "0x06588251eea34f39848302f991b8bc7098e2bb5fd2eba120255f91e971a23486",
    signableMessage: "messageForL1",
    signableResponses: []
)

let createTransferResponseStub1 = CreateTransferResponse(transferIds: [1])

let usersAPIResponseStub1 = GetUsersApiResponse(accounts: ["0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f"])

let signableRegistrationOffchainResponseStub1 = GetSignableRegistrationOffchainResponse(
    payloadHash: "payload",
    signableMessage: "signable"
)

let registerUserResponseStub1 = RegisterUserResponse(txHash: "hash")

let signedMoonpayResponseStub1 = GetSignedMoonpayResponse(signature: "signature")

let transactionIdResponseStub1 = GetTransactionIdResponse(
    id: 123,
    walletAddress: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f",
    provider: .moonpay
)

let currenciesReponseStub1 = GetCurrenciesResponse(
    currencyCodes: ["code": "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f"]
)

let depositStub1 = Deposit(
    status: "status",
    timestamp: "timestamp",
    token: tokenETHStub1,
    transactionId: 1,
    user: "user"
)

let listDepositResponsesStub1 = ListDepositsResponse(
    cursor: "cursor",
    remaining: 1,
    result: [depositStub1]
)

let assetStub1 = Asset(
    collection: .init(iconUrl: nil, name: ""),
    createdAt: nil,
    description: nil,
    imageUrl: nil,
    metadata: nil,
    name: nil,
    status: "status",
    tokenAddress: "address",
    tokenId: "1",
    updatedAt: nil,
    uri: nil,
    user: "user"
)

let assetWithOrdersStub1 = AssetWithOrders(
    collection: .init(iconUrl: nil, name: ""),
    createdAt: nil,
    description: nil,
    imageUrl: nil,
    metadata: nil,
    name: nil,
    status: "status",
    tokenAddress: "address",
    tokenId: "1",
    updatedAt: nil,
    uri: nil,
    user: "user"
)

let listAssetsResponseStub1 = ListAssetsResponse(
    cursor: "",
    remaining: 0,
    result: [assetWithOrdersStub1]
)

let collectionStub1 = Collection(
    address: "address",
    collectionImageUrl: nil,
    description: nil,
    iconUrl: nil,
    metadataApiUrl: nil,
    name: "name",
    projectId: 1,
    projectOwnerAddress: "address"
)

let collectionFilterStub1 = CollectionFilter(
    key: "key",
    range: nil,
    type: nil,
    value: nil
)

let listCollectionResponseStub1 = ListCollectionsResponse(
    cursor: "",
    remaining: 0,
    result: [collectionStub1]
)

let projectStub1 = Project(
    collectionLimitExpiresAt: "",
    collectionMonthlyLimit: 1,
    collectionRemaining: 1,
    companyName: "companyName",
    contactEmail: "email",
    id: 1,
    mintLimitExpiresAt: "",
    mintMonthlyLimit: 1,
    mintRemaining: 1,
    name: "Proj"
)

let getProjectResponseStub1 = GetProjectsResponse(
    cursor: "",
    remaining: 0,
    result: [projectStub1]
)

let balanceStub1 = Balance(
    balance: "1",
    preparingWithdrawal: "",
    symbol: "ETH",
    tokenAddress: "address",
    withdrawable: ""
)

let listBalancesResponseStub1 = ListBalancesResponse(
    cursor: "",
    result: [balanceStub1]
)

let mintStub1 = Mint(
    status: "status",
    timestamp: "",
    token: tokenETHStub1,
    transactionId: 1,
    user: "user"
)

let listMintsResponseStub1 = ListMintsResponse(
    cursor: "",
    remaining: 1,
    result: [mintStub1]
)

let withdrawalStub1 = Withdrawal(
    rollupStatus: "status",
    sender: "sender",
    status: "status",
    timestamp: "",
    token: tokenETHStub1,
    transactionId: 1,
    withdrawnToWallet: false
)

let listWithdrawalsResponseStub1 = ListWithdrawalsResponse(
    cursor: "",
    remaining: 0,
    result: [withdrawalStub1]
)

let listOrdersResponseStub1 = ListOrdersResponse(
    cursor: "",
    remaining: 0,
    result: [orderActiveStub2]
)

let tradeStub1 = Trade(
    a: TradeSide(orderId: 1, sold: "sold", tokenType: ""),
    b: TradeSide(orderId: 2, sold: "sold", tokenType: ""),
    status: "status",
    timestamp: nil,
    transactionId: 1
)

let listTradesResponseStub1 = ListTradesResponse(
    cursor: "",
    remaining: 0,
    result: []
)

let tokenDetailsStub1 = TokenDetails(
    decimals: "decimals",
    imageUrl: "",
    name: "name",
    quantum: "",
    symbol: "",
    tokenAddress: "address"
)

let listTokensResponseStub1 = ListTokensResponse(
    cursor: "",
    result: [tokenDetailsStub1]
)

let transferStub1 = Transfer(
    receiver: "",
    status: "status",
    timestamp: nil,
    token: tokenETHStub1,
    transactionId: 1,
    user: ""
)

let listTransfersStub1 = ListTransfersResponse(
    cursor: "",
    remaining: 0,
    result: [transferStub1]
)
