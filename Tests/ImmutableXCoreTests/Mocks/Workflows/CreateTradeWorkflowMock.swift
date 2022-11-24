import Foundation
@testable import ImmutableXCore

class CreateTradeWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateTradeResponse!
}

class CreateTradeWorkflowMock: CreateTradeWorkflow {
    static var requests: [String: CreateTradeWorkflowCompanion] = [:]

    static func mock(_ companion: CreateTradeWorkflowCompanion, id: String) {
        requests[id] = companion
    }

    static func resetMock() {
        requests.removeAll()
    }

    override class func createTrade(
        orderId: String,
        fees _: [FeeEntry],
        signer _: Signer,
        starkSigner _: StarkSigner,
        ordersAPI _: OrdersAPI.Type = OrdersAPI.self,
        tradesAPI _: TradesAPI.Type = TradesAPI.self
    ) async throws -> CreateTradeResponse {
        let companion = requests[orderId]!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
