import BigInt
import Foundation

/// Elliptic Curve generated key pair containing a ``PrivateKey`` and a ``PublicKey``
public struct KeyPair: Equatable {
    public let privateKey: PrivateKey
    public let publicKey: PublicKey

    public init(private: PrivateKey, public: PublicKey) {
        privateKey = `private`
        publicKey = `public`
    }
}
