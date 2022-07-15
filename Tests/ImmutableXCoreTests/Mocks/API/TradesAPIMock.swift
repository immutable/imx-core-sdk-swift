import Foundation
@testable import ImmutableXCore

class TradesAPIMockGetCompanion {
    var getSignableTradeThrowableError: Error?
    var getSignableTradeCallsCount = 0
    var getSignableTradeTradeRequest: GetSignableTradeRequest?
    var getSignableTradeReturnValue: GetSignableTradeResponse!
}

class TradesAPIMockCreateCompanion {
    var createTradeThrowableError: Error?
    var createTradeCallsCount = 0
    var createTradeReceivedArguments: (createTradeRequest: CreateTradeRequestV1, xImxEthAddress: String?, xImxEthSignature: String?)?
    var createTradeReturnValue: CreateTradeResponse!
}

final class TradesAPIMock: TradesAPI {
    static var getRequests: [Int: TradesAPIMockGetCompanion] = [:]
    static var createRequests: [Int: TradesAPIMockCreateCompanion] = [:]

    static func mock(_ companion: TradesAPIMockGetCompanion, id: Int) {
        getRequests[id] = companion
    }

    static func mock(_ companion: TradesAPIMockCreateCompanion, id: Int) {
        createRequests[id] = companion
    }

    static func tearDown() {
        getRequests.removeAll()
        createRequests.removeAll()
    }

    // MARK: - getSignableTrade

    override public class func getSignableTrade(getSignableTradeRequest: GetSignableTradeRequest) async throws -> GetSignableTradeResponse {
        let companion = getRequests[getSignableTradeRequest.orderId]!
        if let error = companion.getSignableTradeThrowableError {
            throw error
        }

        companion.getSignableTradeCallsCount += 1
        companion.getSignableTradeTradeRequest = getSignableTradeRequest
        return companion.getSignableTradeReturnValue
    }

    // MARK: - createTrade

    override public class func createTrade(createTradeRequest: CreateTradeRequestV1, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) async throws -> CreateTradeResponse {
        let companion = createRequests[createTradeRequest.orderId]!

        if let error = companion.createTradeThrowableError {
            throw error
        }

        companion.createTradeCallsCount += 1
        companion.createTradeReceivedArguments = (createTradeRequest: createTradeRequest, xImxEthAddress: xImxEthAddress, xImxEthSignature: xImxEthSignature)
        return companion.createTradeReturnValue
    }
}
