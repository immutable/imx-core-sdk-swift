import BigInt
@testable import ImmutableXCore
import XCTest

final class KeyPairTests: XCTestCase {
    func testInitPrivateKey() throws {
        let privateKey = try PrivateKey(number: StarkCurve.N - 1)
        let publicKey = try PublicKey(privateKey: privateKey)

        let pair = KeyPair(private: privateKey, public: publicKey)

        XCTAssertEqual(pair.privateKey, privateKey)
        XCTAssertEqual(pair.publicKey, publicKey)
    }
}
