import Foundation
@testable import ImmutableXCore

class TradesAPIMockGetCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetSignableTradeResponse!
}

class TradesAPIMockCreateCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateTradeResponse!
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

    static func resetMock() {
        getRequests.removeAll()
        createRequests.removeAll()
    }

    // MARK: - getSignableTrade

    override public class func getSignableTrade(getSignableTradeRequest: GetSignableTradeRequest) async throws -> GetSignableTradeResponse {
        let companion = getRequests[getSignableTradeRequest.orderId]!
        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - createTrade

    override public class func createTrade(xImxEthAddress: String, xImxEthSignature: String, createTradeRequest: CreateTradeRequestV1) async throws -> CreateTradeResponse {
        let companion = createRequests[createTradeRequest.orderId]!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
