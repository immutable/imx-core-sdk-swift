import Foundation
@testable import ImmutableXCore

final class AssetsAPIMock: AssetsAPI {
    class GetAssetCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Asset!
    }

    class ListAssetsCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListAssetsResponse!
    }

    static var getAssetCompanion: GetAssetCompanion?
    static var listAssetsCompanion: ListAssetsCompanion?

    static func mock(_ companion: GetAssetCompanion) {
        getAssetCompanion = companion
    }

    static func mock(_ companion: ListAssetsCompanion) {
        listAssetsCompanion = companion
    }

    static func resetMock() {
        getAssetCompanion = nil
        listAssetsCompanion = nil
    }

    override class func getAsset(
        tokenAddress: String,
        tokenId: String,
        includeFees: Bool? = nil
    ) async throws -> Asset {
        let companion = getAssetCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listAssets(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: OrderBy_listAssets? = nil,
        direction: String? = nil,
        user: String? = nil,
        status: String? = nil,
        name: String? = nil,
        metadata: String? = nil,
        sellOrders: Bool? = nil,
        buyOrders: Bool? = nil,
        includeFees: Bool? = nil,
        collection: String? = nil,
        updatedMinTimestamp: String? = nil,
        updatedMaxTimestamp: String? = nil,
        auxiliaryFeePercentages: String? = nil,
        auxiliaryFeeRecipients: String? = nil
    ) async throws -> ListAssetsResponse {
        let companion = listAssetsCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
