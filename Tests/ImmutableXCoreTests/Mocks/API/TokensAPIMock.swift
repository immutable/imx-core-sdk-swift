import Foundation
@testable import ImmutableXCore

final class TokensAPIMock: TokensAPI {
    class GetTokenCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: TokenDetails!
    }

    class ListTokensCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: ListTokensResponse!
    }

    static var getTokenCompanion: GetTokenCompanion?
    static var listTokensCompanion: ListTokensCompanion?

    static func mock(_ companion: GetTokenCompanion) {
        getTokenCompanion = companion
    }

    static func mock(_ companion: ListTokensCompanion) {
        listTokensCompanion = companion
    }

    static func resetMock() {
        getTokenCompanion = nil
        listTokensCompanion = nil
    }

    override class func getToken(address: String) async throws -> TokenDetails {
        let companion = getTokenCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func listTokens(
        address: String? = nil,
        symbols: String? = nil
    ) async throws -> ListTokensResponse {
        let companion = listTokensCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
