//
// OrdersAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class OrdersAPI {

    /**
     cancel an order
     
     - parameter id: (path) Order ID to cancel 
     - parameter cancelOrderRequest: (body) cancel an order 
     - parameter xImxEthAddress: (header) eth address (optional)
     - parameter xImxEthSignature: (header) eth signature (optional)
     - returns: CancelOrderResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func cancelOrder(id: String, cancelOrderRequest: CancelOrderRequest, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) async throws -> CancelOrderResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = cancelOrderWithRequestBuilder(id: id, cancelOrderRequest: cancelOrderRequest, xImxEthAddress: xImxEthAddress, xImxEthSignature: xImxEthSignature).execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
        }
    }

    /**
     cancel an order
     - DELETE /v1/orders/{id}
     - Cancel an order
     - parameter id: (path) Order ID to cancel 
     - parameter cancelOrderRequest: (body) cancel an order 
     - parameter xImxEthAddress: (header) eth address (optional)
     - parameter xImxEthSignature: (header) eth signature (optional)
     - returns: RequestBuilder<CancelOrderResponse> 
     */
    open class func cancelOrderWithRequestBuilder(id: String, cancelOrderRequest: CancelOrderRequest, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) -> RequestBuilder<CancelOrderResponse> {
        var localVariablePath = "/v1/orders/{id}"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: cancelOrderRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "x-imx-eth-address": xImxEthAddress?.encodeToJSON(),
            "x-imx-eth-signature": xImxEthSignature?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<CancelOrderResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Create an order
     
     - parameter createOrderRequest: (body) create an order 
     - parameter xImxEthAddress: (header) eth address (optional)
     - parameter xImxEthSignature: (header) eth signature (optional)
     - returns: CreateOrderResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func createOrder(createOrderRequest: CreateOrderRequest, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) async throws -> CreateOrderResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = createOrderWithRequestBuilder(createOrderRequest: createOrderRequest, xImxEthAddress: xImxEthAddress, xImxEthSignature: xImxEthSignature).execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
        }
    }

    /**
     Create an order
     - POST /v1/orders
     - Create an order
     - parameter createOrderRequest: (body) create an order 
     - parameter xImxEthAddress: (header) eth address (optional)
     - parameter xImxEthSignature: (header) eth signature (optional)
     - returns: RequestBuilder<CreateOrderResponse> 
     */
    open class func createOrderWithRequestBuilder(createOrderRequest: CreateOrderRequest, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) -> RequestBuilder<CreateOrderResponse> {
        let localVariablePath = "/v1/orders"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: createOrderRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "x-imx-eth-address": xImxEthAddress?.encodeToJSON(),
            "x-imx-eth-signature": xImxEthSignature?.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<CreateOrderResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get details of an order with the given ID
     
     - parameter id: (path) Order ID 
     - parameter includeFees: (query) Set flag to true to include fee body for the order (optional)
     - parameter auxiliaryFeePercentages: (query) Comma separated string of fee percentages that are to be paired with auxiliary_fee_recipients (optional)
     - parameter auxiliaryFeeRecipients: (query) Comma separated string of fee recipients that are to be paired with auxiliary_fee_percentages (optional)
     - returns: Order
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getOrder(id: String, includeFees: Bool? = nil, auxiliaryFeePercentages: String? = nil, auxiliaryFeeRecipients: String? = nil) async throws -> Order {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = getOrderWithRequestBuilder(id: id, includeFees: includeFees, auxiliaryFeePercentages: auxiliaryFeePercentages, auxiliaryFeeRecipients: auxiliaryFeeRecipients).execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
        }
    }

    /**
     Get details of an order with the given ID
     - GET /v1/orders/{id}
     - Get details of an order with the given ID
     - parameter id: (path) Order ID 
     - parameter includeFees: (query) Set flag to true to include fee body for the order (optional)
     - parameter auxiliaryFeePercentages: (query) Comma separated string of fee percentages that are to be paired with auxiliary_fee_recipients (optional)
     - parameter auxiliaryFeeRecipients: (query) Comma separated string of fee recipients that are to be paired with auxiliary_fee_percentages (optional)
     - returns: RequestBuilder<Order> 
     */
    open class func getOrderWithRequestBuilder(id: String, includeFees: Bool? = nil, auxiliaryFeePercentages: String? = nil, auxiliaryFeeRecipients: String? = nil) -> RequestBuilder<Order> {
        var localVariablePath = "/v1/orders/{id}"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "include_fees": includeFees?.encodeToJSON(),
            "auxiliary_fee_percentages": auxiliaryFeePercentages?.encodeToJSON(),
            "auxiliary_fee_recipients": auxiliaryFeeRecipients?.encodeToJSON(),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Order>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get details a signable cancel order
     
     - parameter getSignableCancelOrderRequest: (body) get a signable cancel order 
     - returns: GetSignableCancelOrderResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getSignableCancelOrder(getSignableCancelOrderRequest: GetSignableCancelOrderRequest) async throws -> GetSignableCancelOrderResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = getSignableCancelOrderWithRequestBuilder(getSignableCancelOrderRequest: getSignableCancelOrderRequest).execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
        }
    }

    /**
     Get details a signable cancel order
     - POST /v1/signable-cancel-order-details
     - Get details a signable cancel order
     - parameter getSignableCancelOrderRequest: (body) get a signable cancel order 
     - returns: RequestBuilder<GetSignableCancelOrderResponse> 
     */
    open class func getSignableCancelOrderWithRequestBuilder(getSignableCancelOrderRequest: GetSignableCancelOrderRequest) -> RequestBuilder<GetSignableCancelOrderResponse> {
        let localVariablePath = "/v1/signable-cancel-order-details"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: getSignableCancelOrderRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<GetSignableCancelOrderResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get a signable order request (V3)
     
     - parameter getSignableOrderRequestV3: (body) get a signable order 
     - returns: GetSignableOrderResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getSignableOrder(getSignableOrderRequestV3: GetSignableOrderRequest) async throws -> GetSignableOrderResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = getSignableOrderWithRequestBuilder(getSignableOrderRequestV3: getSignableOrderRequestV3).execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
        }
    }

    /**
     Get a signable order request (V3)
     - POST /v3/signable-order-details
     - Get a signable order request (V3)
     - parameter getSignableOrderRequestV3: (body) get a signable order 
     - returns: RequestBuilder<GetSignableOrderResponse> 
     */
    open class func getSignableOrderWithRequestBuilder(getSignableOrderRequestV3: GetSignableOrderRequest) -> RequestBuilder<GetSignableOrderResponse> {
        let localVariablePath = "/v3/signable-order-details"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: getSignableOrderRequestV3)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<GetSignableOrderResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     * enum for parameter orderBy
     */
    public enum OrderBy_listOrders: String, CaseIterable {
        case createdAt = "created_at"
        case expiredAt = "expired_at"
        case sellQuantity = "sell_quantity"
        case buyQuantity = "buy_quantity"
        case buyQuantityWithFees = "buy_quantity_with_fees"
        case updatedAt = "updated_at"
    }

    /**
     * enum for parameter status
     */
    public enum Status_listOrders: String, CaseIterable {
        case active = "active"
        case filled = "filled"
        case cancelled = "cancelled"
        case expired = "expired"
        case inactive = "inactive"
    }

    /**
     Get a list of orders
     
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter cursor: (query) Cursor (optional)
     - parameter orderBy: (query) Property to sort by (optional)
     - parameter direction: (query) Direction to sort (asc/desc) (optional)
     - parameter user: (query) Ethereum address of the user who submitted this order (optional)
     - parameter status: (query) Status of this order (optional)
     - parameter minTimestamp: (query) Minimum created at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter maxTimestamp: (query) Maximum created at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter updatedMinTimestamp: (query) Minimum updated at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter updatedMaxTimestamp: (query) Maximum updated at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter buyTokenType: (query) Token type of the asset this order buys (optional)
     - parameter buyTokenId: (query) ERC721 Token ID of the asset this order buys (optional)
     - parameter buyAssetId: (query) Internal IMX ID of the asset this order buys (optional)
     - parameter buyTokenAddress: (query) Comma separated string of token addresses of the asset this order buys (optional)
     - parameter buyTokenName: (query) Token name of the asset this order buys (optional)
     - parameter buyMinQuantity: (query) Min quantity for the asset this order buys (optional)
     - parameter buyMaxQuantity: (query) Max quantity for the asset this order buys (optional)
     - parameter buyMetadata: (query) JSON-encoded metadata filters for the asset this order buys (optional)
     - parameter sellTokenType: (query) Token type of the asset this order sells (optional)
     - parameter sellTokenId: (query) ERC721 Token ID of the asset this order sells (optional)
     - parameter sellAssetId: (query) Internal IMX ID of the asset this order sells (optional)
     - parameter sellTokenAddress: (query) Comma separated string of token addresses of the asset this order sells (optional)
     - parameter sellTokenName: (query) Token name of the asset this order sells (optional)
     - parameter sellMinQuantity: (query) Min quantity for the asset this order sells (optional)
     - parameter sellMaxQuantity: (query) Max quantity for the asset this order sells (optional)
     - parameter sellMetadata: (query) JSON-encoded metadata filters for the asset this order sells (optional)
     - parameter auxiliaryFeePercentages: (query) Comma separated string of fee percentages that are to be paired with auxiliary_fee_recipients (optional)
     - parameter auxiliaryFeeRecipients: (query) Comma separated string of fee recipients that are to be paired with auxiliary_fee_percentages (optional)
     - parameter includeFees: (query) Set flag to true to include fee object for orders (optional)
     - returns: ListOrdersResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func listOrders(pageSize: Int? = nil, cursor: String? = nil, orderBy: OrderBy_listOrders? = nil, direction: String? = nil, user: String? = nil, status: Status_listOrders? = nil, minTimestamp: String? = nil, maxTimestamp: String? = nil, updatedMinTimestamp: String? = nil, updatedMaxTimestamp: String? = nil, buyTokenType: String? = nil, buyTokenId: String? = nil, buyAssetId: String? = nil, buyTokenAddress: String? = nil, buyTokenName: String? = nil, buyMinQuantity: String? = nil, buyMaxQuantity: String? = nil, buyMetadata: String? = nil, sellTokenType: String? = nil, sellTokenId: String? = nil, sellAssetId: String? = nil, sellTokenAddress: String? = nil, sellTokenName: String? = nil, sellMinQuantity: String? = nil, sellMaxQuantity: String? = nil, sellMetadata: String? = nil, auxiliaryFeePercentages: String? = nil, auxiliaryFeeRecipients: String? = nil, includeFees: Bool? = nil) async throws -> ListOrdersResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = listOrdersWithRequestBuilder(pageSize: pageSize, cursor: cursor, orderBy: orderBy, direction: direction, user: user, status: status, minTimestamp: minTimestamp, maxTimestamp: maxTimestamp, updatedMinTimestamp: updatedMinTimestamp, updatedMaxTimestamp: updatedMaxTimestamp, buyTokenType: buyTokenType, buyTokenId: buyTokenId, buyAssetId: buyAssetId, buyTokenAddress: buyTokenAddress, buyTokenName: buyTokenName, buyMinQuantity: buyMinQuantity, buyMaxQuantity: buyMaxQuantity, buyMetadata: buyMetadata, sellTokenType: sellTokenType, sellTokenId: sellTokenId, sellAssetId: sellAssetId, sellTokenAddress: sellTokenAddress, sellTokenName: sellTokenName, sellMinQuantity: sellMinQuantity, sellMaxQuantity: sellMaxQuantity, sellMetadata: sellMetadata, auxiliaryFeePercentages: auxiliaryFeePercentages, auxiliaryFeeRecipients: auxiliaryFeeRecipients, includeFees: includeFees).execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
        }
    }

    /**
     Get a list of orders
     - GET /v1/orders
     - Get a list of orders
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter cursor: (query) Cursor (optional)
     - parameter orderBy: (query) Property to sort by (optional)
     - parameter direction: (query) Direction to sort (asc/desc) (optional)
     - parameter user: (query) Ethereum address of the user who submitted this order (optional)
     - parameter status: (query) Status of this order (optional)
     - parameter minTimestamp: (query) Minimum created at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter maxTimestamp: (query) Maximum created at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter updatedMinTimestamp: (query) Minimum updated at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter updatedMaxTimestamp: (query) Maximum updated at timestamp for this order, in ISO 8601 UTC format. Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
     - parameter buyTokenType: (query) Token type of the asset this order buys (optional)
     - parameter buyTokenId: (query) ERC721 Token ID of the asset this order buys (optional)
     - parameter buyAssetId: (query) Internal IMX ID of the asset this order buys (optional)
     - parameter buyTokenAddress: (query) Comma separated string of token addresses of the asset this order buys (optional)
     - parameter buyTokenName: (query) Token name of the asset this order buys (optional)
     - parameter buyMinQuantity: (query) Min quantity for the asset this order buys (optional)
     - parameter buyMaxQuantity: (query) Max quantity for the asset this order buys (optional)
     - parameter buyMetadata: (query) JSON-encoded metadata filters for the asset this order buys (optional)
     - parameter sellTokenType: (query) Token type of the asset this order sells (optional)
     - parameter sellTokenId: (query) ERC721 Token ID of the asset this order sells (optional)
     - parameter sellAssetId: (query) Internal IMX ID of the asset this order sells (optional)
     - parameter sellTokenAddress: (query) Comma separated string of token addresses of the asset this order sells (optional)
     - parameter sellTokenName: (query) Token name of the asset this order sells (optional)
     - parameter sellMinQuantity: (query) Min quantity for the asset this order sells (optional)
     - parameter sellMaxQuantity: (query) Max quantity for the asset this order sells (optional)
     - parameter sellMetadata: (query) JSON-encoded metadata filters for the asset this order sells (optional)
     - parameter auxiliaryFeePercentages: (query) Comma separated string of fee percentages that are to be paired with auxiliary_fee_recipients (optional)
     - parameter auxiliaryFeeRecipients: (query) Comma separated string of fee recipients that are to be paired with auxiliary_fee_percentages (optional)
     - parameter includeFees: (query) Set flag to true to include fee object for orders (optional)
     - returns: RequestBuilder<ListOrdersResponse> 
     */
    open class func listOrdersWithRequestBuilder(pageSize: Int? = nil, cursor: String? = nil, orderBy: OrderBy_listOrders? = nil, direction: String? = nil, user: String? = nil, status: Status_listOrders? = nil, minTimestamp: String? = nil, maxTimestamp: String? = nil, updatedMinTimestamp: String? = nil, updatedMaxTimestamp: String? = nil, buyTokenType: String? = nil, buyTokenId: String? = nil, buyAssetId: String? = nil, buyTokenAddress: String? = nil, buyTokenName: String? = nil, buyMinQuantity: String? = nil, buyMaxQuantity: String? = nil, buyMetadata: String? = nil, sellTokenType: String? = nil, sellTokenId: String? = nil, sellAssetId: String? = nil, sellTokenAddress: String? = nil, sellTokenName: String? = nil, sellMinQuantity: String? = nil, sellMaxQuantity: String? = nil, sellMetadata: String? = nil, auxiliaryFeePercentages: String? = nil, auxiliaryFeeRecipients: String? = nil, includeFees: Bool? = nil) -> RequestBuilder<ListOrdersResponse> {
        let localVariablePath = "/v1/orders"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "page_size": pageSize?.encodeToJSON(),
            "cursor": cursor?.encodeToJSON(),
            "order_by": orderBy?.encodeToJSON(),
            "direction": direction?.encodeToJSON(),
            "user": user?.encodeToJSON(),
            "status": status?.encodeToJSON(),
            "min_timestamp": minTimestamp?.encodeToJSON(),
            "max_timestamp": maxTimestamp?.encodeToJSON(),
            "updated_min_timestamp": updatedMinTimestamp?.encodeToJSON(),
            "updated_max_timestamp": updatedMaxTimestamp?.encodeToJSON(),
            "buy_token_type": buyTokenType?.encodeToJSON(),
            "buy_token_id": buyTokenId?.encodeToJSON(),
            "buy_asset_id": buyAssetId?.encodeToJSON(),
            "buy_token_address": buyTokenAddress?.encodeToJSON(),
            "buy_token_name": buyTokenName?.encodeToJSON(),
            "buy_min_quantity": buyMinQuantity?.encodeToJSON(),
            "buy_max_quantity": buyMaxQuantity?.encodeToJSON(),
            "buy_metadata": buyMetadata?.encodeToJSON(),
            "sell_token_type": sellTokenType?.encodeToJSON(),
            "sell_token_id": sellTokenId?.encodeToJSON(),
            "sell_asset_id": sellAssetId?.encodeToJSON(),
            "sell_token_address": sellTokenAddress?.encodeToJSON(),
            "sell_token_name": sellTokenName?.encodeToJSON(),
            "sell_min_quantity": sellMinQuantity?.encodeToJSON(),
            "sell_max_quantity": sellMaxQuantity?.encodeToJSON(),
            "sell_metadata": sellMetadata?.encodeToJSON(),
            "auxiliary_fee_percentages": auxiliaryFeePercentages?.encodeToJSON(),
            "auxiliary_fee_recipients": auxiliaryFeeRecipients?.encodeToJSON(),
            "include_fees": includeFees?.encodeToJSON(),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ListOrdersResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}
