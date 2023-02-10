import Foundation

public enum ImmutableXError: Error {
    /// Error related to generating an ``ECPrivateKey``
    case invalidPrivateKey

    /// Error related to deriving or parsing ``ECPrivateKey`` and ``ECPublicKey``
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

internal enum APIErrorMapper {
    /// A helper that parses any non-``ImmutableXError`` into ``ImmutableXError.apiFailure(caller:error:)``
    static func map<T>(caller: String, apiCall: () async throws -> T) async throws -> T {
        do {
            return try await apiCall()
        } catch {
            if error is ImmutableXError {
                throw error
            }

            throw ImmutableXError.apiFailure(caller: caller, error: error)
        }
    }

    /// A helper that parses any non-``ImmutableXError`` into ``ImmutableXError.apiFailure(caller:error:)``
    /// This handles OTP requests as well as jwt refreshes as needed
    static func mapOTP<T>(caller: String, otpHandler: OTPHandler?, apiCall: (_ otp: String?) async throws -> T) async throws -> T {
        do {
            return try await apiCall(nil)
        } catch {
            // pretend this is an error requiring OTP
            if error is ImmutableXError {
                return try await APIErrorMapper.map(caller: caller) {
                    let otp = try await otpHandler?.getOTP()
                    return try await apiCall(otp)
                }
            }

            // pretend this is an error requiring refreshed token
            if error is ImmutableXError {
                return try await APIErrorMapper.map(caller: caller) {
                    try await otpHandler?.refreshJwt()
                    return try await apiCall(nil)
                }
            }

            // Any other errors
            if error is ImmutableXError {
                throw error
            }

            throw ImmutableXError.apiFailure(caller: caller, error: error)
        }
    }
}
