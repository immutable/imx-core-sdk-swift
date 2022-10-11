import Foundation
import secp256k1Swift

/// A simple wrapper of ``secp256k1`` lib for creating public keys.
struct Secp256k1Encrypter {
    /// Recovers public key from the PrivateKey and converts it to bytes
    ///
    /// - Parameters:
    ///   - privateKey: private key bytes
    ///   - compressed: whether public key should be compressed.
    /// - Returns: If compression enabled, public key is 33 bytes size, otherwise it is 65 bytes.
    static func createPublicKey(privateKey: Data, compressed: Bool = true) throws -> Data {
        try secp256k1.Signing.PrivateKey(rawRepresentation: privateKey).publicKey.rawRepresentation
    }
}
