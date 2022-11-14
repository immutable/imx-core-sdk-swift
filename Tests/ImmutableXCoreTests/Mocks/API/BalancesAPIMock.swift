import Foundation
@testable import ImmutableXCore

final class BalancesAPIMock: BalancesAPI {
    class GetBalanceCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Balance!
    }

    class ListBalancesCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListBalancesResponse!
    }

    static var getBalanceCompanion: GetBalanceCompanion?
    static var listBalancesCompanion: ListBalancesCompanion?

    static func mock(_ companion: GetBalanceCompanion) {
        getBalanceCompanion = companion
    }

    static func mock(_ companion: ListBalancesCompanion) {
        listBalancesCompanion = companion
    }

    static func resetMock() {
        getBalanceCompanion = nil
        listBalancesCompanion = nil
    }

    override class func getBalance(owner: String, address: String) async throws -> Balance {
        let companion = getBalanceCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listBalances(owner: String) async throws -> ListBalancesResponse {
        let companion = listBalancesCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
