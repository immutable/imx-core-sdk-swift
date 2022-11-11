import Foundation

// swiftlint:disable file_length
// swiftlint:disable type_body_length
public struct ImmutableX {
    /// A shared instance of ``ImmutableX`` that holds configuration for ``base``, ``logLevel`` and
    /// a set o utility methods for the most common workflows for the core SDK.
    ///
    /// - Note: ``initialize(base:logLevel:)`` must be called before this instance
    /// is accessed.
    public internal(set) static var shared: ImmutableX!

    /// The environment the SDK will communicate with. Defaults to `.sandbox`.
    public let base: ImmutableXBase

    /// Defines the level of logging for ImmutableX network calls. Defaults to `.none`.
    ///
    ///  Setting `logLevel` to `.calls(including: [])` will log all requests and responses with HTTP Method and URL.
    ///  For richer logging include extra details of the calls to be logged, e.g.
    ///
    ///  ```swift
    ///  logLevel = .calls(including: [
    ///     .requestHeaders, .responseBody
    ///  ])
    ///  ```
    ///
    /// - Note: Logs are only available in debug mode.
    public var logLevel: ImmutableXHTTPLoggingLevel

    /// Returns the version of the sdk
    internal var sdkVersion: String = "0.4.0"

    private let buyWorkflow: BuyWorkflow.Type
    private let sellWorkflow: SellWorkflow.Type
    private let cancelOrderWorkflow: CancelOrderWorkflow.Type
    private let transferWorkflow: TransferWorkflow.Type
    private let registerWorkflow: RegisterWorkflow.Type
    private let buyCryptoWorkflow: BuyCryptoWorkflow.Type
    private let usersAPI: UsersAPI.Type
    private let depositAPI: DepositsAPI.Type
    private let assetsAPI: AssetsAPI.Type
    private let collectionsAPI: CollectionsAPI.Type
    private let projectsAPI: ProjectsAPI.Type

    /// Internal init method that includes dependencies. For the public facing API use ``initialize(base:logLevel:)``
    /// instead.
    internal init(
        base: ImmutableXBase = .sandbox,
        logLevel: ImmutableXHTTPLoggingLevel = .none,
        buyWorkflow: BuyWorkflow.Type = BuyWorkflow.self,
        sellWorkflow: SellWorkflow.Type = SellWorkflow.self,
        cancelOrderWorkflow: CancelOrderWorkflow.Type = CancelOrderWorkflow.self,
        transferWorkflow: TransferWorkflow.Type = TransferWorkflow.self,
        registerWorkflow: RegisterWorkflow.Type = RegisterWorkflow.self,
        buyCryptoWorkflow: BuyCryptoWorkflow.Type = BuyCryptoWorkflow.self,
        usersAPI: UsersAPI.Type = UsersAPI.self,
        depositAPI: DepositsAPI.Type = DepositsAPI.self,
        assetsAPI: AssetsAPI.Type = AssetsAPI.self,
        collectionsAPI: CollectionsAPI.Type = CollectionsAPI.self,
        projectsAPI: ProjectsAPI.Type = ProjectsAPI.self
    ) {
        self.base = base
        self.logLevel = logLevel
        self.buyWorkflow = buyWorkflow
        self.sellWorkflow = sellWorkflow
        self.cancelOrderWorkflow = cancelOrderWorkflow
        self.transferWorkflow = transferWorkflow
        self.registerWorkflow = registerWorkflow
        self.buyCryptoWorkflow = buyCryptoWorkflow
        self.usersAPI = usersAPI
        self.depositAPI = depositAPI
        self.assetsAPI = assetsAPI
        self.collectionsAPI = collectionsAPI
        self.projectsAPI = projectsAPI
    }

    /// Initializes the SDK with the given ``base`` and ``logLevel`` by assigning a shared instance accessible via
    /// `ImmutableX.shared`.
    public static func initialize(base: ImmutableXBase = .sandbox, logLevel: ImmutableXHTTPLoggingLevel = .none) {
        ImmutableX.shared = ImmutableX(base: base, logLevel: logLevel)
    }

    /// This is a utility function that will chain the necessary calls to buy an existing order.
    ///
    ///  - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - fees: taker fees information to be used in the buy order.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: a ``CreateTradeResponse`` that will provide the Trade id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    public func buy(
        orderId: String,
        fees: [FeeEntry] = [],
        signer: Signer,
        starkSigner: StarkSigner
    ) async throws -> CreateTradeResponse {
        try await buyWorkflow.buy(orderId: orderId, fees: fees, signer: signer, starkSigner: starkSigner)
    }

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
    public func sell(
        asset: AssetModel,
        sellToken: AssetModel,
        fees: [FeeEntry],
        signer: Signer,
        starkSigner: StarkSigner
    ) async throws -> CreateOrderResponse {
        try await sellWorkflow.sell(
            asset: asset,
            sellToken: sellToken,
            fees: fees,
            signer: signer,
            starkSigner: starkSigner
        )
    }

    /// This is a utility function that will chain the necessary calls to cancel an existing order.
    ///
    /// - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CancelOrderResponse`` that will provide the cancelled Order id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    public func cancelOrder(
        orderId: String,
        signer: Signer,
        starkSigner: StarkSigner
    ) async throws -> CancelOrderResponse {
        try await cancelOrderWorkflow.cancel(orderId: orderId, signer: signer, starkSigner: starkSigner)
    }

    /// This is a utility function that will chain the necessary calls to transfer a token.
    ///
    /// - Parameters:
    ///     - token: to be transferred (ETH, ERC20, or ERC721)
    ///     - recipientAddress: of the wallet that will receive the token
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CreateTransferResponse`` that will provide the transfer id if successful.
    /// - Throws: A variation of ``ImmutableXError``
    public func transfer(
        token: AssetModel,
        recipientAddress: String,
        signer: Signer,
        starkSigner: StarkSigner
    ) async throws -> CreateTransferResponse {
        try await transferWorkflow.transfer(
            token: token,
            recipientAddress: recipientAddress,
            signer: signer,
            starkSigner: starkSigner
        )
    }

    /// This is a utility function that will register a user to ImmutableX if they aren't already
    ///
    /// - Parameters:
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: `Void` if user is registered
    /// - Throws: A variation of ``ImmutableXError``
    public func registerOffchain(signer: Signer, starkSigner: StarkSigner) async throws {
        _ = try await registerWorkflow.registerOffchain(signer: signer, starkSigner: starkSigner)
    }

    /// Get stark keys for a registered user
    ///
    /// - Parameter ethAddress: User ETH address
    /// - Returns: ``GetUsersApiResponse``
    /// - Throws: A variation of ``ImmutableXError``
    public func getUser(ethAddress: String) async throws -> GetUsersApiResponse {
        try await APIErrorMapper.map(caller: "Get Users") {
            try await self.usersAPI.getUsers(user: ethAddress)
        }
    }

    /// Gets a URL to MoonPay that provides a service for buying crypto directly on Immutable in exchange for fiat.
    ///
    /// - Parameters:
    ///     - colorCodeHex: the color code in hex (e.g. #00818e) for the Moon pay widget main color.
    ///     It is used for buttons, links and highlighted text. Defaults to `#00818e`
    ///     - signer: represents the users L1 wallet to get the address
    /// - Returns: a website URL string to be used to launch a WebView or Browser to buy crypto
    /// - Throws: A variation of ``ImmutableXError``
    public func buyCryptoURL(colorCodeHex: String = "#00818e", signer: Signer) async throws -> String {
        try await buyCryptoWorkflow.buyCryptoURL(colorCodeHex: colorCodeHex, signer: signer)
    }

    /// Get details of a deposit with the given ID
    ///
    /// - Parameter id: Deposit ID
    /// - Returns: ``Deposit``
    /// - Throws: A variation of ``ImmutableXError``
    public func getDeposit(id: String) async throws -> Deposit {
        try await APIErrorMapper.map(caller: "Get Deposit") {
            try await self.depositAPI.getDeposit(id: id)
        }
    }

    /// Get a list of deposits
    ///
    /// - Parameters:
    ///   - pageSize: Page size of the result (optional)
    ///   - cursor: Cursor (optional)
    ///   - orderBy: Property to sort by (optional)
    ///   - direction: Direction to sort (asc/desc) (optional)
    ///   - user: Ethereum address of the user who submitted this deposit (optional)
    ///   - status: Status of this deposit (optional)
    ///   - updatedMinTimestamp: Minimum timestamp for this deposit, in ISO 8601 UTC format.
    ///     Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
    ///   - updatedMaxTimestamp: Maximum timestamp for this deposit, in ISO 8601 UTC format.
    ///     Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
    ///   - tokenType: Token type of the deposited asset (optional)
    ///   - tokenId: ERC721 Token ID of the minted asset (optional)
    ///   - assetId: Internal IMX ID of the minted asset (optional)
    ///   - tokenAddress: Token address of the deposited asset (optional)
    ///   - tokenName: Token name of the deposited asset (optional)
    ///   - minQuantity: Min quantity for the deposited asset (optional)
    ///   - maxQuantity: Max quantity for the deposited asset (optional)
    ///   - metadata: (JSON-encoded metadata filters for the deposited asset (optional)
    /// - Returns: ``ListDepositsResponse``
    /// - Throws: A variation of ``ImmutableXError``
    public func listDeposits(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: String? = nil,
        direction: String? = nil,
        user: String? = nil,
        status: String? = nil,
        updatedMinTimestamp: String? = nil,
        updatedMaxTimestamp: String? = nil,
        tokenType: String? = nil,
        tokenId: String? = nil,
        assetId: String? = nil,
        tokenAddress: String? = nil,
        tokenName: String? = nil,
        minQuantity: String? = nil,
        maxQuantity: String? = nil,
        metadata: String? = nil
    ) async throws -> ListDepositsResponse {
        try await APIErrorMapper.map(caller: "Get Deposit") {
            try await self.depositAPI.listDeposits(
                pageSize: pageSize,
                cursor: cursor,
                orderBy: orderBy,
                direction: direction,
                user: user,
                status: status,
                updatedMinTimestamp: updatedMinTimestamp,
                updatedMaxTimestamp: updatedMaxTimestamp,
                tokenType: tokenType,
                tokenId: tokenId,
                assetId: assetId,
                tokenAddress: tokenAddress,
                tokenName: tokenName,
                minQuantity: minQuantity,
                maxQuantity: maxQuantity,
                metadata: metadata
            )
        }
    }

    /// Get details of an asset
    ///
    /// - Parameters:
    ///     - tokenAddress: Address of the ERC721 contract
    ///     - tokenId: Either ERC721 token ID or internal IMX ID
    ///     - includeFees: Set flag to include fees associated with the asset (optional)
    /// - Returns: ``Asset``
    /// - Throws: A variation of ``ImmutableXError``
    public func getAsset(tokenAddress: String, tokenId: String, includeFees: Bool? = nil) async throws -> Asset {
        try await APIErrorMapper.map(caller: "Get Asset") {
            try await self.assetsAPI.getAsset(tokenAddress: tokenAddress, tokenId: tokenId, includeFees: includeFees)
        }
    }

    /// Get a list of assets
    ///
    /// - Parameters:
    ///     - pageSize: Page size of the result (optional)
    ///     - cursor: Cursor (optional)
    ///     - orderBy: Property to sort by (optional)
    ///     - direction: Direction to sort (asc/desc) (optional)
    ///     - user: Ethereum address of the user who owns these assets (optional)
    ///     - status: Status of these assets (optional)
    ///     - name: Name of the asset to search (optional)
    ///     - metadata: JSON-encoded metadata filters for these asset.
    ///     Example: {&#39;proto&#39;:[&#39;1147&#39;],&#39;quality&#39;:[&#39;Meteorite&#39;]} (optional)
    ///     - sellOrders: Set flag to true to fetch an array of sell order details with accepted status associated with
    ///     the asset (optional)
    ///     - buyOrders: Set flag to true to fetch an array of buy order details  with accepted status associated with
    ///     the asset (optional)
    ///     - includeFees: Set flag to include fees associated with the asset (optional)
    ///     - collection: Collection contract address (optional)
    ///     - updatedMinTimestamp: Minimum timestamp for when these assets were last updated, in ISO 8601 UTC format.
    ///     Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
    ///     - updatedMaxTimestamp: Maximum timestamp for when these assets were last updated, in ISO 8601 UTC format.
    ///     Example: &#39;2022-05-27T00:10:22Z&#39; (optional)
    ///     - auxiliaryFeePercentages: Comma separated string of fee percentages that are to be paired with
    ///     auxiliary_fee_recipients (optional)
    ///     - auxiliaryFeeRecipients: Comma separated string of fee recipients that are to be paired with
    ///     auxiliary_fee_percentages (optional)
    /// - Returns: ``ListAssetsResponse``
    /// - Throws: A variation of ``ImmutableXError``
    public func listAssets(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: ListAssetsOrderBy? = nil,
        direction: String? = nil,
        user: String? = nil,
        status: String? = nil,
        name: String? = nil,
        metadata: String? = nil,
        sellOrders: Bool? = nil,
        buyOrders: Bool? = nil,
        includeFees: Bool? = nil,
        collection: String? = nil,
        updatedMinTimestamp: String? = nil,
        updatedMaxTimestamp: String? = nil,
        auxiliaryFeePercentages: String? = nil,
        auxiliaryFeeRecipients: String? = nil
    ) async throws -> ListAssetsResponse {
        try await APIErrorMapper.map(caller: "List Assets") {
            try await self.assetsAPI.listAssets(
                pageSize: pageSize,
                cursor: cursor,
                orderBy: orderBy?.asApiArgument,
                direction: direction,
                user: user,
                status: status,
                name: name,
                metadata: metadata,
                sellOrders: sellOrders,
                buyOrders: buyOrders,
                includeFees: includeFees,
                collection: collection,
                updatedMinTimestamp: updatedMinTimestamp,
                updatedMaxTimestamp: updatedMaxTimestamp,
                auxiliaryFeePercentages: auxiliaryFeePercentages,
                auxiliaryFeeRecipients: auxiliaryFeeRecipients
            )
        }
    }

    /// Get details of a collection at the given address
    ///
    /// - Parameter address: Collection contract address
    /// - Returns: ``Collection``
    /// - Throws: A variation of ``ImmutableXError``
    public func getCollection(address: String) async throws -> Collection {
        try await APIErrorMapper.map(caller: "Get Collection") {
            try await self.collectionsAPI.getCollection(address: address)
        }
    }

    /// Get a list of collection filters
    ///
    /// - Parameters:
    ///     - address: Collection contract address
    ///     - pageSize: Page size of the result (optional)
    ///     - nextPageToken: Next page token (optional)
    /// - Returns: ``CollectionFilter``
    /// - Throws: A variation of ``ImmutableXError``
    public func listCollectionFilters(
        address: String,
        pageSize: Int? = nil,
        nextPageToken: String? = nil
    ) async throws -> CollectionFilter {
        try await APIErrorMapper.map(caller: "List Collection Filters") {
            try await self.collectionsAPI.listCollectionFilters(
                address: address,
                pageSize: pageSize,
                nextPageToken: nextPageToken
            )
        }
    }

    /// Get a list of collections
    ///
    /// - Parameters:
    ///     - pageSize: Page size of the result (optional)
    ///     - cursor: Cursor (optional)
    ///     - orderBy: Property to sort by (optional)
    ///     - direction: Direction to sort (asc/desc) (optional)
    ///     - blacklist: List of collections not to be included, separated by commas (optional)
    ///     - whitelist: List of collections to be included, separated by commas (optional)
    ///     - keyword: Keyword to search in collection name and description (optional)
    /// - Returns: ``ListCollectionsResponse``
    /// - Throws: A variation of ``ImmutableXError``
    public func listCollections(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: ListCollectionsOrderBy? = nil,
        direction: String? = nil,
        blacklist: String? = nil,
        whitelist: String? = nil,
        keyword: String? = nil
    ) async throws -> ListCollectionsResponse {
        try await APIErrorMapper.map(caller: "List Collections") {
            try await self.collectionsAPI.listCollections(
                pageSize: pageSize,
                cursor: cursor,
                orderBy: orderBy?.asApiArgument,
                direction: direction,
                blacklist: blacklist,
                whitelist: whitelist,
                keyword: keyword
            )
        }
    }

    /// Get a project
    ///
    /// - Parameters:
    ///     - id: Project ID
    ///     - signer: represents the users L1 wallet to get the address and sign the registration
    /// - Returns: ``Project``
    /// - Throws: A variation of ``ImmutableXError``
    public func getProject(id: String, signer: Signer) async throws -> Project {
        try await APIErrorMapper.map(caller: "Get Project") {
            let (timestamp, signature) = try await IMXTimestamp.request(signer: signer)
            return try await self.projectsAPI.getProject(id: id, iMXSignature: signature, iMXTimestamp: timestamp)
        }
    }

    /// Get projects
    ///
    /// - Parameters:
    ///     - pageSize: Page size of the result (optional)
    ///     - cursor: Cursor (optional)
    ///     - orderBy: Property to sort by (optional)
    ///     - direction: Direction to sort (asc/desc) (optional)
    ///     - signer: represents the users L1 wallet to get the address and sign the registration
    /// - returns: ``GetProjectsResponse``
    /// - Throws: A variation of ``ImmutableXError``
    public func getProjects(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: String? = nil,
        direction: String? = nil,
        signer: Signer
    ) async throws -> GetProjectsResponse {
        try await APIErrorMapper.map(caller: "Get Projects") {
            let (timestamp, signature) = try await IMXTimestamp.request(signer: signer)
            return try await self.projectsAPI.getProjects(
                iMXSignature: signature,
                iMXTimestamp: timestamp,
                pageSize: pageSize,
                cursor: cursor,
                orderBy: orderBy,
                direction: direction
            )
        }
    }
}
