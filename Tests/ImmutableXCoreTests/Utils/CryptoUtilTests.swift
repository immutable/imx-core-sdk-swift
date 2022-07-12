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
}
