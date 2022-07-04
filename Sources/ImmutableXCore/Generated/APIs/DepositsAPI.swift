//
// DepositsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class DepositsAPI {

    /**
     Get details of a deposit with the given ID
     
     - parameter id: (path) Deposit ID 
     - returns: Deposit
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getDeposit(id: String) async throws -> Deposit {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = getDepositWithRequestBuilder(id: id).execute { result in
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
     Get details of a deposit with the given ID
     - GET /v1/deposits/{id}
     - Get details of a deposit with the given ID
     - parameter id: (path) Deposit ID 
     - returns: RequestBuilder<Deposit> 
     */
    open class func getDepositWithRequestBuilder(id: String) -> RequestBuilder<Deposit> {
        var localVariablePath = "/v1/deposits/{id}"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Deposit>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Gets details of a signable deposit
     
     - parameter getSignableDepositRequest: (body) Get details of signable deposit 
     - returns: GetSignableDepositResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getSignableDeposit(getSignableDepositRequest: GetSignableDepositRequest) async throws -> GetSignableDepositResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = getSignableDepositWithRequestBuilder(getSignableDepositRequest: getSignableDepositRequest).execute { result in
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
     Gets details of a signable deposit
     - POST /v1/signable-deposit-details
     - Gets details of a signable deposit
     - parameter getSignableDepositRequest: (body) Get details of signable deposit 
     - returns: RequestBuilder<GetSignableDepositResponse> 
     */
    open class func getSignableDepositWithRequestBuilder(getSignableDepositRequest: GetSignableDepositRequest) -> RequestBuilder<GetSignableDepositResponse> {
        let localVariablePath = "/v1/signable-deposit-details"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: getSignableDepositRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<GetSignableDepositResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get a list of deposits
     
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter cursor: (query) Cursor (optional)
     - parameter orderBy: (query) Property to sort by (optional)
     - parameter direction: (query) Direction to sort (asc/desc) (optional)
     - parameter user: (query) Ethereum address of the user who submitted this deposit (optional)
     - parameter status: (query) Status of this deposit (optional)
     - parameter minTimestamp: (query) Minimum timestamp for this deposit (optional)
     - parameter maxTimestamp: (query) Maximum timestamp for this deposit (optional)
     - parameter tokenType: (query) Token type of the deposited asset (optional)
     - parameter tokenId: (query) ERC721 Token ID of the minted asset (optional)
     - parameter assetId: (query) Internal IMX ID of the minted asset (optional)
     - parameter tokenAddress: (query) Token address of the deposited asset (optional)
     - parameter tokenName: (query) Token name of the deposited asset (optional)
     - parameter minQuantity: (query) Min quantity for the deposited asset (optional)
     - parameter maxQuantity: (query) Max quantity for the deposited asset (optional)
     - parameter metadata: (query) JSON-encoded metadata filters for the deposited asset (optional)
     - returns: ListDepositsResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func listDeposits(pageSize: Int? = nil, cursor: String? = nil, orderBy: String? = nil, direction: String? = nil, user: String? = nil, status: String? = nil, minTimestamp: String? = nil, maxTimestamp: String? = nil, tokenType: String? = nil, tokenId: String? = nil, assetId: String? = nil, tokenAddress: String? = nil, tokenName: String? = nil, minQuantity: String? = nil, maxQuantity: String? = nil, metadata: String? = nil) async throws -> ListDepositsResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = listDepositsWithRequestBuilder(pageSize: pageSize, cursor: cursor, orderBy: orderBy, direction: direction, user: user, status: status, minTimestamp: minTimestamp, maxTimestamp: maxTimestamp, tokenType: tokenType, tokenId: tokenId, assetId: assetId, tokenAddress: tokenAddress, tokenName: tokenName, minQuantity: minQuantity, maxQuantity: maxQuantity, metadata: metadata).execute { result in
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
     Get a list of deposits
     - GET /v1/deposits
     - Get a list of deposits
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter cursor: (query) Cursor (optional)
     - parameter orderBy: (query) Property to sort by (optional)
     - parameter direction: (query) Direction to sort (asc/desc) (optional)
     - parameter user: (query) Ethereum address of the user who submitted this deposit (optional)
     - parameter status: (query) Status of this deposit (optional)
     - parameter minTimestamp: (query) Minimum timestamp for this deposit (optional)
     - parameter maxTimestamp: (query) Maximum timestamp for this deposit (optional)
     - parameter tokenType: (query) Token type of the deposited asset (optional)
     - parameter tokenId: (query) ERC721 Token ID of the minted asset (optional)
     - parameter assetId: (query) Internal IMX ID of the minted asset (optional)
     - parameter tokenAddress: (query) Token address of the deposited asset (optional)
     - parameter tokenName: (query) Token name of the deposited asset (optional)
     - parameter minQuantity: (query) Min quantity for the deposited asset (optional)
     - parameter maxQuantity: (query) Max quantity for the deposited asset (optional)
     - parameter metadata: (query) JSON-encoded metadata filters for the deposited asset (optional)
     - returns: RequestBuilder<ListDepositsResponse> 
     */
    open class func listDepositsWithRequestBuilder(pageSize: Int? = nil, cursor: String? = nil, orderBy: String? = nil, direction: String? = nil, user: String? = nil, status: String? = nil, minTimestamp: String? = nil, maxTimestamp: String? = nil, tokenType: String? = nil, tokenId: String? = nil, assetId: String? = nil, tokenAddress: String? = nil, tokenName: String? = nil, minQuantity: String? = nil, maxQuantity: String? = nil, metadata: String? = nil) -> RequestBuilder<ListDepositsResponse> {
        let localVariablePath = "/v1/deposits"
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
            "token_type": tokenType?.encodeToJSON(),
            "token_id": tokenId?.encodeToJSON(),
            "asset_id": assetId?.encodeToJSON(),
            "token_address": tokenAddress?.encodeToJSON(),
            "token_name": tokenName?.encodeToJSON(),
            "min_quantity": minQuantity?.encodeToJSON(),
            "max_quantity": maxQuantity?.encodeToJSON(),
            "metadata": metadata?.encodeToJSON(),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ListDepositsResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}
