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
}
