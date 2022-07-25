import Foundation

/// A simple implementation of ``StarkSigner`` that holds the ``KeyPair`` in memory.
public struct StandardStarkSigner: StarkSigner {
    public let pair: KeyPair

    public init(pair: KeyPair) {
        self.pair = pair
    }

    public init(privateKey: PrivateKey) throws {
        let publicKey = try PublicKey(privateKey: privateKey)
        self.init(pair: KeyPair(private: privateKey, public: publicKey))
    }

    public init(privateKeyHex: String) throws {
        try self.init(privateKey: try PrivateKey(hex: privateKeyHex))
    }

    public func getAddress() async throws -> String {
        pair.publicKey.asStarkPublicKey
    }

    public func signMessage(_ message: String) async throws -> String {
        try StarkKey.sign(message: message, with: pair.privateKey)
    }
}
