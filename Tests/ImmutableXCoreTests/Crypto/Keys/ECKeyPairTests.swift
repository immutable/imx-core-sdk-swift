import BigInt
@testable import ImmutableXCore
import XCTest

final class ECKeyPairTests: XCTestCase {
    func testInitPrivateKey() throws {
        let privateKey = try ECPrivateKey(number: StarkCurve.N - 1)
        let publicKey = try ECPublicKey(privateKey: privateKey)

        let pair = ECKeyPair(private: privateKey, public: publicKey)

        XCTAssertEqual(pair.privateKey, privateKey)
        XCTAssertEqual(pair.publicKey, publicKey)
    }
}
