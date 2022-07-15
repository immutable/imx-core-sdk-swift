import Foundation
@testable import ImmutableXCore

final class SignerMock: Signer {
    // MARK: - getAddress

    var getAddressThrowableError: Error?
    var getAddressCallsCount = 0
    var getAddressCalled: Bool {
        getAddressCallsCount > 0
    }

    var getAddressReturnValue: String = "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f"
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
    var signMessageReturnValue: String! = "0x5a263fad6f17f23e7c7ea833d058f3656d3fe464baf13f6f5ccba9a2466ba2ce4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20cdcf1a"
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
