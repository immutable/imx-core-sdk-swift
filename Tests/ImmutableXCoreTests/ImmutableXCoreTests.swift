@testable import ImmutableXCore
import XCTest

final class ImmutableXCoreTests: XCTestCase {
    let buyWorkflow = BuyWorkflowMock.self
    let sellWorkflow = SellWorkflowMock.self
    let cancelOrderWorkflow = CancelOrderWorkflowMock.self
    let transferWorkflowMock = TransferWorkflowMock.self
    lazy var core = ImmutableXCore(buyWorkflow: buyWorkflow, sellWorkflow: sellWorkflow, cancelOrderWorkflow: cancelOrderWorkflow, transferWorkflow: transferWorkflowMock)

    override func setUp() {
        super.setUp()
        buyWorkflow.resetMock()
        sellWorkflow.resetMock()
        cancelOrderWorkflow.resetMock()
        transferWorkflowMock.resetMock()
        ImmutableXCore.initialize()

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
    }

    func testSdkVersion() {
        XCTAssertEqual(ImmutableXCore.shared.sdkVersion, "0.1.0")
    }

    func testInitialize() {
        ImmutableXCore.initialize(base: .ropsten, logLevel: .calls(including: [.requestBody]))
        XCTAssertEqual(ImmutableXCore.shared.base, .ropsten)

        if case .calls(including: [.requestBody]) = ImmutableXCore.shared.logLevel {
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

    func testBuyFlowFailureAsync() async throws {
        let buyCompanion = BuyWorkflowCompanion()
        buyCompanion.throwableError = DummyError.something
        buyWorkflow.mock(buyCompanion, id: "1")

        do {
            _ = try await core.buy(orderId: "1", fees: [feeEntryStub1], signer: SignerMock(), starkSigner: StarkSignerMock())
            XCTFail("Should have failed")
        } catch {
            XCTAssertTrue(error is DummyError)
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
            case let .failure(error):
                XCTAssertTrue(error is DummyError)
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    // MARK: - Sell

    func testSellFlowSuccessAsync() async throws {
        let response = try await core.sell(asset: erc721AssetStub1, sellToken: erc20AssetStub1, fees: [], signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, createOrderResponseStub1)
    }

    func testSellFlowFailureAsync() async throws {
        let sellCompanion = SellWorkflowCompanion()
        sellCompanion.throwableError = DummyError.something
        sellWorkflow.mock(sellCompanion)

        do {
            _ = try await core.sell(asset: erc721AssetStub1, sellToken: erc20AssetStub1, fees: [], signer: SignerMock(), starkSigner: StarkSignerMock())
            XCTFail("Should have failed")
        } catch {
            XCTAssertTrue(error is DummyError)
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
            case let .failure(error):
                XCTAssertTrue(error is DummyError)
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    // MARK: - Cancel

    func testCancelOrderFlowSuccessAsync() async throws {
        let response = try await core.cancelOrder(orderId: "1", signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, cancelOrderResponseStub1)
    }

    func testCancelOrderFlowFailureAsync() async throws {
        let cancelOrderCompanion = CancelOrderWorkflowCompanion()
        cancelOrderCompanion.throwableError = DummyError.something
        cancelOrderWorkflow.mock(cancelOrderCompanion, id: "1")

        do {
            _ = try await core.cancelOrder(orderId: "1", signer: SignerMock(), starkSigner: StarkSignerMock())
            XCTFail("Should have failed")
        } catch {
            XCTAssertTrue(error is DummyError)
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
            case let .failure(error):
                XCTAssertTrue(error is DummyError)
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }

    // MARK: - Transfer

    func testTransferFlowSuccessAsync() async throws {
        let response = try await core.transfer(token: ETHAsset(quantity: "10"), recipientAddress: "address", signer: SignerMock(), starkSigner: StarkSignerMock())
        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testTransferFlowFailureAsync() async throws {
        let transferCompanion = TransferWorkflowCompanion()
        transferCompanion.throwableError = DummyError.something
        transferWorkflowMock.mock(transferCompanion)

        do {
            _ = try await core.transfer(token: ETHAsset(quantity: "10"), recipientAddress: "address", signer: SignerMock(), starkSigner: StarkSignerMock())
            XCTFail("Should have failed")
        } catch {
            XCTAssertTrue(error is DummyError)
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
            case let .failure(error):
                XCTAssertTrue(error is DummyError)
            }
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: 30), .completed)
    }
}
