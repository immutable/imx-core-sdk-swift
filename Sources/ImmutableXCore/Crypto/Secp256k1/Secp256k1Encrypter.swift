import Foundation
import secp256k1

/// A simple wrapper of ``secp256k1`` lib for creating public keys.
struct Secp256k1Encrypter {
    /// Recovers public key from the PrivateKey and converts it to bytes
    ///
    /// - Parameters:
    ///   - privateKey: private key bytes
    ///   - compressed: whether public key should be compressed.
    /// - Returns: If compression enabled, public key is 33 bytes size, otherwise it is 65 bytes.
    static func createPublicKey(privateKey: Data, compressed: Bool = true) -> Data {
        let context: OpaquePointer = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
        defer { secp256k1_context_destroy(context) }

        let privateKey: [UInt8] = Array(privateKey)
        var publicKey = secp256k1_pubkey()
        _ = secp256k1_ec_pubkey_create(context, &publicKey, privateKey)

        var output = Data(count: compressed ? 33 : 65)
        var outputLen: Int = output.count
        let compressedFlags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        output.withUnsafeMutableBytes { pointer in
            guard let p = pointer.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ec_pubkey_serialize(context, p, &outputLen, &publicKey, compressedFlags)
        }
        return output
    }
}
