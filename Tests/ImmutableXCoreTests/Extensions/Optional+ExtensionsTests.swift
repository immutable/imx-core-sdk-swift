import BigInt
@testable import ImmutableXCore
import XCTest

final class OptionalExtensionsTests: XCTestCase {
    func testOrThrow() throws {
        let value1: String? = nil
        let value2: String? = "works!"
        try XCTAssertThrowsError(value1.orThrow(KeyError.invalidData))
        try XCTAssertEqual(value2.orThrow(KeyError.invalidData), "works!")
    }
}