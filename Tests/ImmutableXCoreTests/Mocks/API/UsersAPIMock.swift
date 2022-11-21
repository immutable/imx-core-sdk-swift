import Foundation
@testable import ImmutableXCore

class UsersAPIMockGetUsersCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetUsersApiResponse!
}

class UsersAPIMockGetSignableCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetSignableRegistrationOffchainResponse!
}

class UsersAPIMockRegisterCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: RegisterUserResponse!
}

final class UsersAPIMock: UsersAPI {
    static var getUsersCompanion: UsersAPIMockGetUsersCompanion?
    static var getSignableCompanion: UsersAPIMockGetSignableCompanion?
    static var registerCompanion: UsersAPIMockRegisterCompanion?

    static func mock(_ companion: UsersAPIMockGetUsersCompanion) {
        getUsersCompanion = companion
    }

    static func mock(_ companion: UsersAPIMockGetSignableCompanion) {
        getSignableCompanion = companion
    }

    static func mock(_ companion: UsersAPIMockRegisterCompanion) {
        registerCompanion = companion
    }

    static func resetMock() {
        getUsersCompanion = nil
        getSignableCompanion = nil
        registerCompanion = nil
    }

    // MARK: - getUsers

    override class func getUsers(user: String) async throws -> GetUsersApiResponse {
        let companion = getUsersCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    // MARK: - getSignableRegistrationOffchain

    override class func getSignableRegistrationOffchain(
        getSignableRegistrationRequest: GetSignableRegistrationRequest
    ) async throws -> GetSignableRegistrationOffchainResponse {
        let companion = getSignableCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    // MARK: - registerUser

    override class func registerUser(
        registerUserRequest: RegisterUserRequest
    ) async throws -> RegisterUserResponse {
        let companion = registerCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
