import Foundation
@testable import ImmutableXCore

class OrdersAPIMockGetCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: Order!
}

class OrdersAPIMockGetSignableCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetSignableOrderResponse!
}

class OrdersAPIMockCreateOrderCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateOrderResponse!
}

public class OrdersAPIMock: OrdersAPI {
    static var requests: [String: OrdersAPIMockGetCompanion] = [:]
    static var getSinableCompanion: OrdersAPIMockGetSignableCompanion?
    static var createOrderCompanion: OrdersAPIMockCreateOrderCompanion?

    static func mock(_ companion: OrdersAPIMockGetCompanion, id: String) {
        requests[id] = companion
    }

    static func mock(_ companion: OrdersAPIMockGetSignableCompanion) {
        getSinableCompanion = companion
    }

    static func mock(_ companion: OrdersAPIMockCreateOrderCompanion) {
        createOrderCompanion = companion
    }

    static func resetMock() {
        requests.removeAll()
        getSinableCompanion = nil
        createOrderCompanion = nil
    }

    // MARK: - getOrder

    override public class func getOrder(id: String, includeFees: Bool? = nil, auxiliaryFeePercentages: String? = nil, auxiliaryFeeRecipients: String? = nil) async throws -> Order {
        let companion = requests[id]!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - getSignableOrder

    override public class func getSignableOrder(getSignableOrderRequestV3: GetSignableOrderRequest) async throws -> GetSignableOrderResponse {
        let companion = getSinableCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - createOrder

    override public class func createOrder(createOrderRequest: CreateOrderRequest, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) async throws -> CreateOrderResponse {
        let companion = createOrderCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
