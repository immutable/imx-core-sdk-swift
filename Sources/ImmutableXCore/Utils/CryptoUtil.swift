import BigInt
import CryptoKit
import Foundation

struct CryptoUtil {
    /// Grabs the bits from given ``hex`` by applying  ``from`` and ``to`` arguments.
    /// If ``to`` is nil, this function will grab all the bits from ``from`` to the last bit.
    static func getIntFromBits(hex: String, from: Int, to: Int? = nil) -> Int {
        let bin = hex.hexaToBinary
        var bits: String

        if let to = to {
            let start = bin.count - from
            let end = bin.count - to
            bits = bin[start ..< end]
        } else {
            bits = String(bin.suffix(from))
        }

        return Int(bits, radix: 2) ?? 0
    }

    /// Combines the given ``key`` and ``index`` and SHA-256 hash them
    static func hashKeyWithIndex(key: String, index: Int) -> BigInt {
        let hexString = key.dropHexPrefix + index.asHexString.sanitizeBytes(byteSize: 2)
        return BigInt(data: Data(SHA256.hash(data: Data(hex: hexString))))
    }

    static func sha256(_ input: String) -> String {
        guard let data = input.data(using: .utf8) else { return "" }
        return Data(SHA256.hash(data: data)).asHexString()
    }
}
