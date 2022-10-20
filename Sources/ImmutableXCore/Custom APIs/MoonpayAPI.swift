import Foundation

struct GetBuyCryptoURLRequest: Codable {
    let apiKey: String
    let colorCodeHex: String
    let externalTransaction: Int
    let walletAddress: String
    let currencies: [String: String]

    init(apiKey: String = ImmutableX.shared.base.moonpayApiKey, colorCodeHex: String, externalTransaction: Int, walletAddress: String, currencies: [String: String]) {
        self.apiKey = apiKey
        self.colorCodeHex = colorCodeHex
        self.externalTransaction = externalTransaction
        self.walletAddress = walletAddress
        self.currencies = currencies
    }

    func asURLEncodedString() throws -> String {
        let currenciesJson = try JSONSerialization.data(withJSONObject: currencies, options: .fragmentsAllowed)
        let jsonString = try String(data: currenciesJson, encoding: .utf8).orThrow(.invalidRequest(reason: "Invalid Buy Crypto Arguments"))

        // Moonpay won't allow colon or comma as query parameter
        let jsonEncoded = try jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed.subtracting(CharacterSet(charactersIn: ":,")))
            .orThrow(.invalidRequest(reason: "Invalid Buy Crypto Arguments"))

        // URLComponents applies encoding in a way that won't work with Moonpay
        return "apiKey=\(apiKey)" +
            "&baseCurrencyCode=usd" +
            "&colorCode=%23\(colorCodeHex.dropHexPrefix)" +
            "&externalTransactionId=\(externalTransaction)" +
            "&walletAddress=\(walletAddress)" +
            "&walletAddresses=\(jsonEncoded)"
    }
}

struct GetSignedMoonpayRequest: Codable {
    let request: String
}

struct GetSignedMoonpayResponse: Codable {
    let signature: String
}

class MoonpayAPI {
    static let encodedEqualSign = "%3D"
    let requestBuilderFactory: RequestBuilderFactory
    let core: ImmutableX

    init(requestBuilderFactory: RequestBuilderFactory = OpenAPIClientAPI.requestBuilderFactory, core: ImmutableX = ImmutableX.shared) {
        self.requestBuilderFactory = requestBuilderFactory
        self.core = core
    }

    /// Returns the Moonpay URL for the given `request` params
    func getBuyCryptoURL(_ request: GetBuyCryptoURLRequest) async throws -> String {
        let URLString = OpenAPIClientAPI.basePath + "/v2/moonpay/sign-url"
        let requestEncodedString = try request.asURLEncodedString()

        let parameters = JSONEncodingHelper.encodingParameters(
            forEncodableObject: GetSignedMoonpayRequest(
                request: requestEncodedString
            )
        )

        let requestBuilderType: RequestBuilder<GetSignedMoonpayResponse>.Type = requestBuilderFactory.getBuilder()
        let requestBuilder = requestBuilderType.init(
            method: "POST",
            URLString: URLString,
            parameters: parameters
        )

        let response = try await requestBuilder.execute()
        let signature = response.signature.replacingOccurrences(of: MoonpayAPI.encodedEqualSign, with: "")

        return "\(core.base.buyCryptoUrl)/?\(requestEncodedString)&signature=\(signature)"
    }
}
