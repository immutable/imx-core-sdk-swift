import Foundation
@testable import ImmutableXCore

final class MintsAPIMock: MintsAPI {
    class GetMintCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Mint!
    }

    class ListMintsCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListMintsResponse!
    }

    static var getMintCompanion: GetMintCompanion?
    static var listMintsCompanion: ListMintsCompanion?

    static func mock(_ companion: GetMintCompanion) {
        getMintCompanion = companion
    }

    static func mock(_ companion: ListMintsCompanion) {
        listMintsCompanion = companion
    }

    static func resetMock() {
        getMintCompanion = nil
        listMintsCompanion = nil
    }

    override class func getMint(id: String) async throws -> Mint {
        let companion = getMintCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listMints(
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
        tokenName: String? = nil,
        tokenAddress: String? = nil,
        minQuantity: String? = nil,
        maxQuantity: String? = nil,
        metadata: String? = nil
    ) async throws -> ListMintsResponse {
        let companion = listMintsCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
