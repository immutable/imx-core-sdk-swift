import BigInt
@testable import ImmutableXCore
import XCTest

final class PrivateKeyTests: XCTestCase {
    func testInitNumber() throws {
        let biggerNumber = StarkCurve.N + 1
        XCTAssertThrowsError(try PrivateKey(number: biggerNumber), "Should throw if number is not in the StarkCurve.N range") { error in
            XCTAssertTrue(error is ImmutableXCoreError)
        }

        XCTAssertThrowsError(try PrivateKey(number: BigInt.zero), "Should throw if number is smaller than 1") { error in
            XCTAssertTrue(error is ImmutableXCoreError)
        }

        let inRangeNumber = StarkCurve.N - 1
        let privateKey = try PrivateKey(number: inRangeNumber)
        XCTAssertEqual(privateKey.number, inRangeNumber)
        XCTAssertEqual(privateKey.asData, inRangeNumber.as256bitLongData())
    }

    func testInitHex() throws {
        XCTAssertThrowsError(try PrivateKey(hex: "invalid"), "Should throw if hex can't be represented as a BigInt") { error in
            XCTAssertTrue(error is ImmutableXCoreError)
        }

        let inRangeNumber = StarkCurve.N - 1
        let privateKey = try PrivateKey(hex: inRangeNumber.asHexString())
        XCTAssertEqual(privateKey.number, inRangeNumber)
        XCTAssertEqual(privateKey.asData, inRangeNumber.as256bitLongData())
    }
}
