import Foundation
@testable import ImmutableXCore

class CreateOrderWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateOrderResponse!
}

class CreateOrderWorkflowMock: CreateOrderWorkflow {
    static var companion: CreateOrderWorkflowCompanion?

    static func mock(_ companion: CreateOrderWorkflowCompanion) {
        self.companion = companion
    }

    static func resetMock() {
        companion = nil
    }

    override class func createOrder(
        asset: AssetModel,
        sellToken: AssetModel,
        fees: [FeeEntry],
        signer: Signer,
        starkSigner: StarkSigner,
        ordersAPI: OrdersAPI.Type
    ) async throws -> CreateOrderResponse {
        let companion = companion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
