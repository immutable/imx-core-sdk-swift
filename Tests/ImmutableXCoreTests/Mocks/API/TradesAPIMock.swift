import Foundation
@testable import ImmutableXCore

class TradesAPIMockGetTradeCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: Trade!
}

class TradesAPIMockListTradesCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: ListTradesResponse!
}

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
    static var getTradeCompanion: TradesAPIMockGetTradeCompanion?
    static var listTradesCompanion: TradesAPIMockListTradesCompanion?

    static func mock(_ companion: TradesAPIMockGetTradeCompanion) {
        getTradeCompanion = companion
    }

    static func mock(_ companion: TradesAPIMockListTradesCompanion) {
        listTradesCompanion = companion
    }

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

    // MARK: - getTrade

    override class func getTrade(id: String) async throws -> Trade {
        let companion = getTradeCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - listTrades

    override class func listTrades(
        partyAOrderId: String? = nil,
        partyATokenType: String? = nil,
        partyATokenAddress: String? = nil,
        partyBOrderId: String? = nil,
        partyBTokenType: String? = nil,
        partyBTokenAddress: String? = nil,
        partyBTokenId: String? = nil,
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: String? = nil,
        direction: String? = nil,
        minTimestamp: String? = nil,
        maxTimestamp: String? = nil
    ) async throws -> ListTradesResponse {
        let companion = listTradesCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
