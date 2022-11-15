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

class OrdersAPIMockGetSignableCancelCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetSignableCancelOrderResponse!
}

class OrdersAPIMockCancelOrderCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CancelOrderResponse!
}

class OrdersAPIMockListOrdersCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: ListOrdersResponse!
}

public class OrdersAPIMock: OrdersAPI {
    static var requests: [String: OrdersAPIMockGetCompanion] = [:]
    static var getSignableCompanion: OrdersAPIMockGetSignableCompanion?
    static var createOrderCompanion: OrdersAPIMockCreateOrderCompanion?
    static var getSignableCancelCompanion: OrdersAPIMockGetSignableCancelCompanion?
    static var cancelOrderCompanion: OrdersAPIMockCancelOrderCompanion?
    static var listOrdersCompanion: OrdersAPIMockListOrdersCompanion?

    static func mock(_ companion: OrdersAPIMockGetCompanion, id: String) {
        requests[id] = companion
    }

    static func mock(_ companion: OrdersAPIMockGetSignableCompanion) {
        getSignableCompanion = companion
    }

    static func mock(_ companion: OrdersAPIMockCreateOrderCompanion) {
        createOrderCompanion = companion
    }

    static func mock(_ companion: OrdersAPIMockGetSignableCancelCompanion) {
        getSignableCancelCompanion = companion
    }

    static func mock(_ companion: OrdersAPIMockCancelOrderCompanion) {
        cancelOrderCompanion = companion
    }

    static func mock(_ companion: OrdersAPIMockListOrdersCompanion) {
        listOrdersCompanion = companion
    }

    static func resetMock() {
        requests.removeAll()
        getSignableCompanion = nil
        createOrderCompanion = nil
        getSignableCancelCompanion = nil
        cancelOrderCompanion = nil
        listOrdersCompanion = nil
    }

    // MARK: - getOrder

    override public class func getOrder(
        id: String,
        includeFees: Bool? = nil,
        auxiliaryFeePercentages: String? = nil,
        auxiliaryFeeRecipients: String? = nil
    ) async throws -> Order {
        let companion = requests[id]!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - getSignableOrder

    override public class func getSignableOrder(
        getSignableOrderRequestV3: GetSignableOrderRequest
    ) async throws -> GetSignableOrderResponse {
        let companion = getSignableCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - createOrder

    override public class func createOrder(
        xImxEthAddress: String,
        xImxEthSignature: String,
        createOrderRequest: CreateOrderRequest
    ) async throws -> CreateOrderResponse {
        let companion = createOrderCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - getSignableCancelOrder

    override public class func getSignableCancelOrder(
        getSignableCancelOrderRequest: GetSignableCancelOrderRequest
    ) async throws -> GetSignableCancelOrderResponse {
        let companion = getSignableCancelCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - cancelOrder

    override public class func cancelOrder(
        xImxEthAddress: String,
        xImxEthSignature: String,
        id: String,
        cancelOrderRequest: CancelOrderRequest
    ) async throws -> CancelOrderResponse {
        let companion = cancelOrderCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - listOrders

    override public class func listOrders(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: OrdersAPI.OrderBy_listOrders? = nil,
        direction: String? = nil,
        user: String? = nil,
        status: OrdersAPI.Status_listOrders? = nil,
        minTimestamp: String? = nil,
        maxTimestamp: String? = nil,
        updatedMinTimestamp: String? = nil,
        updatedMaxTimestamp: String? = nil,
        buyTokenType: String? = nil,
        buyTokenId: String? = nil,
        buyAssetId: String? = nil,
        buyTokenAddress: String? = nil,
        buyTokenName: String? = nil,
        buyMinQuantity: String? = nil,
        buyMaxQuantity: String? = nil,
        buyMetadata: String? = nil,
        sellTokenType: String? = nil,
        sellTokenId: String? = nil,
        sellAssetId: String? = nil,
        sellTokenAddress: String? = nil,
        sellTokenName: String? = nil,
        sellMinQuantity: String? = nil,
        sellMaxQuantity: String? = nil,
        sellMetadata: String? = nil,
        auxiliaryFeePercentages: String? = nil,
        auxiliaryFeeRecipients: String? = nil,
        includeFees: Bool? = nil
    ) async throws -> ListOrdersResponse {
        let companion = listOrdersCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
