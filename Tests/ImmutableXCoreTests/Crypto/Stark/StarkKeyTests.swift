import BigInt
@testable import ImmutableXCore
import XCTest

final class StarkKeyTests: XCTestCase {
    func testGenerateKeyPairFromRawSignature() throws {
        let signature = "0x5a263fad6f17f23e7c7ea833d058f3656d3fe464baf13f6f5ccba9a2466ba2ce4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20cdcf1b"
        let address = "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f"
        let pair = try StarkKey.generateKeyPairFromRawSignature(signature, ethereumAddress: address)

        XCTAssertEqual(pair.publicKey.asStarkKey, "0x02a4c7332c55d6c1c510d24272d1db82878f2302f05b53bcc38695ed5f78fffd")
    }

    func testGetKeyFromRawSignatureWithExtraGrinding() throws {
        let signature = "0x6d1550458c7a9a1257d73adbcf0fabc12f4497e970d9fa62dd88bf7d9e12719148c96225c1402d8707fd061b1aae2222bdf13571dfc82b3aa9974039f247f2b81b"
        let address = "0xa4864d977b944315389d1765ffa7e66F74ee8cd7"
        let pair = try StarkKey.generateKeyPairFromRawSignature(signature, ethereumAddress: address)
        XCTAssertEqual(pair.publicKey.asStarkKey, "0x035919acd61e97b3ecdc75ff8beed8d1803f7ea3cad2937926ae59cc3f8070d4")
    }

    func testGetPrivateKeySignature() throws {
        let signature = "0x21fbf0696d5e0aa2ef41a2b4ffb623bcaf070461d61cf7251c74161f82fec3a4370854bc0a34b3ab487c1bc021cd318c734c51ae29374f2beb0e6f2dd49b4bf41c"

        let result = StarkKey.grindKey(keySeed: signature.dropHexPrefix[0 ..< 64])
        XCTAssertEqual(result, "766f11e90cd7c7b43085b56da35c781f8c067ac0d578eabdceebc4886435bda")
    }

    func testAccountPathFromAddress() {
        let path = StarkKey.accountPathFromAddress("0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f")
        XCTAssertEqual(path, "m/2645'/579218131'/211006541'/1534045311'/1431804530'/1")
    }

    func testKeyGrinding() {
        let seed = "86F3E7293141F20A8BAFF320E8EE4ACCB9D4A4BF2B4D295E8CEE784DB46E0519"
        XCTAssertEqual(
            StarkKey.grindKey(keySeed: seed), "5c8c8683596c732541a59e03007b2d30dbbbb873556fe65b5fb63c16688f941"
        )
    }
}
