import AnyCodable
import Foundation

/// This is an ERC721 wrapper for the ``Token`` API model
public struct ERC721Asset: AssetModel {
    public let quantity = Constants.ERC721Amount

    /// The address of this ERC721 contract
    public let tokenAddress: String

    /// The token id of this ERC721 asset
    public let tokenId: String

    public init(tokenAddress: String, tokenId: String) {
        self.tokenAddress = tokenAddress
        self.tokenId = tokenId
    }

    public func asSignableToken() -> SignableToken {
        SignableToken(
            data: AnyCodable(
                SignableTokenData(
                    tokenAddress: tokenAddress,
                    tokenId: tokenId
                )
            ),
            type: TokenType.ERC721.rawValue
        )
    }
}
