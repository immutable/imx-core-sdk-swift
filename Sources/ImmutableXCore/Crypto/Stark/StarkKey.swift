import BigInt
import CryptoKit
import Foundation

public enum StarkKey {
    private static let layer = "starkex"
    private static let application = "immutablex"
    private static let index = "1"
}

// MARK: - Stark Key Generation

extension StarkKey {
    /// - Parameter signature: the 's' variable of the signature
    /// - Parameter ethereumAddress: the connected wallet address
    /// - Returns: Stark key pair
    ///
    /// https://github.com/ethers-io/ethers.js/blob/3de1b815014b10d223a42e524fe9c25f9087293b/packages/bytes/src.ts/index.ts#L347
    public static func generateKeyPairFromRawSignature(_ signature: String, ethereumAddress: String) throws -> KeyPair {
        let seed = signature.dropHexPrefix[64 ..< 128]
        return try generateStarkKeyPairFromSeed(seed, path: accountPathFromAddress(ethereumAddress))
    }

    /// - Returns: StarkEx and ImmutableX account path from the ``address``
    /// https://docs.starkware.co/starkex-v4/crypto/key-derivation
    internal static func accountPathFromAddress(_ address: String) -> String {
        let layerHash = CryptoUtil.sha256(layer)
        let applicationHash = CryptoUtil.sha256(application)
        let layerInt = CryptoUtil.getIntFromBits(hex: layerHash, from: 31)
        let applicationInt = CryptoUtil.getIntFromBits(hex: applicationHash, from: 31)
        let ethAddressInt1 = CryptoUtil.getIntFromBits(hex: address[2...], from: 31)
        let ethAddressInt2 = CryptoUtil.getIntFromBits(hex: address[2...], from: 62, to: 31)
        return "m/2645'/\(layerInt)'/\(applicationInt)'/\(ethAddressInt1)'/\(ethAddressInt2)'/\(index)"
    }

    /// This function receives a key seed and produces an appropriate StarkEx key from a uniform
    /// distribution.
    /// Although it is possible to define a StarkEx key as a residue between the StarkEx EC order and a
    /// random 256bit digest value, the result would be a biased key. In order to prevent this bias, we
    /// deterministically search (by applying more hashes, AKA grinding) for a value lower than the largest
    /// 256bit multiple of StarkEx EC order.
    /// https://github.com/starkware-libs/starkware-crypto-utils/blob/dev/src/js/key_derivation.js#L119
    internal static func grindKey(keySeed: String) -> String {
        let maxAllowedVal = Constants.secpOrder - Constants.secpOrder.modulus(StarkCurve.N)

        var i = 0
        var key = CryptoUtil.hashKeyWithIndex(key: keySeed, index: i)

        // Make sure the produced key is devided by the Stark EC order, and falls within the range
        // [0, maxAllowedVal).
        while key >= maxAllowedVal {
            key = CryptoUtil.hashKeyWithIndex(key: key.asHexString(), index: i)
            i += 1
        }

        return key.modulus(StarkCurve.N).asHexString()
    }

    /// Derives the private key from the seed and path, then grinds it to find its final private key hex.
    /// https://docs.starkware.co/starkex-v4/crypto/key-derivation
    private static func generateStarkKeyPairFromSeed(_ seed: String, path: String) throws -> KeyPair {
        let keySeed = try BIP32Key.derive(seed: Data(hex: seed), path: path)
        let privateKeyHex = grindKey(keySeed: keySeed)
        let privateKey = try PrivateKey(hex: privateKeyHex)

        return KeyPair(
            private: privateKey,
            public: try PublicKey(privateKey: privateKey)
        )
    }
}
