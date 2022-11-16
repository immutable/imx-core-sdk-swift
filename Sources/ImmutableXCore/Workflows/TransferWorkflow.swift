import Foundation

public struct TransferData {
    public let token: AssetModel
    public let recipientAddress: String

    public init(token: AssetModel, recipientAddress: String) {
        self.token = token
        self.recipientAddress = recipientAddress
    }
}

class TransferWorkflow {
    /// This is a utility function that will chain the necessary calls to transfer a token.
    ///
    /// - Parameters:
    ///     - transfers: contains a list of ``TransferData`` with `token` to be transferred (ETH, ERC20, or ERC721)
    ///     and `recipientAddress` of the wallet that will receive the token
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CreateTransferResponse`` that will provide the transfer id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    class func transfer(
        transfers: [TransferData],
        signer: Signer,
        starkSigner: StarkSigner,
        transfersAPI: TransfersAPI.Type = TransfersAPI.self
    ) async throws -> CreateTransferResponse {
        let address = try await signer.getAddress()
        let response = try await getSignableTransfer(
            address: address,
            transfers: transfers,
            api: transfersAPI
        )

        guard !response.signableResponses.isEmpty else {
            throw ImmutableXError.invalidRequest(reason: "Invalid signable response")
        }

        let starkSignatures = try await getStarkSignatures(
            response.signableResponses,
            starkSigner: starkSigner
        )
        let ethSignature = try await signer.signMessage(response.signableMessage)
        let signatures = WorkflowSignatures(
            ethAddress: address,
            ethSignature: ethSignature,
            starkSignatures: starkSignatures
        )
        return try await createTransfer(
            response: response,
            signatures: signatures,
            api: transfersAPI
        )
    }

    private static func getStarkSignatures(
        _ signableResponses: [SignableTransferResponseDetails],
        starkSigner: StarkSigner
    ) async throws -> [String] {
        var signatures = [String]()

        for response in signableResponses {
            let signature = try await starkSigner.signMessage(response.payloadHash)
            signatures.append(signature)
        }

        return signatures
    }

    private static func getSignableTransfer(
        address: String,
        transfers: [TransferData],
        api: TransfersAPI.Type
    ) async throws -> GetSignableTransferResponse {
        try await APIErrorMapper.map(caller: "Signable transfer") {
            try await api.getSignableTransfer(
                getSignableTransferRequestV2: GetSignableTransferRequest(
                    senderEtherKey: address,
                    signableRequests: transfers.map {
                        SignableTransferDetails(
                            amount: $0.token.quantity,
                            receiver: $0.recipientAddress,
                            token: $0.token.asSignableToken()
                        )
                    }
                )
            )
        }
    }

    private static func createTransfer(
        response: GetSignableTransferResponse,
        signatures: WorkflowSignatures,
        api: TransfersAPI.Type
    ) async throws -> CreateTransferResponse {
        try await APIErrorMapper.map(caller: "Create transfer") {
            try await api.createTransfer(
                xImxEthAddress: signatures.ethAddress,
                xImxEthSignature: signatures.serializedEthSignature,
                createTransferRequestV2: CreateTransferRequest(
                    requests: response.signableResponses.enumerated().map { index, signableResponse in
                        TransferRequest(
                            amount: signableResponse.amount,
                            assetId: signableResponse.assetId,
                            expirationTimestamp: signableResponse.expirationTimestamp,
                            nonce: signableResponse.nonce,
                            receiverStarkKey: signableResponse.receiverStarkKey,
                            receiverVaultId: signableResponse.receiverVaultId,
                            senderVaultId: signableResponse.senderVaultId,
                            starkSignature: signatures.starkSignatures[index]
                        )
                    },
                    senderStarkKey: response.senderStarkKey
                )
            )
        }
    }
}
