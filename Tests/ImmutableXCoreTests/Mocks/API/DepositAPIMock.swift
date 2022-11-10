import Foundation
@testable import ImmutableXCore

final class DepositAPIMock: DepositsAPI {
    class GetDepositCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Deposit!
    }

    class ListDepositsCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListDepositsResponse!
    }

    static var getDepositCompanion: GetDepositCompanion?
    static var listDepositsCompanion: ListDepositsCompanion?

    static func mock(_ companion: GetDepositCompanion) {
        getDepositCompanion = companion
    }

    static func mock(_ companion: ListDepositsCompanion) {
        listDepositsCompanion = companion
    }

    static func resetMock() {
        getDepositCompanion = nil
        listDepositsCompanion = nil
    }

    override class func getDeposit(id: String) async throws -> Deposit {
        let companion = getDepositCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listDeposits(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: String? = nil,
        direction: String? = nil,
        user: String? = nil,
        status: String? = nil,
        updatedMinTimestamp: String? = nil,
        updatedMaxTimestamp: String? = nil,
        tokenType: String? = nil,
        tokenId: String? = nil,
        assetId: String? = nil,
        tokenAddress: String? = nil,
        tokenName: String? = nil,
        minQuantity: String? = nil,
        maxQuantity: String? = nil,
        metadata: String? = nil
    ) async throws -> ListDepositsResponse {
        let companion = listDepositsCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
