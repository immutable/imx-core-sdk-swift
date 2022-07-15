import Foundation

public protocol ImmutableXError: Error {}

public enum KeyError: ImmutableXError {
    case invalidData
}

public enum SignatureError: ImmutableXError {
    case invalidArguments
    case invalidMessageLength
}

public enum WorkflowError: ImmutableXError {
    case invalidRequest(reason: String)
    case apiFailure(caller: String, error: Error)
}
