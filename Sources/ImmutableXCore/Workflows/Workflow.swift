import Foundation

/// Struct for workflows to hold the ethAddress and signatures for transactions
struct WorkflowSignatures {
    let ethAddress: String
    let ethSignature: String
    let starkSignature: String

    /// Serialized signature to be supplied to the API
    var serializedEthSignature: String {
        CryptoUtil.serializeEthSignature(ethSignature)
    }
}

enum Workflow {
    /// A helper that parses any non-``ImmutableXCoreError`` into ``ImmutableXCoreError.apiFailure(caller:error:)``
    static func mapAPIErrors<T>(caller: String, apiCall: () async throws -> T) async throws -> T {
        do {
            return try await apiCall()
        } catch {
            if error is ImmutableXCoreError {
                throw error
            }

            throw ImmutableXCoreError.apiFailure(caller: caller, error: error)
        }
    }
}
