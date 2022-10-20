@testable import ImmutableXCore
import XCTest

final class ImmutableXTests: XCTestCase {
    let buyWorkflow = BuyWorkflowMock.self
    let sellWorkflow = SellWorkflowMock.self
    let cancelOrderWorkflow = CancelOrderWorkflowMock.self
    let transferWorkflowMock = TransferWorkflowMock.self
    let registerWorkflowMock = RegisterWorkflowMock.self
    let buyCryptoWorkflowMock = BuyCryptoWorkflowMock.self

    lazy var core = ImmutableX(buyWorkflow: buyWorkflow, sellWorkflow: sellWorkflow, cancelOrderWorkflow: cancelOrderWorkflow, transferWorkflow: transferWorkflowMock, registerWorkflow: registerWorkflowMock, buyCryptoWorkflow: buyCryptoWorkflowMock)

    override func setUp() {
        super.setUp()
        buyWorkflow.resetMock()
        sellWorkflow.resetMock()
        cancelOrderWorkflow.resetMock()
        transferWorkflowMock.resetMock()
        registerWorkflowMock.resetMock()
        buyCryptoWorkflowMock.resetMock()
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
    }

    func testSdkVersion() {
        XCTAssertEqual(ImmutableX.shared.sdkVersion, "0.3.1")
    }

    func testInitialize() {
        ImmutableX.initialize(base: .ropsten, logLevel: .calls(including: [.requestBody]))
        XCTAssertEqual(ImmutableX.shared.base, .ropsten)

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

    func testBuyFlowSuccessClosure() {
        let expectation = expectation(description: "testBuyFlowSuccessClosure")

        core.buy(orderId: "1", fees: [feeEntryStub1], signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case let .success(response):
                XCTAssertEqual(response, createTradeResponseStub1)
            case .failure:
                XCTFail("Should not have failed")
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    func testBuyFlowFailureClosure() {
        let buyCompanion = BuyWorkflowCompanion()
        buyCompanion.throwableError = DummyError.something
        buyWorkflow.mock(buyCompanion, id: "1")

        let expectation = expectation(description: "testBuyFlowFailureClosure")
        core.buy(orderId: "1", fees: [feeEntryStub1], signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTFail("Should not have succeeded")
            case .failure:
                break
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
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

    func testSellFlowSuccessClosure() {
        let expectation = expectation(description: "testSellFlowSuccessClosure")

        core.sell(asset: erc721AssetStub1, sellToken: erc20AssetStub1, fees: [], signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case let .success(response):
                XCTAssertEqual(response, createOrderResponseStub1)
            case .failure:
                XCTFail("Should not have failed")
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    func testSellFlowFailureClosure() {
        let sellCompanion = SellWorkflowCompanion()
        sellCompanion.throwableError = DummyError.something
        sellWorkflow.mock(sellCompanion)

        let expectation = expectation(description: "testSellFlowFailureClosure")
        core.sell(asset: erc721AssetStub1, sellToken: erc20AssetStub1, fees: [], signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTFail("Should not have succeeded")
            case .failure:
                break
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
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

    func testCancelOrderFlowSuccessClosure() {
        let expectation = expectation(description: "testCancelOrderFlowSuccessClosure")

        core.cancelOrder(orderId: "1", signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case let .success(response):
                XCTAssertEqual(response, cancelOrderResponseStub1)
            case .failure:
                XCTFail("Should not have failed")
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    func testCancelOrderFlowFailureClosure() {
        let cancelOrderCompanion = CancelOrderWorkflowCompanion()
        cancelOrderCompanion.throwableError = DummyError.something
        cancelOrderWorkflow.mock(cancelOrderCompanion, id: "1")

        let expectation = expectation(description: "testCancelOrderFlowFailureClosure")
        core.cancelOrder(orderId: "1", signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTFail("Should not have succeeded")
            case .failure:
                break
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
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

    func testTransferFlowSuccessClosure() {
        let expectation = expectation(description: "testTransferFlowSuccessClosure")

        core.transfer(token: ETHAsset(quantity: "10"), recipientAddress: "address", signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case let .success(response):
                XCTAssertEqual(response, createTransferResponseStub1)
            case .failure:
                XCTFail("Should not have failed")
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    func testTransferFlowFailureClosure() {
        let transferCompanion = TransferWorkflowCompanion()
        transferCompanion.throwableError = DummyError.something
        transferWorkflowMock.mock(transferCompanion)

        let expectation = expectation(description: "testTransferFlowFailureClosure")

        core.transfer(token: ETHAsset(quantity: "10"), recipientAddress: "address", signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTFail("Should not have succeeded")
            case .failure:
                break
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
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

    func testRegisterFlowSuccessClosure() {
        let expectation = expectation(description: "testRegisterFlowSuccessClosure")

        core.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock()) { [weak self] result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTAssertEqual(self?.registerWorkflowMock.companion.callsCount, 1)
            case .failure:
                XCTFail("Should not have failed")
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    func testRegisterFlowFailureClosure() {
        let registerCompanion = RegisterWorkflowCompanion()
        registerCompanion.throwableError = DummyError.something
        registerWorkflowMock.mock(registerCompanion)

        let expectation = expectation(description: "testRegisterFlowFailureClosure")

        core.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock()) { result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTFail("Should not have succeeded")
            case .failure:
                break
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
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

    func testBuyCryptoFlowSuccessClosure() {
        let expectation = expectation(description: "testBuyCryptoFlowSuccessClosure")

        core.buyCryptoURL(signer: SignerMock()) { result in
            expectation.fulfill()
            switch result {
            case let .success(url):
                XCTAssertEqual(url, "expected url")
            case .failure:
                XCTFail("Should not have failed")
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    func testBuyCryptoFlowFailureClosure() {
        let buyCryptoCompanion = BuyCryptoWorkflowCompanion()
        buyCryptoCompanion.throwableError = DummyError.something
        buyCryptoWorkflowMock.mock(buyCryptoCompanion)

        let expectation = expectation(description: "testBuyCryptoFlowFailureClosure")

        core.buyCryptoURL(signer: SignerMock()) { result in
            expectation.fulfill()
            switch result {
            case .success:
                XCTFail("Should not have succeeded")
            case .failure:
                break
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }
}
