import Foundation
@testable import ImmutableXCore

final class CollectionsAPIMock: CollectionsAPI {
    class GetCollectionCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Collection!
    }

    class ListCollectionFiltersCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: CollectionFilter!
    }

    class ListCollectionsCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListCollectionsResponse!
    }

    static var getCollectionCompanion: GetCollectionCompanion?
    static var listCollectionFiltersCompanion: ListCollectionFiltersCompanion?
    static var listCollectionsCompanion: ListCollectionsCompanion?

    static func mock(_ companion: GetCollectionCompanion) {
        getCollectionCompanion = companion
    }

    static func mock(_ companion: ListCollectionFiltersCompanion) {
        listCollectionFiltersCompanion = companion
    }

    static func mock(_ companion: ListCollectionsCompanion) {
        listCollectionsCompanion = companion
    }

    static func resetMock() {
        getCollectionCompanion = nil
        listCollectionFiltersCompanion = nil
        listCollectionsCompanion = nil
    }

    override class func getCollection(address: String) async throws -> Collection {
        let companion = getCollectionCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listCollectionFilters(address: String, pageSize: Int? = nil, nextPageToken: String? = nil) async throws -> CollectionFilter {
        let companion = listCollectionFiltersCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listCollections(pageSize: Int? = nil, cursor: String? = nil, orderBy: CollectionsAPI.OrderBy_listCollections? = nil, direction: String? = nil, blacklist: String? = nil, whitelist: String? = nil, keyword: String? = nil) async throws -> ListCollectionsResponse {
        let companion = listCollectionsCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
