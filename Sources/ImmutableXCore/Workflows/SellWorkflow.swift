import Foundation

class SellWorkflow {
    /// This is a utility function that will chain the necessary calls to sell an asset.
    ///
    /// - Parameters:
    ///     - asset: the asset to sell
    ///     - sellToken: the type of token and how much of it to sell the asset for
    ///     - fees: maker fees information to be used in the sell order.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CreateOrderResponse`` that will provide the Order id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    class func sell(asset: AssetModel, sellToken: AssetModel, fees: [FeeEntry], signer: Signer, starkSigner: StarkSigner, ordersAPI: OrdersAPI.Type = OrdersAPI.self) async throws -> CreateOrderResponse {
        let address = try await signer.getAddress()
        let orderResponse = try await getSignableOrder(asset: asset, sellToken: sellToken, address: address, fees: fees, api: ordersAPI)
        let starkSignature = try await starkSigner.signMessage(orderResponse.payloadHash)
        let ethSignature = try await signer.signMessage(orderResponse.signableMessage)
        let signatures = WorkflowSignatures(ethAddress: address, ethSignature: ethSignature, starkSignature: starkSignature)
        return try await createOrder(response: orderResponse, signatures: signatures, fees: fees, api: ordersAPI)
    }

    private static func getSignableOrder(asset: AssetModel, sellToken: AssetModel, address: String, fees: [FeeEntry], api: OrdersAPI.Type) async throws -> GetSignableOrderResponse {
        try await Workflow.mapAPIErrors(caller: "Signable order") {
            try await api.getSignableOrder(
                getSignableOrderRequestV3: GetSignableOrderRequest(
                    amountBuy: sellToken.formatQuantity(),
                    amountSell: asset.quantity,
                    fees: fees,
                    tokenBuy: sellToken.asSignableToken(),
                    tokenSell: asset.asSignableToken(),
                    user: address
                )
            )
        }
    }

    private static func createOrder(response: GetSignableOrderResponse, signatures: WorkflowSignatures, fees: [FeeEntry], api: OrdersAPI.Type) async throws -> CreateOrderResponse {
        try await Workflow.mapAPIErrors(caller: "Create order") {
            try await api.createOrder(
                xImxEthAddress: signatures.ethAddress,
                xImxEthSignature: signatures.serializedEthSignature,
                createOrderRequest: CreateOrderRequest(
                    amountBuy: response.amountBuy,
                    amountSell: response.amountSell,
                    assetIdBuy: response.assetIdBuy,
                    assetIdSell: response.assetIdSell,
                    expirationTimestamp: response.expirationTimestamp,
                    fees: fees,
                    includeFees: true,
                    nonce: response.nonce,
                    starkKey: response.starkKey,
                    starkSignature: signatures.starkSignature,
                    vaultIdBuy: response.vaultIdBuy,
                    vaultIdSell: response.vaultIdSell
                )
            )
        }
    }
}
