import BigInt
import Foundation

/// Elliptic Curve generated key pair containing a ``PrivateKey`` and a ``PublicKey``
public struct KeyPair: Equatable, Codable {
    enum CodingKeys: String, CodingKey {
        case privateKey = "private_key"
        case publicKey = "public_key"
    }

    public let privateKey: PrivateKey
    public let publicKey: PublicKey

    public init(private: PrivateKey, public: PublicKey) {
        privateKey = `private`
        publicKey = `public`
    }
}
