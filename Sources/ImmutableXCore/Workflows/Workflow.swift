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
