import Foundation
@testable import ImmutableXCore

class ExchangesAPIMockTransactionIdCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetTransactionIdResponse!
}

class ExchangesAPIMockCurrenciesCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetCurrenciesResponse!
}

class ExchangesAPIMock: ExchangesAPI {
    var transactionIdCompanion: ExchangesAPIMockTransactionIdCompanion?
    var currenciesCompanion: ExchangesAPIMockCurrenciesCompanion?

    func mock(_ companion: ExchangesAPIMockTransactionIdCompanion) {
        transactionIdCompanion = companion
    }

    func mock(_ companion: ExchangesAPIMockCurrenciesCompanion) {
        currenciesCompanion = companion
    }

    func resetMock() {
        transactionIdCompanion = nil
        currenciesCompanion = nil
    }

    // MARK: - getTransactionId

    override func getTransactionId(_ request: GetTransactionIdRequest) async throws -> GetTransactionIdResponse {
        let companion = transactionIdCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    // MARK: - getCurrencies

    override func getCurrencies(address: String) async throws -> GetCurrenciesResponse {
        let companion = currenciesCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
