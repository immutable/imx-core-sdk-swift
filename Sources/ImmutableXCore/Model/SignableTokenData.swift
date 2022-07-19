import Foundation

public struct SignableTokenData: Codable {
    let tokenAddress: String?
    let tokenId: String?
    let decimals: Int?

    public init(tokenAddress: String? = nil, tokenId: String? = nil, decimals: Int? = nil) {
        self.tokenAddress = tokenAddress
        self.tokenId = tokenId
        self.decimals = decimals
    }

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case tokenId = "token_id"
        case decimals
    }
}
