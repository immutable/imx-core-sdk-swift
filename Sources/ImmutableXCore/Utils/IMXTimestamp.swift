import Foundation

struct IMXTimestamp {
    /// Generic helper for API's that require a signed timestamp as a parameter.
    ///
    /// https://docs.x.immutable.com/docs/generate-imx-signature/
    static func request(
        signer: Signer,
        date: Date = Date()
    ) async throws -> (timestamp: String, signature: String) {
        let stringSeconds = "\(date.timeIntervalSince1970)"
        let seconds = String(stringSeconds.prefix(while: { $0 != "." }))
        let signature = try await signer.signMessage(seconds)
        return (timestamp: seconds, signature: CryptoUtil.serializeEthSignature(signature))
    }
}
