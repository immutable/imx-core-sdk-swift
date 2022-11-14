import Foundation
@testable import ImmutableXCore

final class WithdrawalsAPIMock: WithdrawalsAPI {
    class GetWithdrawalCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Withdrawal!
    }

    class ListWithdrawalsCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListWithdrawalsResponse!
    }

    static var getWithdrawalCompanion: GetWithdrawalCompanion?
    static var listWithdrawalsCompanion: ListWithdrawalsCompanion?

    static func mock(_ companion: GetWithdrawalCompanion) {
        getWithdrawalCompanion = companion
    }

    static func mock(_ companion: ListWithdrawalsCompanion) {
        listWithdrawalsCompanion = companion
    }

    static func resetMock() {
        getWithdrawalCompanion = nil
        listWithdrawalsCompanion = nil
    }

    override class func getWithdrawal(id: String) async throws -> Withdrawal {
        let companion = getWithdrawalCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listWithdrawals(
        withdrawnToWallet: Bool? = nil,
        rollupStatus: String? = nil,
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: String? = nil,
        direction: String? = nil,
        user: String? = nil,
        status: String? = nil,
        minTimestamp: String? = nil,
        maxTimestamp: String? = nil,
        tokenType: String? = nil,
        tokenId: String? = nil,
        assetId: String? = nil,
        tokenAddress: String? = nil,
        tokenName: String? = nil,
        minQuantity: String? = nil,
        maxQuantity: String? = nil,
        metadata: String? = nil
    ) async throws -> ListWithdrawalsResponse {
        let companion = listWithdrawalsCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
