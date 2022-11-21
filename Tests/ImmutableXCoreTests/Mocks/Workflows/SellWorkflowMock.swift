import Foundation
@testable import ImmutableXCore

class SellWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateOrderResponse!
}

class SellWorkflowMock: SellWorkflow {
    static var companion: SellWorkflowCompanion?

    static func mock(_ companion: SellWorkflowCompanion) {
        self.companion = companion
    }

    static func resetMock() {
        companion = nil
    }

    override class func sell(
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
