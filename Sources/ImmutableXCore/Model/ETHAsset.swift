import AnyCodable
import Foundation

/// This is an ETH wrapper for the ``Token`` API model
public struct ETHAsset: AssetModel {
    public let quantity: String

    public init(quantity: String) {
        self.quantity = quantity
    }

    public func asSignableToken() -> SignableToken {
        SignableToken(
            data: AnyCodable(
                SignableTokenData(
                    decimals: Constants.ETHDecimals
                )
            ),
            type: TokenType.ETH.rawValue
        )
    }
}
