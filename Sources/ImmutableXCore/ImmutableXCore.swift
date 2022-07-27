import Foundation

// swiftlint:disable function_parameter_count
public struct ImmutableXCore {
    /// A shared instance of ``ImmutableXCore`` that holds configuration for ``base``, ``logLevel`` and
    /// a set o utility methods for the most common workflows for the core SDK.
    ///
    /// - Note: ``initialize(base:logLevel:)`` must be called before this instance
    /// is accessed.
    public private(set) static var shared: ImmutableXCore!

    /// The environment the SDK will communicate with. Defaults to `.ropsten`.
    public let base: ImmutableXBase

    /// Defines the level of logging for ImmutableXCore network calls. Defaults to `.none`.
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

    /// Returns the version of the sdk reading from the `version` file, e.g. `"1.0.0"`
    internal var sdkVersion: String {
        let file = Bundle.module.path(forResource: "version", ofType: "")!
        // swiftlint:disable:next force_try
        return try! String(contentsOfFile: file).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    private let buyWorkflow: BuyWorkflow.Type
    private let sellWorkflow: SellWorkflow.Type
    private let cancelOrderWorkflow: CancelOrderWorkflow.Type
    private let transferWorkflow: TransferWorkflow.Type
    private let registerWorkflow: RegisterWorkflow.Type

    /// Internal init method that includes dependencies. For the public facing API use ``initialize(base:logLevel:)`` instead.
    internal init(base: ImmutableXBase = .ropsten, logLevel: ImmutableXHTTPLoggingLevel = .none, buyWorkflow: BuyWorkflow.Type = BuyWorkflow.self, sellWorkflow: SellWorkflow.Type = SellWorkflow.self, cancelOrderWorkflow: CancelOrderWorkflow.Type = CancelOrderWorkflow.self, transferWorkflow: TransferWorkflow.Type = TransferWorkflow.self, registerWorkflow: RegisterWorkflow.Type = RegisterWorkflow.self) {
        self.base = base
        self.logLevel = logLevel
        self.buyWorkflow = buyWorkflow
        self.sellWorkflow = sellWorkflow
        self.cancelOrderWorkflow = cancelOrderWorkflow
        self.transferWorkflow = transferWorkflow
        self.registerWorkflow = registerWorkflow
    }

    /// Initializes the SDK with the given ``base`` and ``logLevel`` by assigning a shared instance accessible via `ImmutableXCore.shared`.
    public static func initialize(base: ImmutableXBase = .ropsten, logLevel: ImmutableXHTTPLoggingLevel = .none) {
        ImmutableXCore.shared = ImmutableXCore(base: base, logLevel: logLevel)
    }

    /// This is a utility function that will chain the necessary calls to buy an existing order.
    ///
    ///  - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - fees: taker fees information to be used in the buy order.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: a ``CreateTradeResponse`` that will provide the Trade id if successful.
    /// - Throws: An error conforming to ``ImmutableXError`` protocol
    public func buy(orderId: String, fees: [FeeEntry] = [], signer: Signer, starkSigner: StarkSigner) async throws -> CreateTradeResponse {
        try await buyWorkflow.buy(orderId: orderId, fees: fees, signer: signer, starkSigner: starkSigner)
    }

    /// This is a utility function that will chain the necessary calls to buy an existing order.
    ///
    ///  - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - fees: taker fees information to be used in the buy order.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: a ``CreateTradeResponse`` tthat will provide the Trade id if successful
    ///  or an error conforming to ``ImmutableXError`` protocol through the `onCompletion` callback
    ///
    /// - Note: `onCompletion` is executed on the Main Thread
    public func buy(orderId: String, fees: [FeeEntry] = [], signer: Signer, starkSigner: StarkSigner, onCompletion: @escaping (Result<CreateTradeResponse, Error>) -> Void) {
        Task { @MainActor in
            do {
                let response = try await buyWorkflow.buy(orderId: orderId, fees: fees, signer: signer, starkSigner: starkSigner)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
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
    /// - Throws: A variation of ``ImmutableXError`` including ``WorkflowError``
    public func sell(asset: AssetModel, sellToken: AssetModel, fees: [FeeEntry], signer: Signer, starkSigner: StarkSigner) async throws -> CreateOrderResponse {
        try await sellWorkflow.sell(asset: asset, sellToken: sellToken, fees: fees, signer: signer, starkSigner: starkSigner)
    }

    /// This is a utility function that will chain the necessary calls to sell an asset.
    ///
    /// - Parameters:
    ///     - asset: the asset to sell
    ///     - sellToken: the type of token and how much of it to sell the asset for
    ///     - fees: maker fees information to be used in the sell order.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: a ``CreateOrderResponse`` that will provide the Order id if successful
    ///  or an error conforming to ``ImmutableXError`` protocol through the `onCompletion` callback
    ///
    /// - Note: `onCompletion` is executed on the Main Thread
    public func sell(asset: AssetModel, sellToken: AssetModel, fees: [FeeEntry], signer: Signer, starkSigner: StarkSigner, onCompletion: @escaping (Result<CreateOrderResponse, Error>) -> Void) {
        Task { @MainActor in
            do {
                let response = try await sellWorkflow.sell(asset: asset, sellToken: sellToken, fees: fees, signer: signer, starkSigner: starkSigner)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }

    /// This is a utility function that will chain the necessary calls to cancel an existing order.
    ///
    /// - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CancelOrderResponse`` that will provide the cancelled Order id if successful.
    /// - Throws: A variation of ``ImmutableXError`` including ``WorkflowError``
    public func cancelOrder(orderId: String, signer: Signer, starkSigner: StarkSigner) async throws -> CancelOrderResponse {
        try await cancelOrderWorkflow.cancel(orderId: orderId, signer: signer, starkSigner: starkSigner)
    }

    /// This is a utility function that will chain the necessary calls to cancel an existing order.
    ///
    /// - Parameters:
    ///     - orderId: the id of an existing order to be bought
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: a ``CancelOrderResponse`` that will provide the cancelled Order id if successful
    ///  or an error conforming to ``ImmutableXError`` protocol through the `onCompletion` callback
    ///
    /// - Note: `onCompletion` is executed on the Main Thread
    public func cancelOrder(orderId: String, signer: Signer, starkSigner: StarkSigner, onCompletion: @escaping (Result<CancelOrderResponse, Error>) -> Void) {
        Task { @MainActor in
            do {
                let response = try await cancelOrderWorkflow.cancel(orderId: orderId, signer: signer, starkSigner: starkSigner)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }

    /// This is a utility function that will chain the necessary calls to transfer a token.
    ///
    /// - Parameters:
    ///     - token: to be transferred (ETH, ERC20, or ERC721)
    ///     - recipientAddress: of the wallet that will receive the token
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``CreateTransferResponse`` that will provide the transfer id if successful.
    /// - Throws: A variation of ``ImmutableXError`` including ``WorkflowError``
    public func transfer(token: AssetModel, recipientAddress: String, signer: Signer, starkSigner: StarkSigner) async throws -> CreateTransferResponse {
        try await transferWorkflow.transfer(token: token, recipientAddress: recipientAddress, signer: signer, starkSigner: starkSigner)
    }

    /// This is a utility function that will chain the necessary calls to transfer a token.
    ///
    /// - Parameters:
    ///     - token: to be transferred (ETH, ERC20, or ERC721)
    ///     - recipientAddress: of the wallet that will receive the token
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: a ``CreateTransferResponse`` that will provide the transfer id if successful
    ///  or an error conforming to ``ImmutableXError`` protocol through the `onCompletion` callback
    ///
    /// - Note: `onCompletion` is executed on the Main Thread
    public func transfer(token: AssetModel, recipientAddress: String, signer: Signer, starkSigner: StarkSigner, onCompletion: @escaping (Result<CreateTransferResponse, Error>) -> Void) {
        Task { @MainActor in
            do {
                let response = try await transferWorkflow.transfer(token: token, recipientAddress: recipientAddress, signer: signer, starkSigner: starkSigner)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }

    /// This is a utility function that will register a user to Immutable X if they aren't already
    ///
    /// - Parameters:
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``Void`` if user is registered
    /// - Throws: A variation of ``ImmutableXError`` including ``WorkflowError``
    public func registerOffchain(signer: Signer, starkSigner: StarkSigner) async throws {
        _ = try await registerWorkflow.registerOffchain(signer: signer, starkSigner: starkSigner)
    }

    /// This is a utility function that will register a user to Immutable X if they aren't already
    ///
    /// - Parameters:
    ///     - signer: represents the users L1 wallet to get the address
    ///     - starkSigner: represents the users L2 wallet used to sign and verify the L2 transaction
    /// - Returns: ``Void`` if user is registered or an error conforming to ``ImmutableXError`` protocol through
    /// the `onCompletion` callback
    ///
    /// - Note: `onCompletion` is executed on the Main Thread
    public func registerOffchain(signer: Signer, starkSigner: StarkSigner, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        Task { @MainActor in
            do {
                _ = try await registerWorkflow.registerOffchain(signer: signer, starkSigner: starkSigner)
                onCompletion(.success(()))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
}
