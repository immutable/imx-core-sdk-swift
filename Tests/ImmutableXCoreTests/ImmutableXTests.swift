@testable import ImmutableXCore
import XCTest

final class ImmutableXTests: XCTestCase {
    let createTradeWorkflow = CreateTradeWorkflowMock.self
    let createOrderWorkflow = CreateOrderWorkflowMock.self
    let cancelOrderWorkflow = CancelOrderWorkflowMock.self
    let transferWorkflowMock = TransferWorkflowMock.self
    let registerWorkflowMock = RegisterWorkflowMock.self
    let buyCryptoWorkflowMock = BuyCryptoWorkflowMock.self
    let usersAPIMock = UsersAPIMock.self
    let depositsAPIMock = DepositAPIMock.self
    let assetsAPIMock = AssetsAPIMock.self
    let collectionsAPIMock = CollectionsAPIMock.self
    let projectsAPIMock = ProjectsAPIMock.self
    let balancesAPIMock = BalancesAPIMock.self
    let mintsAPIMock = MintsAPIMock.self
    let withdrawalsAPIMock = WithdrawalsAPIMock.self
    let ordersAPIMock = OrdersAPIMock.self
    let tradesAPIMock = TradesAPIMock.self
    let tokensAPIMock = TokensAPIMock.self
    let transfersAPIMock = TransfersAPIMock.self

    lazy var core = ImmutableX(
        createTradeWorkflow: createTradeWorkflow,
        createOrderWorkflow: createOrderWorkflow,
        cancelOrderWorkflow: cancelOrderWorkflow,
        transferWorkflow: transferWorkflowMock,
        registerWorkflow: registerWorkflowMock,
        buyCryptoWorkflow: buyCryptoWorkflowMock,
        assetsAPI: assetsAPIMock,
        balancesAPI: balancesAPIMock,
        collectionsAPI: collectionsAPIMock,
        depositsAPI: depositsAPIMock,
        mintsAPI: mintsAPIMock,
        ordersAPI: ordersAPIMock,
        projectsAPI: projectsAPIMock,
        tokensAPI: tokensAPIMock,
        tradesAPI: tradesAPIMock,
        transfersAPI: transfersAPIMock,
        usersAPI: usersAPIMock,
        withdrawalAPI: withdrawalsAPIMock
    )

    override func setUp() {
        super.setUp()
        createTradeWorkflow.resetMock()
        createOrderWorkflow.resetMock()
        cancelOrderWorkflow.resetMock()
        transferWorkflowMock.resetMock()
        registerWorkflowMock.resetMock()
        buyCryptoWorkflowMock.resetMock()
        usersAPIMock.resetMock()
        depositsAPIMock.resetMock()
        assetsAPIMock.resetMock()
        collectionsAPIMock.resetMock()
        projectsAPIMock.resetMock()
        balancesAPIMock.resetMock()
        mintsAPIMock.resetMock()
        withdrawalsAPIMock.resetMock()
        ordersAPIMock.resetMock()
        tradesAPIMock.resetMock()
        tokensAPIMock.resetMock()
        transfersAPIMock.resetMock()

        ImmutableX.initialize()

        let tradeCompanion = CreateTradeWorkflowCompanion()
        tradeCompanion.returnValue = createTradeResponseStub1
        createTradeWorkflow.mock(tradeCompanion, id: "1")

        let createOrderCompanion = CreateOrderWorkflowCompanion()
        createOrderCompanion.returnValue = createOrderResponseStub1
        createOrderWorkflow.mock(createOrderCompanion)

        let cancelOrderCompanion = CancelOrderWorkflowCompanion()
        cancelOrderCompanion.returnValue = cancelOrderResponseStub1
        cancelOrderWorkflow.mock(cancelOrderCompanion, id: "1")

        let transferCompanion = TransferWorkflowCompanion()
        transferCompanion.returnValue = createTransferResponseStub1
        transferWorkflowMock.mock(transferCompanion)

        let registerCompanion = RegisterWorkflowCompanion()
        registerCompanion.returnValue = true
        registerWorkflowMock.mock(registerCompanion)

        let buyCryptoCompanion = BuyCryptoWorkflowCompanion()
        buyCryptoCompanion.returnValue = "expected url"
        buyCryptoWorkflowMock.mock(buyCryptoCompanion)

        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.returnValue = GetUsersApiResponse(accounts: ["some key"])
        usersAPIMock.mock(usersCompanion)

        let depositCompanion = DepositAPIMock.GetDepositCompanion()
        depositCompanion.returnValue = depositStub1
        depositsAPIMock.mock(depositCompanion)

        let listDepositsCompanion = DepositAPIMock.ListDepositsCompanion()
        listDepositsCompanion.returnValue = listDepositResponsesStub1
        depositsAPIMock.mock(listDepositsCompanion)

        let assetCompanion = AssetsAPIMock.GetAssetCompanion()
        assetCompanion.returnValue = assetStub1
        assetsAPIMock.mock(assetCompanion)

        let listAssetsCompanion = AssetsAPIMock.ListAssetsCompanion()
        listAssetsCompanion.returnValue = listAssetsResponseStub1
        assetsAPIMock.mock(listAssetsCompanion)

        let collectionCompanion = CollectionsAPIMock.GetCollectionCompanion()
        collectionCompanion.returnValue = collectionStub1
        collectionsAPIMock.mock(collectionCompanion)

        let listCollectionFiltersCompanion = CollectionsAPIMock.ListCollectionFiltersCompanion()
        listCollectionFiltersCompanion.returnValue = collectionFilterStub1
        collectionsAPIMock.mock(listCollectionFiltersCompanion)

        let listCollectionsCompanion = CollectionsAPIMock.ListCollectionsCompanion()
        listCollectionsCompanion.returnValue = listCollectionResponseStub1
        collectionsAPIMock.mock(listCollectionsCompanion)

        let getProjectCompanion = ProjectsAPIMock.GetProjectCompanion()
        getProjectCompanion.returnValue = projectStub1
        projectsAPIMock.mock(getProjectCompanion)

        let getProjectsCompanion = ProjectsAPIMock.GetProjectsCompanion()
        getProjectsCompanion.returnValue = getProjectResponseStub1
        projectsAPIMock.mock(getProjectsCompanion)

        let getBalancesCompanion = BalancesAPIMock.GetBalanceCompanion()
        getBalancesCompanion.returnValue = balanceStub1
        balancesAPIMock.mock(getBalancesCompanion)

        let listBalancesCompanion = BalancesAPIMock.ListBalancesCompanion()
        listBalancesCompanion.returnValue = listBalancesResponseStub1
        balancesAPIMock.mock(listBalancesCompanion)

        let getMintCompanion = MintsAPIMock.GetMintCompanion()
        getMintCompanion.returnValue = mintStub1
        mintsAPIMock.mock(getMintCompanion)

        let listMintsCompanion = MintsAPIMock.ListMintsCompanion()
        listMintsCompanion.returnValue = listMintsResponseStub1
        mintsAPIMock.mock(listMintsCompanion)

        let getWithdrawalCompanion = WithdrawalsAPIMock.GetWithdrawalCompanion()
        getWithdrawalCompanion.returnValue = withdrawalStub1
        withdrawalsAPIMock.mock(getWithdrawalCompanion)

        let listWithdrawalsCompanion = WithdrawalsAPIMock.ListWithdrawalsCompanion()
        listWithdrawalsCompanion.returnValue = listWithdrawalsResponseStub1
        withdrawalsAPIMock.mock(listWithdrawalsCompanion)

        let getOrderCompanion = OrdersAPIMockGetCompanion()
        getOrderCompanion.returnValue = orderActiveStub2
        ordersAPIMock.mock(getOrderCompanion, id: "\(orderActiveStub2.orderId)")

        let listOrderCompanion = OrdersAPIMockListOrdersCompanion()
        listOrderCompanion.returnValue = listOrdersResponseStub1
        ordersAPIMock.mock(listOrderCompanion)

        let getTradeCompanion = TradesAPIMockGetTradeCompanion()
        getTradeCompanion.returnValue = tradeStub1
        tradesAPIMock.mock(getTradeCompanion)

        let listTradesCompanion = TradesAPIMockListTradesCompanion()
        listTradesCompanion.returnValue = listTradesResponseStub1
        tradesAPIMock.mock(listTradesCompanion)

        let getTokenCompanion = TokensAPIMock.GetTokenCompanion()
        getTokenCompanion.returnValue = tokenDetailsStub1
        tokensAPIMock.mock(getTokenCompanion)

        let listTokensCompanion = TokensAPIMock.ListTokensCompanion()
        listTokensCompanion.returnValue = listTokensResponseStub1
        tokensAPIMock.mock(listTokensCompanion)

        let getTransferCompanion = TransfersAPIMockGetTransferCompanion()
        getTransferCompanion.returnValue = transferStub1
        transfersAPIMock.mock(getTransferCompanion)

        let listTransfersCompanion = TransfersAPIMockListTransfersCompanion()
        listTransfersCompanion.returnValue = listTransfersStub1
        transfersAPIMock.mock(listTransfersCompanion)
    }

    func testSdkVersion() {
        XCTAssertEqual(ImmutableX.shared.sdkVersion, "0.4.0")
    }

    func testInitialize() {
        ImmutableX.initialize(base: .sandbox, logLevel: .calls(including: [.requestBody]))
        XCTAssertEqual(ImmutableX.shared.base, .sandbox)

        if case .calls(including: [.requestBody]) = ImmutableX.shared.logLevel {
            // success
        } else {
            XCTFail("Log level should have matched the initialize's method")
        }
    }

    // MARK: - Create Trade

    func testCreateTradeWorkflowSuccessAsync() async throws {
        let response = try await core.createTrade(
            orderId: "1",
            fees: [feeEntryStub1],
            signer: SignerMock(),
            starkSigner: StarkSignerMock()
        )
        XCTAssertEqual(response, createTradeResponseStub1)
    }

    func testCreateTradeWorkflowFailureAsync() async {
        let buyCompanion = CreateTradeWorkflowCompanion()
        buyCompanion.throwableError = DummyError.something
        createTradeWorkflow.mock(buyCompanion, id: "1")

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.createTrade(
                orderId: "1",
                fees: [feeEntryStub1],
                signer: SignerMock(),
                starkSigner: StarkSignerMock()
            )
        }
    }

    // MARK: - CreateOrder

    func testCreateOrderFlowSuccessAsync() async throws {
        let response = try await core.createOrder(
            asset: erc721AssetStub1,
            sellToken: erc20AssetStub1,
            fees: [],
            signer: SignerMock(),
            starkSigner: StarkSignerMock()
        )
        XCTAssertEqual(response, createOrderResponseStub1)
    }

    func testCreateOrderFlowFailureAsync() async {
        let companion = CreateOrderWorkflowCompanion()
        companion.throwableError = DummyError.something
        createOrderWorkflow.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.createOrder(
                asset: erc721AssetStub1,
                sellToken: erc20AssetStub1,
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock()
            )
        }
    }

    // MARK: - Cancel

    func testCancelOrderFlowSuccessAsync() async throws {
        let response = try await core.cancelOrder(orderId: "1", signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, cancelOrderResponseStub1)
    }

    func testCancelOrderFlowFailureAsync() async {
        let cancelOrderCompanion = CancelOrderWorkflowCompanion()
        cancelOrderCompanion.throwableError = DummyError.something
        cancelOrderWorkflow.mock(cancelOrderCompanion, id: "1")

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.cancelOrder(orderId: "1", signer: SignerMock(), starkSigner: StarkSignerMock())
        }
    }

    // MARK: - Transfer

    func testTransferFlowSuccessAsync() async throws {
        let response = try await core.transfer(
            token: ETHAsset(quantity: "10"),
            recipientAddress: "address",
            signer: SignerMock(),
            starkSigner: StarkSignerMock()
        )
        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testTransferFlowFailureAsync() async {
        let transferCompanion = TransferWorkflowCompanion()
        transferCompanion.throwableError = DummyError.something
        transferWorkflowMock.mock(transferCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.transfer(
                token: ETHAsset(quantity: "10"),
                recipientAddress: "address",
                signer: SignerMock(),
                starkSigner: StarkSignerMock()
            )
        }
    }

    // MARK: - Register

    func testRegisterFlowSuccessAsync() async throws {
        try await core.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(registerWorkflowMock.companion.callsCount, 1)
    }

    func testRegisterFlowFailureAsync() async {
        let registerCompanion = RegisterWorkflowCompanion()
        registerCompanion.throwableError = DummyError.something
        registerWorkflowMock.mock(registerCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock())
        }
    }

    // MARK: - Buy Crypto

    func testBuyCryptoFlowSuccessAsync() async throws {
        let url = try await core.buyCryptoURL(signer: SignerMock())
        XCTAssertEqual(url, "expected url")
    }

    func testBuyCryptoFlowFailureAsync() async {
        let buyCryptoCompanion = BuyCryptoWorkflowCompanion()
        buyCryptoCompanion.throwableError = DummyError.something
        buyCryptoWorkflowMock.mock(buyCryptoCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.buyCryptoURL(signer: SignerMock())
        }
    }

    // MARK: - Get User

    func testGetUserSuccess() async throws {
        let response = try await core.getUser(ethAddress: "address")
        XCTAssertEqual(response, GetUsersApiResponse(accounts: ["some key"]))
    }

    func testGetUserFailure() async {
        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.throwableError = DummyError.something
        usersAPIMock.mock(usersCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getUser(ethAddress: "address")
        }
    }

    // MARK: - Deposit

    func testGetDepositSuccess() async throws {
        let response = try await core.getDeposit(id: "id")
        XCTAssertEqual(response, depositStub1)
    }

    func testGetDepositFailure() async {
        let companion = DepositAPIMock.GetDepositCompanion()
        companion.throwableError = DummyError.something
        depositsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getDeposit(id: "id")
        }
    }

    func testListDepositsSuccess() async throws {
        let response = try await core.listDeposits()
        XCTAssertEqual(response, listDepositResponsesStub1)
    }

    func testListDepositsFailure() async {
        let companion = DepositAPIMock.ListDepositsCompanion()
        companion.throwableError = DummyError.something
        depositsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listDeposits()
        }
    }

    // MARK: - Asset

    func testGetAssetSuccess() async throws {
        let response = try await core.getAsset(tokenAddress: "address", tokenId: "id")
        XCTAssertEqual(response, assetStub1)
    }

    func testGetAssetFailure() async {
        let companion = AssetsAPIMock.GetAssetCompanion()
        companion.throwableError = DummyError.something
        assetsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getAsset(tokenAddress: "address", tokenId: "id")
        }
    }

    func testListAssetsSuccess() async throws {
        let response = try await core.listAssets()
        XCTAssertEqual(response, listAssetsResponseStub1)
    }

    func testListAssetsFailure() async {
        let companion = AssetsAPIMock.ListAssetsCompanion()
        companion.throwableError = DummyError.something
        assetsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listAssets()
        }
    }

    // MARK: - Collections

    func testGetCollectionSuccess() async throws {
        let response = try await core.getCollection(address: "address")
        XCTAssertEqual(response, collectionStub1)
    }

    func testGetCollectionFailure() async {
        let companion = CollectionsAPIMock.GetCollectionCompanion()
        companion.throwableError = DummyError.something
        collectionsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getCollection(address: "address")
        }
    }

    func testListCollectionFiltersSuccess() async throws {
        let response = try await core.listCollectionFilters(address: "address")
        XCTAssertEqual(response, collectionFilterStub1)
    }

    func testListCollectionFiltersFailure() async {
        let companion = CollectionsAPIMock.ListCollectionFiltersCompanion()
        companion.throwableError = DummyError.something
        collectionsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listCollectionFilters(address: "address")
        }
    }

    func testListCollectionsSuccess() async throws {
        let response = try await core.listCollections()
        XCTAssertEqual(response, listCollectionResponseStub1)
    }

    func testListCollectionsFailure() async {
        let companion = CollectionsAPIMock.ListCollectionsCompanion()
        companion.throwableError = DummyError.something
        collectionsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listCollections()
        }
    }

    // MARK: - Projects

    func testGetProjectSuccess() async throws {
        let response = try await core.getProject(id: "id", signer: SignerMock())
        XCTAssertEqual(response, projectStub1)
    }

    func testGetProjectFailure() async {
        let companion = ProjectsAPIMock.GetProjectCompanion()
        companion.throwableError = DummyError.something
        projectsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getProject(id: "id", signer: SignerMock())
        }
    }

    func testGetProjectsSuccess() async throws {
        let response = try await core.getProjects(signer: SignerMock())
        XCTAssertEqual(response, getProjectResponseStub1)
    }

    func testGetProjectsFailure() async {
        let companion = ProjectsAPIMock.GetProjectsCompanion()
        companion.throwableError = DummyError.something
        projectsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getProjects(signer: SignerMock())
        }
    }

    // MARK: - Balances

    func testGetBalanceSuccess() async throws {
        let response = try await core.getBalance(owner: "owner", address: "address")
        XCTAssertEqual(response, balanceStub1)
    }

    func testGetBalanceFailure() async {
        let companion = BalancesAPIMock.GetBalanceCompanion()
        companion.throwableError = DummyError.something
        balancesAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getBalance(owner: "owner", address: "address")
        }
    }

    func testListBalancesSuccess() async throws {
        let response = try await core.listBalances(owner: "owner")
        XCTAssertEqual(response, listBalancesResponseStub1)
    }

    func testListBalancesFailure() async {
        let companion = BalancesAPIMock.ListBalancesCompanion()
        companion.throwableError = DummyError.something
        balancesAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listBalances(owner: "owner")
        }
    }

    // MARK: - Mint

    func testGetMintSuccess() async throws {
        let response = try await core.getMint(id: "id")
        XCTAssertEqual(response, mintStub1)
    }

    func testGetMintFailure() async {
        let companion = MintsAPIMock.GetMintCompanion()
        companion.throwableError = DummyError.something
        mintsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getMint(id: "id")
        }
    }

    func testListMintsSuccess() async throws {
        let response = try await core.listMints()
        XCTAssertEqual(response, listMintsResponseStub1)
    }

    func testListMintsFailure() async {
        let companion = MintsAPIMock.ListMintsCompanion()
        companion.throwableError = DummyError.something
        mintsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listMints()
        }
    }

    // MARK: - Withdrawal

    func testGetWithdrawalSuccess() async throws {
        let response = try await core.getWithdrawal(id: "id")
        XCTAssertEqual(response, withdrawalStub1)
    }

    func testGetWithdrawalFailure() async {
        let companion = WithdrawalsAPIMock.GetWithdrawalCompanion()
        companion.throwableError = DummyError.something
        withdrawalsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getWithdrawal(id: "id")
        }
    }

    func testListWithdrawalsSuccess() async throws {
        let response = try await core.listWithdrawals()
        XCTAssertEqual(response, listWithdrawalsResponseStub1)
    }

    func testListWithdrawalsFailure() async {
        let companion = WithdrawalsAPIMock.ListWithdrawalsCompanion()
        companion.throwableError = DummyError.something
        withdrawalsAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listWithdrawals()
        }
    }

    // MARK: - Order

    func testGetOrderSuccess() async throws {
        let response = try await core.getOrder(id: "\(orderActiveStub2.orderId)")
        XCTAssertEqual(response, orderActiveStub2)
    }

    func testGetOrderFailure() async {
        let companion = OrdersAPIMockGetCompanion()
        companion.throwableError = DummyError.something
        ordersAPIMock.mock(companion, id: "\(orderActiveStub2.orderId)")

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getOrder(id: "\(orderActiveStub2.orderId)")
        }
    }

    func testListOrdersSuccess() async throws {
        let response = try await core.listOrders()
        XCTAssertEqual(response, listOrdersResponseStub1)
    }

    func testListOrdersFailure() async {
        let companion = OrdersAPIMockListOrdersCompanion()
        companion.throwableError = DummyError.something
        ordersAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listOrders()
        }
    }

    // MARK: - Trade

    func testGetTradeSuccess() async throws {
        let response = try await core.getTrade(id: "")
        XCTAssertEqual(response, tradeStub1)
    }

    func testGetTradeFailure() async {
        let companion = TradesAPIMockGetTradeCompanion()
        companion.throwableError = DummyError.something
        tradesAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getTrade(id: "")
        }
    }

    func testListTradesSuccess() async throws {
        let response = try await core.listTrades()
        XCTAssertEqual(response, listTradesResponseStub1)
    }

    func testListTradesFailure() async {
        let companion = TradesAPIMockListTradesCompanion()
        companion.throwableError = DummyError.something
        tradesAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listTrades()
        }
    }

    // MARK: - Token

    func testGetTokenSuccess() async throws {
        let response = try await core.getToken(address: "")
        XCTAssertEqual(response, tokenDetailsStub1)
    }

    func testGetTokenFailure() async {
        let companion = TokensAPIMock.GetTokenCompanion()
        companion.throwableError = DummyError.something
        tokensAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getToken(address: "")
        }
    }

    func testListTokensSuccess() async throws {
        let response = try await core.listTokens()
        XCTAssertEqual(response, listTokensResponseStub1)
    }

    func testListTokensFailure() async {
        let companion = TokensAPIMock.ListTokensCompanion()
        companion.throwableError = DummyError.something
        tokensAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listTokens()
        }
    }

    // MARK: - Transfer

    func testGetTransferSuccess() async throws {
        let response = try await core.getTransfer(id: "")
        XCTAssertEqual(response, transferStub1)
    }

    func testGetTransferFailure() async {
        let companion = TransfersAPIMockGetTransferCompanion()
        companion.throwableError = DummyError.something
        transfersAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.getTransfer(id: "")
        }
    }

    func testListTransfersSuccess() async throws {
        let response = try await core.listTransfers()
        XCTAssertEqual(response, listTransfersStub1)
    }

    func testListTransfersFailure() async {
        let companion = TransfersAPIMockListTransfersCompanion()
        companion.throwableError = DummyError.something
        transfersAPIMock.mock(companion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.listTransfers()
        }
    }

    func testBatchTransferSuccess() async throws {
        let response = try await core.batchTransfer(
            transfers: [
                .init(token: ethAssetStub1, recipientAddress: ""),
            ],
            signer: SignerMock(),
            starkSigner: StarkSignerMock()
        )
        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testBatchTransferFailure() async {
        let transferCompanion = TransferWorkflowCompanion()
        transferCompanion.throwableError = DummyError.something
        transferWorkflowMock.mock(transferCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await core.batchTransfer(
                transfers: [
                    .init(token: ethAssetStub1, recipientAddress: ""),
                ],
                signer: SignerMock(),
                starkSigner: StarkSignerMock()
            )
        }
    }
}
