import Foundation

public enum KeyError: Error {
    case invalidData
}

public enum SignatureError: Error {
    case invalidArguments
    case invalidMessageLength
}
