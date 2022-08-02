import Foundation
@testable import ImmutableXCore

class MoonpayAPIMockBuyCryptoURLCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: String!
}

class MoonpayAPIMock: MoonpayAPI {
    var buyCryptoCompanion: MoonpayAPIMockBuyCryptoURLCompanion?

    func mock(_ companion: MoonpayAPIMockBuyCryptoURLCompanion) {
        buyCryptoCompanion = companion
    }

    func resetMock() {
        buyCryptoCompanion = nil
    }

    // MARK: - getBuyCryptoURL

    override func getBuyCryptoURL(_ request: GetBuyCryptoURLRequest) async throws -> String {
        let companion = buyCryptoCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
