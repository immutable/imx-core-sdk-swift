@testable import ImmutableXCore
import XCTest

final class SellWorkflowTests: XCTestCase {
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

    func testSellFlowSuccess() async throws {
        let response = try await SellWorkflow.sell(
            asset: erc721AssetStub1,
            sellToken: erc20AssetStub1,
            fees: [],
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            ordersAPI: ordersAPI
        )

        XCTAssertEqual(response, createOrderResponseStub1)
    }

    func testSellFlowFailureWhenSignableOrderThrows() async throws {
        let signableCompanion = OrdersAPIMockGetSignableCompanion()
        signableCompanion.throwableError = DummyError.something
        ordersAPI.mock(signableCompanion)

        do {
            _ = try await SellWorkflow.sell(
                asset: erc721AssetStub1,
                sellToken: erc20AssetStub1,
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: ordersAPI
            )

            XCTFail("Should have not succeeded")
        } catch {
            XCTAssertTrue(error is WorkflowError, "non-Immutable X errors gets mapped to WorkflowError")
        }
    }

    func testSellFlowFailureWhenCreateOrderThrows() async throws {
        let createOrderCompanion = OrdersAPIMockCreateOrderCompanion()
        createOrderCompanion.throwableError = DummyError.something
        ordersAPI.mock(createOrderCompanion)

        do {
            _ = try await SellWorkflow.sell(
                asset: erc721AssetStub1,
                sellToken: erc20AssetStub1,
                fees: [],
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: ordersAPI
            )

            XCTFail("Should have not succeeded")
        } catch {
            XCTAssertTrue(error is WorkflowError, "non-Immutable X errors gets mapped to WorkflowError")
        }
    }
}
