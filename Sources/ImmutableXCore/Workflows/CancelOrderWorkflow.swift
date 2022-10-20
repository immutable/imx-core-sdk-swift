import Foundation

class CancelOrderWorkflow {
    /// This is a utility function that will chain the necessary calls to cancel an existing order.
    ///
    /// - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CancelOrderResponse`` that will provide the cancelled Order id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    class func cancel(orderId: String, signer: Signer, starkSigner: StarkSigner, ordersAPI: OrdersAPI.Type = OrdersAPI.self) async throws -> CancelOrderResponse {
        let address = try await signer.getAddress()
        let signableOrder = try await getSignableCancelOrder(orderId: orderId, api: ordersAPI)
        let starkSignature = try await starkSigner.signMessage(signableOrder.payloadHash)
        let ethSignature = try await signer.signMessage(signableOrder.signableMessage)
        let signatures = WorkflowSignatures(ethAddress: address, ethSignature: ethSignature, starkSignature: starkSignature)
        return try await cancelOrder(orderId: orderId, signatures: signatures, api: ordersAPI)
    }

    private static func getSignableCancelOrder(orderId: String, api: OrdersAPI.Type) async throws -> GetSignableCancelOrderResponse {
        try await Workflow.mapAPIErrors(caller: "Signable cancel order") {
            try await api.getSignableCancelOrder(
                getSignableCancelOrderRequest: GetSignableCancelOrderRequest(
                    orderId: Int(orderId)!
                )
            )
        }
    }

    private static func cancelOrder(orderId: String, signatures: WorkflowSignatures, api: OrdersAPI.Type) async throws -> CancelOrderResponse {
        try await Workflow.mapAPIErrors(caller: "Cancel order") {
            try await api.cancelOrder(
                xImxEthAddress: signatures.ethAddress,
                xImxEthSignature: signatures.serializedEthSignature,
                id: orderId,
                cancelOrderRequest: CancelOrderRequest(
                    orderId: Int(orderId)!,
                    starkSignature: signatures.starkSignature
                )
            )
        }
    }
}
