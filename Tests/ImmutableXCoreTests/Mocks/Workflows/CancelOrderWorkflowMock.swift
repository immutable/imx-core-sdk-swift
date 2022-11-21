import Foundation
@testable import ImmutableXCore

class CancelOrderWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CancelOrderResponse!
}

class CancelOrderWorkflowMock: CancelOrderWorkflow {
    static var requests: [String: CancelOrderWorkflowCompanion] = [:]

    static func mock(_ companion: CancelOrderWorkflowCompanion, id: String) {
        requests[id] = companion
    }

    static func resetMock() {
        requests.removeAll()
    }

    override class func cancel(
        orderId: String,
        signer: Signer,
        starkSigner: StarkSigner,
        ordersAPI: OrdersAPI.Type = OrdersAPI.self
    ) async throws -> CancelOrderResponse {
        let companion = requests[orderId]!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
