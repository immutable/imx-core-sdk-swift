import BigInt
import Foundation

struct Constants {
    static let starkMessage = "Only sign this request if you’ve initiated an action with Immutable X."
    static let secpOrder = BigInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16)!
    static let starkPrivateKeyLength = 32
    static let ERC721Amount = "1"
    static let ETHDecimals = 18
}
