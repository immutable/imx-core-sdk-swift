import BigInt
import CryptoKit
import Foundation

struct BIP32Key {
    /// - Parameters:
    ///     - seed: seed data for derivation, e.g. personal signature
    ///     - path: hashed values in the expected format as per Starkware docs `m/purpose'/layer'/application'/ethAddress1'/ethAddress2'/index`
    /// - Returns: derived private key hex
    /// - Throws: ``ImmutableXError/invalidKeyData`` if data is not valid
    ///
    /// https://docs.starkware.co/starkex-v4/crypto/key-derivation
    /// https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki
    static func derive(seed: Data, path: String) throws -> String {
        let edge: UInt32 = 0x8000_0000
        let key = SymmetricKey(data: "Bitcoin seed".data(using: .ascii)!)
        let output = Data(HMAC<SHA512>.authenticationCode(for: seed, using: key))
        var derivedChainCode = output[32 ..< 64]
        var derivedPrivateKey = output[0 ..< 32]

        // drop the 'm' prefix
        for path in path.split(separator: "/").dropFirst() {
            let hardened = path.hasSuffix("'")
            let sanitizedPath = path.replacingOccurrences(of: "'", with: "")

            guard let index = UInt32(sanitizedPath), edge & index == 0 else { throw ImmutableXError.invalidKeyData }

            var data = Data()

            if hardened {
                data += UInt8(0).data
                data += derivedPrivateKey
            } else {
                data += try Secp256k1Encrypter.createPublicKey(privateKey: derivedPrivateKey)
            }

            let derivingIndex = CFSwapInt32BigToHost(hardened ? (edge | index) : index)
            data += derivingIndex.data

            let digest = Data(HMAC<SHA512>.authenticationCode(for: data, using: SymmetricKey(data: derivedChainCode)))
            let factor = BigInt(data: digest[0 ..< 32])

            derivedPrivateKey = (BigInt(data: derivedPrivateKey) + factor).modulus(Constants.secpOrder).as256bitLongData()
            derivedChainCode = digest[32 ..< 64]
        }

        return derivedPrivateKey.asHexString()
    }
}
