import BigInt
import CryptoKit
import Foundation

struct CryptoUtil {
    /// Grabs the bits from given ``hex`` by applying  ``from`` and ``to`` arguments.
    /// If ``to`` is nil, this function will grab all the bits from ``from`` to the last bit.
    static func getIntFromBits(hex: String, from: Int, to: Int? = nil) -> Int {
        let bin = hex.hexaToBinary
        var bits: String

        if let to {
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

    /// Does a shift-right of delta bits, if delta is positive, where
    /// `delta = message.byteCount * 8 - StarkCurve.N.byteCount * 8 - StarkCurve.n.magnitude.leadingZeroBitCount`.
    static func truncateToN(message: BigInt, truncOnly: Bool = false) -> BigInt {
        // https://github.com/indutny/elliptic/blob/master/lib/elliptic/ec/index.js#L81
        let n = StarkCurve.N
        let nBitLength = n.byteCount * 8 - n.magnitude.leadingZeroBitCount
        let delta = message.byteCount * 8 - nBitLength
        var msg = message

        if delta > BigInt.zero {
            msg = msg >> delta
        }

        if !truncOnly, msg >= n {
            return msg - n
        } else {
            return msg
        }
    }

    /// The function ``CryptoUtil.truncateToN(message:truncOnly:)`` does a shift-right of delta bits,
    /// if delta is positive, where `delta = msgHash.byteLength() * 8 - starkEx.n.bitLength()`.
    ///
    /// This function does the opposite operation so that
    /// `truncateToN(fix(message: message)) == message`
    ///
    ///  - Throws: ``ImmutableXError/invalidSignatureMessageLength`` if message is larger than 63 characters
    static func fix(message: String) throws -> String {
        guard message.count < 64 else { throw ImmutableXError.invalidSignatureMessageLength }

        if message.count <= 62 {
            // In this case, msg should not be transformed, as the byteLength() is at most 31,
            // so delta < 0 (see truncateToN(message:truncOnly:)).
            return message
        }

        // In this case delta will be 4 so we perform a shift-left of 4 bits by adding a ZERO_BN.
        return message + "0"
    }

    static func serializeEthSignature(_ signature: String, size: Int = 64) -> String {
        func importRecoveryParam(_ v: BigInt) -> String {
            let comp = BigInt("27")
            if v >= comp {
                return (v - comp).asHexString()
            } else {
                return v.asHexString()
            }
        }

        let sig = signature.dropHexPrefix
        let from = size * 2
        let to = size * 2 + 2
        let v = BigInt(hexString: sig[from ..< to])!

        return (
            sig[0 ..< size].padLeft(length: 64) +
                sig[size ..< (size * 2)].padLeft(length: 64) +
                importRecoveryParam(v).padLeft(length: 2)
        ).addHexPrefix
    }
}
