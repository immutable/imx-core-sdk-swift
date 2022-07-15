import Foundation
@testable import ImmutableXCore

class OrdersAPIMockGetCompanion {
    var getOrderThrowableError: Error?
    var getOrderCallsCount = 0
    var getOrderReceivedArguments: (id: String, includeFees: Bool?, auxiliaryFeePercentages: String?, auxiliaryFeeRecipients: String?)?
    var getOrderReturnValue: Order!
}

public class OrdersAPIMock: OrdersAPI {
    static var requests: [String: OrdersAPIMockGetCompanion] = [:]

    static func mock(_ companion: OrdersAPIMockGetCompanion, id: String) {
        requests[id] = companion
    }

    static func tearDown() {
        requests.removeAll()
    }

    // MARK: - getOrder

    override public class func getOrder(id: String, includeFees: Bool? = nil, auxiliaryFeePercentages: String? = nil, auxiliaryFeeRecipients: String? = nil) async throws -> Order {
        let companion = requests[id]!

        if let error = companion.getOrderThrowableError {
            throw error
        }

        companion.getOrderCallsCount += 1
        companion.getOrderReceivedArguments = (id: id, includeFees: includeFees, auxiliaryFeePercentages: auxiliaryFeePercentages, auxiliaryFeeRecipients: auxiliaryFeeRecipients)
        return companion.getOrderReturnValue
    }
}
