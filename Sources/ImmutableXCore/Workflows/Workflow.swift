import Foundation

/// Struct for workflows to hold the ethAddress and signatures for transactions
struct WorkflowSignatures {
    let ethAddress: String
    let ethSignature: String?
    let starkSignatures: [String]
    let jwt: String?

    init(
        ethAddress: String,
        ethSignature: String?,
        starkSignatures: [String],
        jwt: String? = nil
    ) {
        precondition(!starkSignatures.isEmpty, "List cannot be empty")
        self.ethAddress = ethAddress
        self.ethSignature = ethSignature
        self.starkSignatures = starkSignatures
        self.jwt = jwt
    }

    init(
        ethAddress: String,
        ethSignature: String?,
        starkSignature: String,
        jwt: String? = nil
    ) {
        self.init(
            ethAddress: ethAddress,
            ethSignature: ethSignature,
            starkSignatures: [starkSignature],
            jwt: jwt
        )
    }

    /// Construct Signatures with the given parameters.
    /// Will inject an eth signature if eth signer has been provided 
    static func with(
        connection: WalletConnection,
        ethSignableMessage: String,
        starkSignableMessages: [String]
    ) async throws -> WorkflowSignatures {
        var ethSignature: String? = nil

        if let ethSigner = connection.signers.ethSigner {
            ethSignature = try await ethSigner.signMessage(ethSignableMessage)
        }

        let starkSignatures = try await getStarkSignatures(
            starkSignableMessages,
            connection: connection
        )

        let jwt = try await connection.signers.jwt()?.token

        return WorkflowSignatures(
            ethAddress: try await connection.getEthAddress(),
            ethSignature: ethSignature,
            starkSignatures: starkSignatures,
            jwt: jwt
        )
    }

    private static func getStarkSignatures(
        _ starkSignableMessages: [String],
        connection: WalletConnection
    ) async throws -> [String] {
        var signatures = [String]()

        for response in starkSignableMessages {
            let signature = try await connection.signers.starkSigner.signMessage(response)
            signatures.append(signature)
        }

        return signatures
    }

    var starkSignature: String {
        starkSignatures.first!
    }

    /// Serialized signature to be supplied to the API
    var serializedEthSignature: String {
        if let signature = ethSignature {
            return CryptoUtil.serializeEthSignature(signature)
        }

        // TODO: probably return nil instead
        return ""
    }
}
