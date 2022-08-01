import Foundation

enum TransactionProvider: String, Codable {
    case moonpay
}

struct GetTransactionIdRequest: Codable {
    let walletAddress: String
    let provider: TransactionProvider

    enum CodingKeys: String, CodingKey {
        case walletAddress = "wallet_address"
        case provider
    }
}

struct GetTransactionIdResponse: Codable {
    let id: Int
    let walletAddress: String
    let provider: TransactionProvider

    enum CodingKeys: String, CodingKey {
        case walletAddress = "wallet_address"
        case provider
        case id
    }
}

struct CurrencyCode: Codable {
    let currencyCode: String
    let enabled: Bool

    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case enabled
    }
}

struct GetCurrenciesResponse: Codable {
    /// Currency Code is used as Key and the Address as value
    let currencyCodes: [String: String]

    init(currencyCodes: [String: String]) {
        self.currencyCodes = currencyCodes
    }
}

class ExchangesAPI {
    let requestBuilderFactory: RequestBuilderFactory

    init(requestBuilderFactory: RequestBuilderFactory = OpenAPIClientAPI.requestBuilderFactory) {
        self.requestBuilderFactory = requestBuilderFactory
    }

    /// Returns the transaction id for the given `request`
    func getTransactionId(_ request: GetTransactionIdRequest) async throws -> GetTransactionIdResponse {
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)
        let URLString = OpenAPIClientAPI.basePath + "/v2/exchanges"

        let requestBuilderType: RequestBuilder<GetTransactionIdResponse>.Type = requestBuilderFactory.getBuilder()
        let requestBuilder = requestBuilderType.init(
            method: "POST",
            URLString: URLString,
            parameters: parameters
        )

        return try await requestBuilder.execute()
    }

    /// Returns supported currencies for the given `address`
    func getCurrencies(address: String) async throws -> GetCurrenciesResponse {
        let URLString = OpenAPIClientAPI.basePath + "/v2/exchanges/currencies/fiat-to-crypto"

        let requestBuilderType: RequestBuilder<[CurrencyCode]>.Type = requestBuilderFactory.getBuilder()
        let requestBuilder = requestBuilderType.init(
            method: "GET",
            URLString: URLString,
            parameters: nil
        )

        let response = try await requestBuilder.execute()

        return GetCurrenciesResponse(
            currencyCodes: response.filter(\.enabled).reduce(into: [:]) { partialResult, code in
                partialResult[code.currencyCode] = address
            }
        )
    }
}
