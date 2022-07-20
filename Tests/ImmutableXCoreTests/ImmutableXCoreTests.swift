@testable import ImmutableXCore
import XCTest

final class ImmutableXCoreTests: XCTestCase {
    let buyWorkflow = BuyWorkflowMock.self
    let sellWorkflow = SellWorkflowMock.self
    lazy var core = ImmutableXCore(buyWorkflow: buyWorkflow, sellWorkflow: sellWorkflow)

    override func setUp() {
        super.setUp()
        buyWorkflow.resetMock()
        sellWorkflow.resetMock()
        ImmutableXCore.initialize()

        let buyCompanion = BuyWorkflowCompanion()
        buyCompanion.returnValue = createTradeResponseStub1
        buyWorkflow.mock(buyCompanion, id: "1")

        let sellCompanion = SellWorkflowCompanion()
        sellCompanion.returnValue = createOrderResponseStub1
        sellWorkflow.mock(sellCompanion)
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
}
