import BigInt
@testable import ImmutableXCore
import XCTest

final class StandardStarkSignerTests: XCTestCase {
    func testInitPrivateKey() throws {
        let privateKey = try ECPrivateKey(number: BigInt(10))
        let signer = try StandardStarkSigner(privateKey: privateKey)

        XCTAssertEqual(signer.pair.privateKey, privateKey)
        XCTAssertEqual(signer.pair.publicKey, try ECPublicKey(privateKey: privateKey))
    }

    func testInitPrivateKeyHex() throws {
        let privateKey = try ECPrivateKey(number: BigInt(10))
        let signer = try StandardStarkSigner(privateKeyHex: BigInt(10).asHexString())

        XCTAssertEqual(signer.pair.privateKey, privateKey)
        XCTAssertEqual(signer.pair.publicKey, try ECPublicKey(privateKey: privateKey))
    }

    func testInitPair() throws {
        let privateKey = try ECPrivateKey(number: BigInt(10))
        let publicKey = try ECPublicKey(privateKey: privateKey)
        let pair = ECKeyPair(private: privateKey, public: publicKey)
        let signer = StandardStarkSigner(pair: pair)

        XCTAssertEqual(signer.pair, pair)
    }

    func testGetAddress() async throws {
        let privateKey = try ECPrivateKey(number: BigInt(10))
        let publicKey = try ECPublicKey(privateKey: privateKey)
        let pair = ECKeyPair(private: privateKey, public: publicKey)
        let signer = StandardStarkSigner(pair: pair)

        let address = try await signer.getAddress()
        XCTAssertEqual(address, pair.publicKey.asStarkPublicKey)
    }

    func testSignMessage() async throws {
        let encodedMessage = "e2919c6f19f93d3b9e40c1eef10660bd12240a1520793a28ef21a7457037dd"
        let privateKey = try ECPrivateKey(hex: "7CEFD165C3A374AC3E05170D699BF6549E371522883B447B284A3C16FC04CCC")
        let publicKey = try ECPublicKey(privateKey: privateKey)
        let pair = ECKeyPair(private: privateKey, public: publicKey)
        let signer = StandardStarkSigner(pair: pair)

        let signature = try await signer.signMessage(encodedMessage)
        XCTAssertEqual(signature, "0x0752063caed87ef11d6e91c4a226ebfe98f190d248b857d882ae331771e6e4620364a2c46e2190bbb243309a40da051b88f0657ea9d1c2ca11510fe18a8a22ae")
    }
}
