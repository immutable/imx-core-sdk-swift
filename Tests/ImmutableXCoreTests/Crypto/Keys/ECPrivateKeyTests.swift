import BigInt
@testable import ImmutableXCore
import XCTest

final class ECPrivateKeyTests: XCTestCase {
    func testInitNumber() throws {
        let biggerNumber = StarkCurve.N + 1
        XCTAssertThrowsError(try ECPrivateKey(number: biggerNumber), "Should throw if number is not in the StarkCurve.N range") { error in
            XCTAssertTrue(error is ImmutableXError)
        }

        XCTAssertThrowsError(try ECPrivateKey(number: BigInt.zero), "Should throw if number is smaller than 1") { error in
            XCTAssertTrue(error is ImmutableXError)
        }

        let inRangeNumber = StarkCurve.N - 1
        let privateKey = try ECPrivateKey(number: inRangeNumber)
        XCTAssertEqual(privateKey.number, inRangeNumber)
        XCTAssertEqual(privateKey.asData, inRangeNumber.as256bitLongData())
    }

    func testInitHex() throws {
        XCTAssertThrowsError(try ECPrivateKey(hex: "invalid"), "Should throw if hex can't be represented as a BigInt") { error in
            XCTAssertTrue(error is ImmutableXError)
        }

        let inRangeNumber = StarkCurve.N - 1
        let privateKey = try ECPrivateKey(hex: inRangeNumber.asHexString())
        XCTAssertEqual(privateKey.number, inRangeNumber)
        XCTAssertEqual(privateKey.asData, inRangeNumber.as256bitLongData())
    }
}
