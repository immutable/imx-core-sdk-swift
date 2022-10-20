import Foundation

class TransferWorkflow {
    /// This is a utility function that will chain the necessary calls to transfer a token.
    ///
    /// - Parameters:
    ///     - token: to be transferred (ETH, ERC20, or ERC721)
    ///     - recipientAddress: of the wallet that will receive the token
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CreateTransferResponse`` that will provide the transfer id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    class func transfer(token: AssetModel, recipientAddress: String, signer: Signer, starkSigner: StarkSigner, transfersAPI: TransfersAPI.Type = TransfersAPI.self) async throws -> CreateTransferResponse {
        let address = try await signer.getAddress()
        let response = try await getSignableTransfer(address: address, token: token, recipientAddress: recipientAddress, api: transfersAPI)
        let signableResponse = try response.signableResponses.first.orThrow(.invalidRequest(reason: "Invalid signable response"))
        let starkSignature = try await starkSigner.signMessage(signableResponse.payloadHash)
        let ethSignature = try await signer.signMessage(response.signableMessage)
        let signatures = WorkflowSignatures(ethAddress: address, ethSignature: ethSignature, starkSignature: starkSignature)
        return try await createTransfer(response: response, signableResponse: signableResponse, signatures: signatures, api: transfersAPI)
    }

    private static func getSignableTransfer(address: String, token: AssetModel, recipientAddress: String, api: TransfersAPI.Type) async throws -> GetSignableTransferResponse {
        try await Workflow.mapAPIErrors(caller: "Signable transfer") {
            try await api.getSignableTransfer(
                getSignableTransferRequestV2: GetSignableTransferRequest(
                    senderEtherKey: address,
                    signableRequests: [
                        SignableTransferDetails(
                            amount: token.quantity,
                            receiver: recipientAddress,
                            token: token.asSignableToken()
                        ),
                    ]
                )
            )
        }
    }

    private static func createTransfer(response: GetSignableTransferResponse, signableResponse: SignableTransferResponseDetails, signatures: WorkflowSignatures, api: TransfersAPI.Type) async throws -> CreateTransferResponse {
        try await Workflow.mapAPIErrors(caller: "Create transfer") {
            try await api.createTransfer(
                xImxEthAddress: signatures.ethAddress,
                xImxEthSignature: signatures.serializedEthSignature,
                createTransferRequestV2: CreateTransferRequest(
                    requests: [
                        TransferRequest(
                            amount: signableResponse.amount,
                            assetId: signableResponse.assetId,
                            expirationTimestamp: signableResponse.expirationTimestamp,
                            nonce: signableResponse.nonce,
                            receiverStarkKey: signableResponse.receiverStarkKey,
                            receiverVaultId: signableResponse.receiverVaultId,
                            senderVaultId: signableResponse.senderVaultId,
                            starkSignature: signatures.starkSignature
                        ),
                    ],
                    senderStarkKey: response.senderStarkKey
                )
            )
        }
    }
}
