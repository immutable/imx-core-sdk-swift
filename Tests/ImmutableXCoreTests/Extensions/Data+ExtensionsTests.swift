import BigInt
@testable import ImmutableXCore
import XCTest

final class DataExtensionsTests: XCTestCase {
    func testAsHexString() {
        XCTAssertEqual(Data([0x1]).asHexString(), "01")
        XCTAssertEqual(Data([43, 111]).asHexString(), "2b6f")
        XCTAssertEqual(BigInt(10).asHexString().hexToData().asHexString(), "0a")
        XCTAssertEqual(BigInt(2_342_356_255).asHexString().hexToData().asHexString(), "8b9d851f")
        XCTAssertEqual(BigInt(509_347_590_347).asHexString().hexToData().asHexString(), "76977b70cb")
        XCTAssertEqual(BigInt(012_345_678_980).asHexString().hexToData().asHexString(), "2dfdc1c804")
    }
}
