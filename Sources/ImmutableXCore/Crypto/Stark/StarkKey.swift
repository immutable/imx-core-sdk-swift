import BigInt
import CryptoKit
import Foundation

public enum StarkKey {
    private static let layer = "starkex"
    private static let application = "immutablex"
    private static let index = "1"
}

// MARK: - Stark Key Generation

public extension StarkKey {
    /// Generate a Stark key pair from a L1 wallet.
    /// - Parameter signer: the signer that the key pair will be derived from
    /// - Returns: Stark key pair as ``KeyPair``
    /// - Throws: ``ImmutableXError``
    static func generateKeyPair(from signer: Signer) async throws -> KeyPair {
        let address = try await signer.getAddress()
        let signature = try await signer.signMessage(Constants.starkMessage)
        return try generateKeyPairFromRawSignature(signature, ethereumAddress: address)
    }

    /// Generate a Stark key pair from a L1 wallet.
    /// - Parameter signer: the signer that the key pair will be derived from
    /// - Returns: a Stark key pair as ``KeyPair`` if successful or an ``ImmutableXError``
    ///  error through the `onCompletion` callback
    ///
    /// - Note: `onCompletion` is executed on the Main Thread
    static func generateKeyPair(from signer: Signer, onCompletion: @escaping (Result<KeyPair, ImmutableXError>) -> Void) {
        Task { @MainActor in
            do {
                let pair = try await generateKeyPair(from: signer)
                onCompletion(.success(pair))
            } catch {
                onCompletion(.failure(error.asImmutableXError))
            }
        }
    }

    /// Generate a Stark key pair from a L1 wallet.
    /// - Parameter signature: the 's' variable of the signature
    /// - Parameter ethereumAddress: the connected wallet address
    /// - Returns: Stark key pair as ``KeyPair``
    /// - Throws: ``ImmutableXError``
    static func generateKeyPairFromRawSignature(_ signature: String, ethereumAddress: String) throws -> KeyPair {
        // https://github.com/ethers-io/ethers.js/blob/3de1b815014b10d223a42e524fe9c25f9087293b/packages/bytes/src.ts/index.ts#L347
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

// MARK: - Stark Signature

public extension StarkKey {
    /// Signs the given `message` with the given `privateKeyHex`.
    ///
    /// - Parameters:
    ///     - message: must be in hex format and 64 characters or less in length (including 0x prefix)
    ///     - privateKeyHex: key to be used in the signature. Must be in hex format (including 0x prefix)
    ///
    /// - Returns: Stark signature
    static func sign(message: String, withPrivateKeyHex privateKeyHex: String) throws -> String {
        try sign(message: message, with: try PrivateKey(hex: privateKeyHex))
    }

    /// Signs the given `message` with the given `privateKey`.
    ///
    /// - Parameters:
    ///     - message: must be in hex format and 64 characters or less in length (including 0x prefix)
    ///     - privateKey: key to be used in the signature
    ///
    /// - Returns: Stark signature
    static func sign(message: String, with privateKey: PrivateKey) throws -> String {
        let fixedMessage = try CryptoUtil.fix(message: message)
        let message = Message(hashedHex: fixedMessage)
        let starkSignature = try sign(message, using: privateKey)
        return starkSignature.serialized()
    }

    // Base implementation from https://github.com/Sajjon/EllipticCurveKit/blob/main/Sources/EllipticCurveKit/EllipticCurve/Signing/CommonSigning/ECDSA.swift#L32
    // and https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/crypto/signers/ECDSASigner.java#L93
    internal static func sign(_ message: Message, using privateKey: PrivateKey) throws -> StarkSignature {
        let messageNumber = message.asBigInt
        var z = CryptoUtil.truncateToN(message: messageNumber)
        let sanitised = z.asHexString().sanitizeBytes()
        z = BigInt(hexString: sanitised)!

        var r: BigInt = 0
        var s: BigInt = 0
        let d = privateKey.number

        repeat {
            var k = try generateK(from: privateKey, for: Message(hashedHex: sanitised))
            k = StarkCurve.modN(k)

            let point = StarkCurve.multiplyG(by: k)
            r = StarkCurve.modN(point.x)

            guard !r.isZero else { continue }

            let kInverse = StarkCurve.modInverseN(1, k)
            s = StarkCurve.modN(kInverse * (z + r * d))
        } while s.isZero

        return try StarkSignature(r: r, s: s)
    }

    // https://datatracker.ietf.org/doc/html/rfc6979#section-3.2
    // Base implementation from https://github.com/Sajjon/EllipticCurveKit/blob/main/Sources/EllipticCurveKit/EllipticCurve/Signing/SignatureNonce%2BRFC-6979.swift#L29
    // and https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/crypto/signers/HMacDSAKCalculator.java#L104
    internal static func generateK(from privateKey: PrivateKey, for message: Message) throws -> BigInt {
        let byteCount = message.hashedData.count
        let d = privateKey.number.as256bitLongData()
        let nByteCount = StarkCurve.N.magnitude.bitWidth.byteCountFromBitCount

        var V = Data([UInt8](repeating: 0x01, count: byteCount))
        var K = Data([UInt8](repeating: 0x00, count: byteCount))

        func HMAC_K(_ data: Data) -> Data {
            Data(HMAC<SHA256>.authenticationCode(for: data, using: SymmetricKey(data: K)))
        }

        K = HMAC_K(V + Data([0x00]) + d + message.hashedData)
        V = HMAC_K(V)
        K = HMAC_K(V + Data([0x01]) + d + message.hashedData)
        V = HMAC_K(V)

        var T: Data
        var k = BigInt.zero

        repeat {
            T = Data()

            while T.count < nByteCount {
                V = HMAC_K(V)
                T += V
            }

            k = CryptoUtil.truncateToN(message: BigInt(T.asHexString(), radix: 16)!, truncOnly: true)

            K = HMAC_K(V + [0])
            V = HMAC_K(V)

            if k <= 1 || k >= StarkCurve.N - BigInt(1) {
                continue
            }

            let kPoint = StarkCurve.multiplyG(by: k)

            if kPoint.x.modulus(StarkCurve.N) == BigInt.zero {
                continue
            }

            break
        } while true

        return k
    }
}
