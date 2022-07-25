@testable import ImmutableXCore
import XCTest

final class CancelOrderWorkflowTests: XCTestCase {
    let ordersAPI = OrdersAPIMock.self

    override func setUp() {
        super.setUp()

        ordersAPI.resetMock()

        let signableCompanion = OrdersAPIMockGetSignableCancelCompanion()
        signableCompanion.returnValue = signableCancelOrderResponseStub1
        ordersAPI.mock(signableCompanion)

        let cancelOrderCompanion = OrdersAPIMockCancelOrderCompanion()
        cancelOrderCompanion.returnValue = cancelOrderResponseStub1
        ordersAPI.mock(cancelOrderCompanion)
    }

    func testCancelFlowSuccess() async throws {
        let response = try await CancelOrderWorkflow.cancel(
            orderId: "1",
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            ordersAPI: ordersAPI
        )

        XCTAssertEqual(response, cancelOrderResponseStub1)
    }

    func testCancelFlowThrowsWhenGetSignableCancelOrderFails() async throws {
        let signableCompanion = OrdersAPIMockGetSignableCancelCompanion()
        signableCompanion.throwableError = DummyError.something
        ordersAPI.mock(signableCompanion)

        do {
            _ = try await CancelOrderWorkflow.cancel(
                orderId: "1",
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                ordersAPI: ordersAPI
            )

            XCTFail("Should have not succeeded")
        } catch {
            XCTAssertTrue(error is WorkflowError, "non-Immutable X errors gets mapped to WorkflowError")
        }
    }

    func testCancelFlowThrowsWhenCancelOrderFails() async throws {
        let cancelOrderCompanion = OrdersAPIMockCancelOrderCompanion()
        cancelOrderCompanion.throwableError = DummyError.something
        ordersAPI.mock(cancelOrderCompanion)

        do {
            _ = try await CancelOrderWorkflow.cancel(
                orderId: "1",
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
