import Foundation
@testable import ImmutableXCore

final class SignerMock: Signer {
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

    // MARK: - getAddress

    var getAddressOnCompletionCallsCount = 0
    var getAddressOnCompletionCalled: Bool {
        getAddressOnCompletionCallsCount > 0
    }

    var getAddressOnCompletionReceivedOnCompletion: ((Result<String, Error>) -> Void)?
    var getAddressOnCompletionReceivedInvocations: [(Result<String, Error>) -> Void] = []
    var getAddressOnCompletionClosure: ((@escaping (Result<String, Error>) -> Void) -> Void)?

    func getAddress(onCompletion: @escaping (Result<String, Error>) -> Void) {
        getAddressOnCompletionCallsCount += 1
        getAddressOnCompletionReceivedOnCompletion = onCompletion
        getAddressOnCompletionReceivedInvocations.append(onCompletion)
        getAddressOnCompletionClosure?(onCompletion)
    }

    // MARK: - signMessage

    var signMessageThrowableError: Error?
    var signMessageCallsCount = 0
    var signMessageCalled: Bool {
        signMessageCallsCount > 0
    }

    var signMessageReceivedMessage: String?
    var signMessageReceivedInvocations: [String] = []
    var signMessageReturnValue: String!
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

    // MARK: - signMessage

    var signMessageOnCompletionCallsCount = 0
    var signMessageOnCompletionCalled: Bool {
        signMessageOnCompletionCallsCount > 0
    }

    var signMessageOnCompletionReceivedArguments: (message: String, onCompletion: (Result<String, Error>) -> Void)?
    var signMessageOnCompletionReceivedInvocations: [(message: String, onCompletion: (Result<String, Error>) -> Void)] = []
    var signMessageOnCompletionClosure: ((String, @escaping (Result<String, Error>) -> Void) -> Void)?

    func signMessage(_ message: String, onCompletion: @escaping (Result<String, Error>) -> Void) {
        signMessageOnCompletionCallsCount += 1
        signMessageOnCompletionReceivedArguments = (message: message, onCompletion: onCompletion)
        signMessageOnCompletionReceivedInvocations.append((message: message, onCompletion: onCompletion))
        signMessageOnCompletionClosure?(message, onCompletion)
    }
}
