import BigInt
@testable import ImmutableXCore
import XCTest

final class StringExtensionsTests: XCTestCase {
    func testDropHexPrefix() throws {
        XCTAssertEqual("1376eb19ad1b0".dropHexPrefix, "1376eb19ad1b0")
        XCTAssertEqual("0x1376eb19ad1b0".dropHexPrefix, "1376eb19ad1b0")
    }

    func testAddHexPrefix() throws {
        XCTAssertEqual("1376eb19ad1b0".addHexPrefix, "0x1376eb19ad1b0")
        XCTAssertEqual("0x1376eb19ad1b0".addHexPrefix, "0x1376eb19ad1b0")
    }

    func testHexToData() throws {
        XCTAssertEqual("01".hexToData(), Data([0x1]))
        XCTAssertEqual("2b6f".hexToData(), Data([43, 111]))
        XCTAssertEqual("0x2b6f".hexToData(), Data([43, 111]))
    }
}
