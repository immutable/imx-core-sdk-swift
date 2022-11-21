import Foundation

/// A simple implementation of ``StarkSigner`` that holds the ``ECKeyPair`` in memory.
public struct StandardStarkSigner: StarkSigner {
    public let pair: ECKeyPair

    public init(pair: ECKeyPair) {
        self.pair = pair
    }

    public init(privateKey: ECPrivateKey) throws {
        let publicKey = try ECPublicKey(privateKey: privateKey)
        self.init(pair: ECKeyPair(private: privateKey, public: publicKey))
    }

    public init(privateKeyHex: String) throws {
        try self.init(privateKey: try ECPrivateKey(hex: privateKeyHex))
    }

    public func getAddress() async throws -> String {
        pair.publicKey.asStarkPublicKey
    }

    public func signMessage(_ message: String) async throws -> String {
        try StarkKey.sign(message: message, with: pair.privateKey)
    }
}
