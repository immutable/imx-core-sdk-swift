import Foundation
@testable import ImmutableXCore

class BuyCryptoWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: String!
}

class BuyCryptoWorkflowMock: BuyCryptoWorkflow {
    static var companion: BuyCryptoWorkflowCompanion!

    static func mock(_ companion: BuyCryptoWorkflowCompanion) {
        self.companion = companion
    }

    static func resetMock() {
        companion = nil
    }

    override class func buyCryptoURL(
        colorCodeHex: String = "#00818e",
        signer: Signer,
        base: ImmutableXBase = ImmutableX.shared.base,
        moonpayAPI: MoonpayAPI = MoonpayAPI(),
        exchangesAPI: ExchangesAPI = ExchangesAPI(),
        usersAPI: UsersAPI.Type = UsersAPI.self
    ) async throws -> String {
        let companion = companion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
