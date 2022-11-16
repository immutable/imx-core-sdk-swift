import Foundation

/// Struct for workflows to hold the ethAddress and signatures for transactions
struct WorkflowSignatures {
    let ethAddress: String
    let ethSignature: String
    let starkSignatures: [String]

    init(
        ethAddress: String,
        ethSignature: String,
        starkSignatures: [String]
    ) {
        precondition(!starkSignatures.isEmpty, "List cannot be empty")
        self.ethAddress = ethAddress
        self.ethSignature = ethSignature
        self.starkSignatures = starkSignatures
    }

    init(
        ethAddress: String,
        ethSignature: String,
        starkSignature: String
    ) {
        self.init(
            ethAddress: ethAddress,
            ethSignature: ethSignature,
            starkSignatures: [starkSignature]
        )
    }

    var starkSignature: String {
        starkSignatures.first!
    }

    /// Serialized signature to be supplied to the API
    var serializedEthSignature: String {
        CryptoUtil.serializeEthSignature(ethSignature)
    }
}
