import Foundation

class BuyWorkflow {
    /// This is a utility function that will chain the necessary calls to buy an existing order.
    ///
    /// - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - fees: taker fees information to be used in the buy order.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CreateTradeResponse`` that will provide the Trade id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    class func buy(orderId: String, fees: [FeeEntry], signer: Signer, starkSigner: StarkSigner, ordersAPI: OrdersAPI.Type = OrdersAPI.self, tradesAPI: TradesAPI.Type = TradesAPI.self) async throws -> CreateTradeResponse {
        let address = try await signer.getAddress()
        let order = try await getOrderDetails(orderId: orderId, fees: fees, api: ordersAPI)
        let signableTrade = try await getSignableTrade(order: order, address: address, fees: fees, api: tradesAPI)
        let starkSignature = try await starkSigner.signMessage(signableTrade.payloadHash)
        let ethSignature = try await signer.signMessage(signableTrade.signableMessage)
        let signatures = WorkflowSignatures(ethAddress: address, ethSignature: ethSignature, starkSignature: starkSignature)
        return try await createTrade(orderId: Int(orderId)!, response: signableTrade, fees: fees, signatures: signatures, api: tradesAPI)
    }

    private static func getOrderDetails(orderId: String, fees: [FeeEntry], api: OrdersAPI.Type) async throws -> Order {
        let feePercentages = try fees.map { try $0.feePercentage.orThrow(.invalidRequest(reason: "Invalid fee percentage")) }
            .map(\.asString)
            .joined(separator: ",")

        let feeRecipients = try fees.map { try $0.address.orThrow(.invalidRequest(reason: "Invalid fee address")) }
            .joined(separator: ",")

        return try await Workflow.mapAPIErrors(caller: "Order details") {
            try await api.getOrder(
                id: orderId,
                includeFees: true,
                auxiliaryFeePercentages: feePercentages,
                auxiliaryFeeRecipients: feeRecipients
            )
        }
    }

    private static func getSignableTrade(order: Order, address: String, fees: [FeeEntry], api: TradesAPI.Type) async throws -> GetSignableTradeResponse {
        guard order.user != address else { throw ImmutableXError.invalidRequest(reason: "Cannot purchase own order") }
        guard order.status == OrderStatus.active.rawValue else { throw ImmutableXError.invalidRequest(reason: "Order not available for purchase") }
        return try await Workflow.mapAPIErrors(caller: "Signable trade") {
            try await api.getSignableTrade(
                getSignableTradeRequest: GetSignableTradeRequest(
                    fees: fees,
                    orderId: order.orderId,
                    user: address
                )
            )
        }
    }

    private static func createTrade(orderId: Int, response: GetSignableTradeResponse, fees: [FeeEntry], signatures: WorkflowSignatures, api: TradesAPI.Type) async throws -> CreateTradeResponse {
        try await Workflow.mapAPIErrors(caller: "Create trade") {
            try await api.createTrade(
                xImxEthAddress: signatures.ethAddress,
                xImxEthSignature: signatures.serializedEthSignature,
                createTradeRequest: CreateTradeRequestV1(
                    amountBuy: response.amountBuy,
                    amountSell: response.amountSell,
                    assetIdBuy: response.assetIdBuy,
                    assetIdSell: response.assetIdSell,
                    expirationTimestamp: response.expirationTimestamp,
                    feeInfo: response.feeInfo,
                    fees: fees,
                    includeFees: true,
                    nonce: response.nonce,
                    orderId: orderId,
                    starkKey: response.starkKey,
                    starkSignature: signatures.starkSignature,
                    vaultIdBuy: response.vaultIdBuy,
                    vaultIdSell: response.vaultIdSell
                )
            )
        }
    }
}
