import Foundation

public struct TransferData {
    public let token: AssetModel
    public let recipientAddress: String

    public init(token: AssetModel, recipientAddress: String) {
        self.token = token
        self.recipientAddress = recipientAddress
    }
}

// Internal extension, not public facing
extension WalletConnection {
    func getEthAddress() async throws -> String {
        if let signer = signers.ethSigner {
            return try await signer.getAddress()
        }

        //  get the address somehow
        let jwt = try await signers.jwt()

        if let address = try jwt?.getAddress() {
            return address
        }

        // throw specific error if no eth signer nor jwt is set
        throw ImmutableXError.invalidKeyData
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
        connection: WalletConnection,
        otpHandler: OTPHandler?,
        otp: String?,
        transfersAPI: TransfersAPI.Type = TransfersAPI.self
    ) async throws -> CreateTransferResponse {
        let address = try await connection.getEthAddress()

        let response = try await getSignableTransfer(
            address: address,
            transfers: transfers,
            otpHandler: otpHandler,
            otp: otp,
            api: transfersAPI
        )

        guard !response.signableResponses.isEmpty else {
            throw ImmutableXError.invalidRequest(reason: "Invalid signable response")
        }

        let signatures = try await WorkflowSignatures.with(
            connection: connection,
            ethSignableMessage: response.signableMessage,
            starkSignableMessages: response.signableResponses.map(\.payloadHash)
        )

        return try await createTransfer(
            response: response,
            signatures: signatures,
            otpHandler: otpHandler,
            otp: otp,
            api: transfersAPI
        )
    }

    private static func getSignableTransfer(
        address: String,
        transfers: [TransferData],
        otpHandler: OTPHandler?,
        otp: String?,
        api: TransfersAPI.Type
    ) async throws -> GetSignableTransferResponse {
        try await APIErrorMapper.mapOTP(
            caller: "Signable transfer",
            otpHandler: otpHandler
        ) { otp in
            try await api.getSignableTransfer(
                getSignableTransferRequestV2: GetSignableTransferRequest(
                    senderEtherKey: address,
                    // xImxOTP: otp,
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
        otpHandler: OTPHandler?,
        otp: String?,
        api: TransfersAPI.Type
    ) async throws -> CreateTransferResponse {
        try await APIErrorMapper.mapOTP(
            caller: "Signable transfer",
            otpHandler: otpHandler
        ) { otp in
            try await APIErrorMapper.map(caller: "Create transfer") {
                try await api.createTransfer(
                    xImxEthAddress: signatures.ethAddress,
                    xImxEthSignature: signatures.serializedEthSignature,
                    // xImxJwt: signatures.jwt,
                    // xImxOTP: otp,
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
}
