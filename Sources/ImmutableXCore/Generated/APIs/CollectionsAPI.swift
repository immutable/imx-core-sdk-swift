//
// CollectionsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class CollectionsAPI {

    /**
     Create collection
     
     - parameter iMXSignature: (header) String created by signing wallet address and timestamp. See https://docs.x.immutable.com/docs/generate-imx-signature 
     - parameter iMXTimestamp: (header) Unix Epoc timestamp 
     - parameter createCollectionRequest: (body) create a collection 
     - returns: Collection
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func createCollection(iMXSignature: String, iMXTimestamp: String, createCollectionRequest: CreateCollectionRequest) async throws -> Collection {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = createCollectionWithRequestBuilder(iMXSignature: iMXSignature, iMXTimestamp: iMXTimestamp, createCollectionRequest: createCollectionRequest).execute { result in
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
     Create collection
     - POST /v1/collections
     - Create collection
     - responseHeaders: [Collection_Limit_Reset(String), Collection_Limit(String), Collection_Remaining(String)]
     - parameter iMXSignature: (header) String created by signing wallet address and timestamp. See https://docs.x.immutable.com/docs/generate-imx-signature 
     - parameter iMXTimestamp: (header) Unix Epoc timestamp 
     - parameter createCollectionRequest: (body) create a collection 
     - returns: RequestBuilder<Collection> 
     */
    open class func createCollectionWithRequestBuilder(iMXSignature: String, iMXTimestamp: String, createCollectionRequest: CreateCollectionRequest) -> RequestBuilder<Collection> {
        let localVariablePath = "/v1/collections"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: createCollectionRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "IMX-Signature": iMXSignature.encodeToJSON(),
            "IMX-Timestamp": iMXTimestamp.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Collection>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get details of a collection at the given address
     
     - parameter address: (path) Collection contract address 
     - returns: Collection
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getCollection(address: String) async throws -> Collection {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = getCollectionWithRequestBuilder(address: address).execute { result in
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
     Get details of a collection at the given address
     - GET /v1/collections/{address}
     - Get details of a collection at the given address
     - parameter address: (path) Collection contract address 
     - returns: RequestBuilder<Collection> 
     */
    open class func getCollectionWithRequestBuilder(address: String) -> RequestBuilder<Collection> {
        var localVariablePath = "/v1/collections/{address}"
        let addressPreEscape = "\(APIHelper.mapValueToPathItem(address))"
        let addressPostEscape = addressPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{address}", with: addressPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Collection>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get a list of collection filters
     
     - parameter address: (path) Collection contract address 
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter nextPageToken: (query) Next page token (optional)
     - returns: CollectionFilter
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func listCollectionFilters(address: String, pageSize: Int? = nil, nextPageToken: String? = nil) async throws -> CollectionFilter {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = listCollectionFiltersWithRequestBuilder(address: address, pageSize: pageSize, nextPageToken: nextPageToken).execute { result in
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
     Get a list of collection filters
     - GET /v1/collections/{address}/filters
     - Get a list of collection filters
     - parameter address: (path) Collection contract address 
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter nextPageToken: (query) Next page token (optional)
     - returns: RequestBuilder<CollectionFilter> 
     */
    open class func listCollectionFiltersWithRequestBuilder(address: String, pageSize: Int? = nil, nextPageToken: String? = nil) -> RequestBuilder<CollectionFilter> {
        var localVariablePath = "/v1/collections/{address}/filters"
        let addressPreEscape = "\(APIHelper.mapValueToPathItem(address))"
        let addressPostEscape = addressPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{address}", with: addressPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "page_size": pageSize?.encodeToJSON(),
            "next_page_token": nextPageToken?.encodeToJSON(),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<CollectionFilter>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     * enum for parameter orderBy
     */
    public enum OrderBy_listCollections: String, CaseIterable {
        case name = "name"
        case address = "address"
        case projectId = "project_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    /**
     Get a list of collections
     
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter cursor: (query) Cursor (optional)
     - parameter orderBy: (query) Property to sort by (optional)
     - parameter direction: (query) Direction to sort (asc/desc) (optional)
     - parameter blacklist: (query) List of collections not to be included, separated by commas (optional)
     - parameter whitelist: (query) List of collections to be included, separated by commas (optional)
     - parameter keyword: (query) Keyword to search in collection name and description (optional)
     - returns: ListCollectionsResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func listCollections(pageSize: Int? = nil, cursor: String? = nil, orderBy: OrderBy_listCollections? = nil, direction: String? = nil, blacklist: String? = nil, whitelist: String? = nil, keyword: String? = nil) async throws -> ListCollectionsResponse {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = listCollectionsWithRequestBuilder(pageSize: pageSize, cursor: cursor, orderBy: orderBy, direction: direction, blacklist: blacklist, whitelist: whitelist, keyword: keyword).execute { result in
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
     Get a list of collections
     - GET /v1/collections
     - Get a list of collections
     - parameter pageSize: (query) Page size of the result (optional)
     - parameter cursor: (query) Cursor (optional)
     - parameter orderBy: (query) Property to sort by (optional)
     - parameter direction: (query) Direction to sort (asc/desc) (optional)
     - parameter blacklist: (query) List of collections not to be included, separated by commas (optional)
     - parameter whitelist: (query) List of collections to be included, separated by commas (optional)
     - parameter keyword: (query) Keyword to search in collection name and description (optional)
     - returns: RequestBuilder<ListCollectionsResponse> 
     */
    open class func listCollectionsWithRequestBuilder(pageSize: Int? = nil, cursor: String? = nil, orderBy: OrderBy_listCollections? = nil, direction: String? = nil, blacklist: String? = nil, whitelist: String? = nil, keyword: String? = nil) -> RequestBuilder<ListCollectionsResponse> {
        let localVariablePath = "/v1/collections"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "page_size": pageSize?.encodeToJSON(),
            "cursor": cursor?.encodeToJSON(),
            "order_by": orderBy?.encodeToJSON(),
            "direction": direction?.encodeToJSON(),
            "blacklist": blacklist?.encodeToJSON(),
            "whitelist": whitelist?.encodeToJSON(),
            "keyword": keyword?.encodeToJSON(),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ListCollectionsResponse>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Update collection
     
     - parameter address: (path) Collection contract address 
     - parameter iMXSignature: (header) String created by signing wallet address and timestamp 
     - parameter iMXTimestamp: (header) Unix Epoc timestamp 
     - parameter updateCollectionRequest: (body) update a collection 
     - returns: Collection
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func updateCollection(address: String, iMXSignature: String, iMXTimestamp: String, updateCollectionRequest: UpdateCollectionRequest) async throws -> Collection {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = updateCollectionWithRequestBuilder(address: address, iMXSignature: iMXSignature, iMXTimestamp: iMXTimestamp, updateCollectionRequest: updateCollectionRequest).execute { result in
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
     Update collection
     - PATCH /v1/collections/{address}
     - Update collection
     - parameter address: (path) Collection contract address 
     - parameter iMXSignature: (header) String created by signing wallet address and timestamp 
     - parameter iMXTimestamp: (header) Unix Epoc timestamp 
     - parameter updateCollectionRequest: (body) update a collection 
     - returns: RequestBuilder<Collection> 
     */
    open class func updateCollectionWithRequestBuilder(address: String, iMXSignature: String, iMXTimestamp: String, updateCollectionRequest: UpdateCollectionRequest) -> RequestBuilder<Collection> {
        var localVariablePath = "/v1/collections/{address}"
        let addressPreEscape = "\(APIHelper.mapValueToPathItem(address))"
        let addressPostEscape = addressPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{address}", with: addressPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: updateCollectionRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "IMX-Signature": iMXSignature.encodeToJSON(),
            "IMX-Timestamp": iMXTimestamp.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Collection>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "PATCH", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}
