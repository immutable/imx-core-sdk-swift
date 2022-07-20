import Foundation
@testable import ImmutableXCore

final class StarkSignerMock: StarkSigner {
    // MARK: - getAddress

    var getAddressThrowableError: Error?
    var getAddressCallsCount = 0
    var getAddressCalled: Bool {
        getAddressCallsCount > 0
    }

    var getAddressReturnValue: String!
    var getAddressClosure: (() throws -> String)?

    func getAddress() throws -> String {
        if let error = getAddressThrowableError {
            throw error
        }
        getAddressCallsCount += 1
        return try getAddressClosure.map { try $0() } ?? getAddressReturnValue
    }

    // MARK: - signMessage

    var signMessageThrowableError: Error?
    var signMessageCallsCount = 0
    var signMessageCalled: Bool {
        signMessageCallsCount > 0
    }

    var signMessageReceivedMessage: String?
    var signMessageReceivedInvocations: [String] = []
    var signMessageReturnValue: String! = "signature"
    var signMessageClosure: ((String) throws -> String)?

    func signMessage(_ message: String) throws -> String {
        if let error = signMessageThrowableError {
            throw error
        }
        signMessageCallsCount += 1
        signMessageReceivedMessage = message
        signMessageReceivedInvocations.append(message)
        return try signMessageClosure.map { try $0(message) } ?? signMessageReturnValue
    }
}
