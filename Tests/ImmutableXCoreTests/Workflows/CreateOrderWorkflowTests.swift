@testable import ImmutableXCore
import XCTest

final class CreateOrderWorkflowTests: XCTestCase {
    let ordersAPI = OrdersAPIMock.self

    override func setUp() {
        super.setUp()

        ordersAPI.resetMock()

        let signableCompanion = OrdersAPIMockGetSignableCompanion()
        signableCompanion.returnValue = signableOrderResponseStub1
        ordersAPI.mock(signableCompanion)

        let createOrderCompanion = OrdersAPIMockCreateOrderCompanion()
        createOrderCompanion.returnValue = createOrderResponseStub1
        ordersAPI.mock(createOrderCompanion)
    }

    func testCreateOrderFlowSuccess() async throws {
        let response = try await CreateOrderWorkflow.createOrder(
            asset: erc721AssetStub1,
            sellToken: erc20AssetStub1,
            fees: [],
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            ordersAPI: ordersAPI
        )

        XCTAssertEqual(response, createOrderResponseStub1)
    }

    func testCreateOrderFlowFailureWhenSignableOrderThrows() async {
        let signableCompanion = OrdersAPIMockGetSignableCompanion()
        signableCompanion.throwableError = DummyError.something
        ordersAPI.mock(signableCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateOrderWorkflow.createOrder(
                asset: erc721AssetStub1,
                sellToken: erc20AssetStub1,
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI
            )
        }
    }

    func testCreateOrderFlowFailureWhenCreateOrderThrows() async {
        let createOrderCompanion = OrdersAPIMockCreateOrderCompanion()
        createOrderCompanion.throwableError = DummyError.something
        ordersAPI.mock(createOrderCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await CreateOrderWorkflow.createOrder(
                asset: erc721AssetStub1,
                sellToken: erc20AssetStub1,
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: self.ordersAPI
            )
        }
    }
}
