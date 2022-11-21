import BigInt
import Foundation

/// Elliptic Curve generated key pair containing a ``ECPrivateKey`` and a ``ECPublicKey``
public struct ECKeyPair: Equatable, Codable {
    enum CodingKeys: String, CodingKey {
        case privateKey = "private_key"
        case publicKey = "public_key"
    }

    public let privateKey: ECPrivateKey
    public let publicKey: ECPublicKey

    public init(private: ECPrivateKey, public: ECPublicKey) {
        privateKey = `private`
        publicKey = `public`
    }
}
