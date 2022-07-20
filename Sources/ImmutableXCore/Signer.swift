import Foundation

/// This represents an L1 Ethereum wallet. Any wallet provider can be wrapped with this interface and be used with this SDK.
public protocol Signer {
    /// This is an async method so that a ``Signer`` can be designed around an asynchronous source,
    /// such as hardware wallets.
    /// - Returns: the account address.
    func getAddress() async throws -> String

    /// A signed message is prefixed with "\x19Ethereum Signed Message:\n" and the length of the
    /// message, using the hashMessage method, so that it is EIP-191 compliant. If recovering the
    /// address in Solidity, this prefix will be required to create a matching hash.
    ///
    /// Sub-classes must implement this, however they may throw if signing a message is not
    /// supported, such as in a Contract-based Wallet or Meta-Transaction-based Wallet.
    ///
    /// - Returns: signature
    func signMessage(_ message: String) async throws -> String
}

/// This represents the Immutable X Wallet on Layer 2 and will have reference to the user's Stark key pair for signing L2 transactions.
public protocol StarkSigner {
    /// This is an async method so that a ``Signer`` can be designed around an asynchronous source,
    /// such as hardware wallets.
    /// - Returns: the account address.
    func getAddress() async throws -> String

    /// Signs the `message` with the user's L2 Stark keys.
    ///
    /// When implementing this, make sure `message` is in hex format and pass it and the L2 Stark key pair to the
    /// ``StarkKey/sign(message:with:)`` function.
    ///
    /// - Returns: serialized Stark signature
    func signMessage(_ message: String) async throws -> String
}
