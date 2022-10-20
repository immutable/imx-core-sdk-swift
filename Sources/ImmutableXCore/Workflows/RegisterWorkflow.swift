import Foundation

class RegisterWorkflow {
    /// This is a utility function that will register a user to Immutable X if they aren't already
    ///
    /// - Parameters:
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: true if user has been registered or false if user had already been registered
    /// - Throws: A variation of ``ImmutableXError``
    class func registerOffchain(signer: Signer, starkSigner: StarkSigner, usersAPI: UsersAPI.Type = UsersAPI.self) async throws -> Bool {
        let address = try await signer.getAddress()
        let starkAddress = try await starkSigner.getAddress()
        let isRegistered = try await isUserRegistered(address: address, api: usersAPI)

        guard !isRegistered else { return false }

        let signableResponse = try await getSignableResponse(address: address, starkAddress: starkAddress, api: usersAPI)
        let starkSignature = try await starkSigner.signMessage(signableResponse.payloadHash)
        let ethSignature = try await signer.signMessage(signableResponse.signableMessage)
        let signatures = WorkflowSignatures(ethAddress: address, ethSignature: ethSignature, starkSignature: starkSignature)
        return try await registerUser(address: address, starkAddress: starkAddress, signatures: signatures, api: usersAPI)
    }

    internal static func isUserRegistered(address: String, api: UsersAPI.Type) async throws -> Bool {
        try await Workflow.mapAPIErrors(caller: "Get user") {
            do {
                let response = try await api.getUsers(user: address)
                return !response.accounts.isEmpty
            } catch {
                // Endpoint returns 404 when the user isn't registered
                if case let ErrorResponse.error(statusCode, _, _, _) = error, statusCode == 404 {
                    return false
                }

                throw error
            }
        }
    }

    private static func getSignableResponse(address: String, starkAddress: String, api: UsersAPI.Type) async throws -> GetSignableRegistrationOffchainResponse {
        try await Workflow.mapAPIErrors(caller: "Signable registration") {
            try await api.getSignableRegistrationOffchain(
                getSignableRegistrationRequest: GetSignableRegistrationRequest(
                    etherKey: address,
                    starkKey: starkAddress
                )
            )
        }
    }

    private static func registerUser(address: String, starkAddress: String, signatures: WorkflowSignatures, api: UsersAPI.Type) async throws -> Bool {
        try await Workflow.mapAPIErrors(caller: "Register user") {
            let response = try await api.registerUser(
                registerUserRequest: RegisterUserRequest(
                    ethSignature: signatures.serializedEthSignature,
                    etherKey: address,
                    starkKey: starkAddress,
                    starkSignature: signatures.starkSignature
                )
            )
            return !response.txHash.isEmpty
        }
    }
}
