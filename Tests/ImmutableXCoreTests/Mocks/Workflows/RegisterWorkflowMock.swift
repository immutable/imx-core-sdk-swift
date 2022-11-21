import Foundation
@testable import ImmutableXCore

class RegisterWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: Bool = true
}

class RegisterWorkflowMock: RegisterWorkflow {
    static var companion: RegisterWorkflowCompanion!

    static func mock(_ companion: RegisterWorkflowCompanion) {
        self.companion = companion
    }

    static func resetMock() {
        companion = nil
    }

    override class func registerOffchain(
        signer: Signer,
        starkSigner: StarkSigner,
        usersAPI: UsersAPI.Type = UsersAPI.self
    ) async throws -> Bool {
        let companion = companion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
