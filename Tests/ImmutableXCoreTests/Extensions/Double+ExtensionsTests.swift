import BigInt
@testable import ImmutableXCore
import XCTest

final class DoubleExtensionsTests: XCTestCase {
    func testAsString() throws {
        let value1 = 1.2345678936543634564563457453865475467
        let value2: Double = 1
        let value3 = 0.010
        XCTAssertEqual(value1.asString, "1.23457", "Only five decimals are placed so the last ones are rounded")
        XCTAssertEqual(value2.asString, "1")
        XCTAssertEqual(value3.asString, "0.01")
    }
}
