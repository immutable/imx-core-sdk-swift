import Foundation
@testable import ImmutableXCore

class BuyWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateTradeResponse!
}

class BuyWorkflowMock: BuyWorkflow {
    static var requests: [String: BuyWorkflowCompanion] = [:]

    static func mock(_ companion: BuyWorkflowCompanion, id: String) {
        requests[id] = companion
    }

    static func resetMock() {
        requests.removeAll()
    }

    override class func buy(orderId: String, fees _: [FeeEntry], signer _: Signer, starkSigner _: StarkSigner, ordersAPI _: OrdersAPI.Type = OrdersAPI.self, tradesAPI _: TradesAPI.Type = TradesAPI.self) async throws -> CreateTradeResponse {
        let companion = requests[orderId]!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
