import BigInt
@testable import ImmutableXCore
import XCTest

final class CryptoUtilTests: XCTestCase {
    func testGetIntFromBits() {
        // binary representation: 00010010001101001010011001001001101111111101100001001111111101000101001000100010
        let hex = "1234a649bfd84ff45222"
        XCTAssertEqual(34, CryptoUtil.getIntFromBits(hex: hex, from: 9)) // 000100010
        XCTAssertEqual(1_024_657, CryptoUtil.getIntFromBits(hex: hex, from: 25, to: 5)) // 11111010001010010001
    }

    func testTruncatedMessage() throws {
        let message = "0x1234a649bfd84ff45222"
        let fixed = BigInt(hexString: try CryptoUtil.fix(message: message))!
        let fixedTruncated = CryptoUtil.truncateToN(message: fixed)
        let fixedTruncatedOnly = CryptoUtil.truncateToN(message: fixed, truncOnly: true)
        XCTAssertEqual(fixedTruncated.asHexString(), message.dropHexPrefix)
        XCTAssertEqual(fixedTruncatedOnly.asHexString(), message.dropHexPrefix)
    }

    func testFixMessage() throws {
        let message = "4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20c"

        let fixed = try CryptoUtil.fix(message: message)
        XCTAssertEqual(fixed, "4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20c", "no changes since the message's character count is less than 63")

        let fixedTruncated = CryptoUtil.truncateToN(message: BigInt(hexString: fixed)!)
        let fixedTruncatedOnly = CryptoUtil.truncateToN(message: BigInt(hexString: fixed)!, truncOnly: true)
        XCTAssertEqual(fixedTruncated.asHexString(), message.dropHexPrefix)
        XCTAssertEqual(fixedTruncatedOnly.asHexString(), message.dropHexPrefix)
    }

    func testFixMessage63Characters() throws {
        let message = "0x4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20c"

        let fixed = try CryptoUtil.fix(message: message)
        XCTAssertEqual(fixed, "0x4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20c0", "formats message by appending a 0 to it")
    }

    func testFixMessageLength() throws {
        // 64 characters
        let message = "0x4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20cd"
        XCTAssertThrowsError(try CryptoUtil.fix(message: message))
    }

    func testSerializeEthSignature() {
        let ethSignaturev26 = "0x5a263fad6f17f23e7c7ea833d058f3656d3fe464baf13f6f5ccba9a2466ba2ce4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20cdcf1a"
        let ethSignaturev28 = "0x21fbf0696d5e0aa2ef41a2b4ffb623bcaf070461d61cf7251c74161f82fec3a4370854bc0a34b3ab487c1bc021cd318c734c51ae29374f2beb0e6f2dd49b4bf41c"
        XCTAssertEqual(CryptoUtil.serializeEthSignature(ethSignaturev26), ethSignaturev26)
        XCTAssertEqual(CryptoUtil.serializeEthSignature(ethSignaturev28), "0x21fbf0696d5e0aa2ef41a2b4ffb623bcaf070461d61cf7251c74161f82fec3a4370854bc0a34b3ab487c1bc021cd318c734c51ae29374f2beb0e6f2dd49b4bf401")
    }
}
