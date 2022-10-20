import Foundation

class BuyCryptoWorkflow {
    /// Gets a URL to MoonPay that provides a service for buying crypto directly on Immutable in exchange for fiat.
    ///
    /// - Parameters:
    ///     - colorCodeHex: the color code in hex (e.g. #00818e) for the Moon pay widget main color.
    ///     It is used for buttons, links and highlighted text.
    ///     - signer: represents the users L1 wallet to get the address
    ///     - base: the config to be used for API keys and providers URLs
    /// - Returns: a website URL string to be used to launch a WebView or Browser to buy crypto
    /// - Throws: A variation of ``ImmutableXError``
    class func buyCryptoURL(colorCodeHex: String, signer: Signer, base: ImmutableXBase = ImmutableX.shared.base, moonpayAPI: MoonpayAPI = MoonpayAPI(), exchangesAPI: ExchangesAPI = ExchangesAPI(), usersAPI: UsersAPI.Type = UsersAPI.self) async throws -> String {
        let address = try await signer.getAddress()
        let isRegistered = try await RegisterWorkflow.isUserRegistered(address: address, api: usersAPI)

        guard isRegistered else {
            throw ImmutableXError.invalidRequest(
                reason: "Wallet is not registered. Call ImmutableX.shared.registerOffChain() to register your wallet."
            )
        }

        let transactionIdResponse = try await getTransactionId(address: address, api: exchangesAPI)
        let currenciesResponse = try await getSupportedCurrencies(address: address, api: exchangesAPI)
        let request = GetBuyCryptoURLRequest(
            apiKey: base.moonpayApiKey,
            colorCodeHex: colorCodeHex,
            externalTransaction: transactionIdResponse.id,
            walletAddress: address,
            currencies: currenciesResponse.currencyCodes
        )

        return try await getBuyCryptoURL(request: request, api: moonpayAPI)
    }

    private static func getTransactionId(address: String, api: ExchangesAPI) async throws -> GetTransactionIdResponse {
        try await Workflow.mapAPIErrors(caller: "Fetch transaction id") {
            try await api.getTransactionId(
                GetTransactionIdRequest(walletAddress: address, provider: .moonpay)
            )
        }
    }

    private static func getSupportedCurrencies(address: String, api: ExchangesAPI) async throws -> GetCurrenciesResponse {
        try await Workflow.mapAPIErrors(caller: "Fetch supported currencies") {
            try await api.getCurrencies(address: address)
        }
    }

    private static func getBuyCryptoURL(request: GetBuyCryptoURLRequest, api: MoonpayAPI) async throws -> String {
        try await Workflow.mapAPIErrors(caller: "Fetch crypto url") {
            try await api.getBuyCryptoURL(request)
        }
    }
}
