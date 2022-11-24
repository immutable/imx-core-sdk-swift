@testable import ImmutableXCore
import XCTest

final class CreateTradeWorkflowTests: XCTestCase {
    let ordersAPI = OrdersAPIMock.self
    let tradesAPI = TradesAPIMock.self

    override func setUp() {
        super.setUp()

        ordersAPI.resetMock()
        tradesAPI.resetMock()

        let orderCompanion = OrdersAPIMockGetCompanion()
        orderCompanion.returnValue = orderActiveStub2
        ordersAPI.mock(orderCompanion, id: "1")

        let tradeGetCompanion = TradesAPIMockGetCompanion()
        tradeGetCompanion.returnValue = signableTradeResponseStub1
        tradesAPI.mock(tradeGetCompanion, id: 1)

        let tradeCreateCompanion = TradesAPIMockCreateCompanion()
        tradeCreateCompanion.returnValue = createTradeResponseStub1
        tradesAPI.mock(tradeCreateCompanion, id: 1)
    }

    func testCreateTradeFlowSuccess() async throws {
        let response = try await CreateTradeWorkflow.createTrade(
            orderId: "1",
            fees: [feeEntryStub1],
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            ordersAPI: ordersAPI,
            tradesAPI: tradesAPI
        )

        XCTAssertEqual(response, createTradeResponseStub1)
    }

    func testCreateTradeFlowThrowsWhenFeePercentageIsInvalid() async {
        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [FeeEntry(address: "address", feePercentage: nil)],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }

    func testCreateTradeFlowThrowsWhenFeeAddressIsInvalid() async {
        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [FeeEntry(address: nil, feePercentage: 2)],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }

    func testCreateTradeFlowThrowsWhenPurchaseOwnOrder() async {
        let signer = SignerMock()
        signer.getAddressReturnValue = orderActiveStub2.user

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [],
                signer: signer,
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }

    func testCreateTradeFlowThrowsWhenOrderStatusIsNotActive() async {
        let orderCompanion = OrdersAPIMockGetCompanion()
        orderCompanion.returnValue = orderFilledStub1
        ordersAPI.mock(orderCompanion, id: "1")

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }

    func testCreateTradeFlowThrowsWhenGetOrderFails() async {
        let orderCompanion = OrdersAPIMockGetCompanion()
        orderCompanion.throwableError = DummyError.something
        ordersAPI.mock(orderCompanion, id: "1")

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }

    func testCreateTradeFlowThrowsWhenGetSignableTradeFails() async {
        let tradeGetCompanion = TradesAPIMockGetCompanion()
        tradeGetCompanion.throwableError = DummyError.something
        tradesAPI.mock(tradeGetCompanion, id: 1)

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }

    func testCreateTradeFlowThrowsWhenCreateSignableTradeFails() async {
        let tradeCreateCompanion = TradesAPIMockCreateCompanion()
        tradeCreateCompanion.throwableError = DummyError.something
        tradesAPI.mock(tradeCreateCompanion, id: 1)

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateTradeWorkflow.createTrade(
                orderId: "1",
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI,
                tradesAPI: self.tradesAPI
            )
        }
    }
}
