import Foundation

public enum ImmutableXError: Error {
    /// Error related to deriving or parsing ``PrivateKey`` and ``PublicKey``
    case invalidKeyData

    /// Signature's ``StarkSignature/r`` or ``StarkSignature/s`` are out of the curve's range
    case invalidStarkSignature

    /// Error related to the length of the message to be signed
    case invalidSignatureMessageLength

    /// Error related to an invalid request in one of the utility methods
    case invalidRequest(reason: String)

    /// Error related to an API failure in one of the utility methods
    case apiFailure(caller: String, error: Error)
}

internal extension Error {
    /// Returns error as ``ImmutableXError/invalidRequest(reason:)`` with `localizedDescription`
    /// if it's not an ``ImmutableXError``
    var asImmutableXError: ImmutableXError {
        self as? ImmutableXError ?? ImmutableXError.invalidRequest(reason: localizedDescription)
    }
}
