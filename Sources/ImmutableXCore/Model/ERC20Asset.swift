import AnyCodable
import Foundation

/// This is an ERC20 wrapper for the ``Token`` API model
public struct ERC20Asset: AssetModel {
    public let quantity: String

    /// The address of this ERC20 contract
    public let tokenAddress: String

    /// The quantization factor of the ERC20 token.
    /// Refer [here](https://docs.starkware.co/starkex-v4/starkex-deep-dive/starkex-specific-concepts#quantization) for more information.
    public let decimals: Int

    public init(quantity: String, tokenAddress: String, decimals: Int) {
        self.quantity = quantity
        self.tokenAddress = tokenAddress
        self.decimals = decimals
    }

    public func asSignableToken() -> SignableToken {
        SignableToken(
            data: AnyCodable(
                SignableTokenData(
                    tokenAddress: tokenAddress,
                    decimals: decimals
                )
            ),
            type: TokenType.ERC20.rawValue
        )
    }
}
