import BigInt
import Foundation

/// This is a wrapper for the ``SignableToken`` API model that gives structured classes for the 3 types of
/// assets (``ERC20Asset``, ``ERC721Asset``, ``ETHAsset``) used in the workflow functions.
public protocol AssetModel {
    /// The amount of the asset to be transferred/sold/bought
    var quantity: String { get }

    /// This converts this convenience model into the ``SignableToken`` API model which will be used for the client calls.
    func asSignableToken() -> SignableToken
}

internal extension AssetModel {
    /// Helper function to calculate the quantity field
    func formatQuantity() throws -> String {
        guard let decimalQuantity = Decimal(string: quantity) else {
            throw ImmutableXError.invalidRequest(reason: "Invalid asset quantity")
        }

        let decimals: Int

        if let asset = self as? ERC20Asset {
            decimals = asset.decimals
        } else if self is ERC721Asset {
            decimals = 0
        } else if self is ETHAsset {
            decimals = Constants.ETHDecimals
        } else {
            throw ImmutableXError.invalidRequest(reason: "Unimplemented asset")
        }

        return "\(pow(10, decimals) * decimalQuantity)"
    }
}
