@testable import ImmutableXCore
import XCTest

final class ImmutableXTests: XCTestCase {
    let buyWorkflow = BuyWorkflowMock.self
    let sellWorkflow = SellWorkflowMock.self
    let cancelOrderWorkflow = CancelOrderWorkflowMock.self
    let transferWorkflowMock = TransferWorkflowMock.self
    let registerWorkflowMock = RegisterWorkflowMock.self
    let buyCryptoWorkflowMock = BuyCryptoWorkflowMock.self
    let usersAPIMock = UsersAPIMock.self
    let depositAPIMock = DepositAPIMock.self
    let assetsAPIMock = AssetsAPIMock.self
    let collectionsAPIMock = CollectionsAPIMock.self
    let projectsAPIMock = ProjectsAPIMock.self
    let balancesAPIMock = BalancesAPIMock.self
    let mintsAPIMock = MintsAPIMock.self

    lazy var core = ImmutableX(
        buyWorkflow: buyWorkflow,
        sellWorkflow: sellWorkflow,
        cancelOrderWorkflow: cancelOrderWorkflow,
        transferWorkflow: transferWorkflowMock,
        registerWorkflow: registerWorkflowMock,
        buyCryptoWorkflow: buyCryptoWorkflowMock,
        usersAPI: usersAPIMock,
        depositAPI: depositAPIMock,
        assetsAPI: assetsAPIMock,
        collectionsAPI: collectionsAPIMock,
        projectsAPI: projectsAPIMock,
        balancesAPI: balancesAPIMock,
        mintsAPI: mintsAPIMock
    )

    override func setUp() {
        super.setUp()
        buyWorkflow.resetMock()
        sellWorkflow.resetMock()
        cancelOrderWorkflow.resetMock()
        transferWorkflowMock.resetMock()
        registerWorkflowMock.resetMock()
        buyCryptoWorkflowMock.resetMock()
        usersAPIMock.resetMock()
        depositAPIMock.resetMock()
        assetsAPIMock.resetMock()
        collectionsAPIMock.resetMock()
        projectsAPIMock.resetMock()
        balancesAPIMock.resetMock()
        mintsAPIMock.resetMock()

        ImmutableX.initialize()

        let buyCompanion = BuyWorkflowCompanion()
        buyCompanion.returnValue = createTradeResponseStub1
        buyWorkflow.mock(buyCompanion, id: "1")

        let sellCompanion = SellWorkflowCompanion()
        sellCompanion.returnValue = createOrderResponseStub1
        sellWorkflow.mock(sellCompanion)

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
        depositAPIMock.mock(depositCompanion)

        let listDepositsCompanion = DepositAPIMock.ListDepositsCompanion()
        listDepositsCompanion.returnValue = listDepositResponsesStub1
        depositAPIMock.mock(listDepositsCompanion)

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

    // MARK: - Buy

    func testBuyFlowSuccessAsync() async throws {
        let response = try await core.buy(orderId: "1", fees: [feeEntryStub1], signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, createTradeResponseStub1)
    }

    func testBuyFlowFailureAsync() async {
        let buyCompanion = BuyWorkflowCompanion()
        buyCompanion.throwableError = DummyError.something
        buyWorkflow.mock(buyCompanion, id: "1")

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.buy(orderId: "1", fees: [feeEntryStub1], signer: SignerMock(), starkSigner: StarkSignerMock())
        }
    }

    // MARK: - Sell

    func testSellFlowSuccessAsync() async throws {
        let response = try await core.sell(asset: erc721AssetStub1, sellToken: erc20AssetStub1, fees: [], signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, createOrderResponseStub1)
    }

    func testSellFlowFailureAsync() async {
        let sellCompanion = SellWorkflowCompanion()
        sellCompanion.throwableError = DummyError.something
        sellWorkflow.mock(sellCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.sell(asset: erc721AssetStub1, sellToken: erc20AssetStub1, fees: [], signer: SignerMock(), starkSigner: StarkSignerMock())
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
        let response = try await core.transfer(token: ETHAsset(quantity: "10"), recipientAddress: "address", signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testTransferFlowFailureAsync() async {
        let transferCompanion = TransferWorkflowCompanion()
        transferCompanion.throwableError = DummyError.something
        transferWorkflowMock.mock(transferCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await self.core.transfer(token: ETHAsset(quantity: "10"), recipientAddress: "address", signer: SignerMock(), starkSigner: StarkSignerMock())
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
        depositAPIMock.mock(companion)

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
        depositAPIMock.mock(companion)

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
}
