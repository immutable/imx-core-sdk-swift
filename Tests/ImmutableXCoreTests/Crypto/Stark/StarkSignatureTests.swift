import BigInt
@testable import ImmutableXCore
import XCTest

final class StarkSignatureTests: XCTestCase {
    func testInitInvalidArguments() throws {
        // r should be in the range 1..<StarkCurve.P
        XCTAssertThrowsError(try StarkSignature(r: StarkCurve.P, s: BigInt(1)))
        XCTAssertThrowsError(try StarkSignature(r: BigInt.zero, s: BigInt(1)))

        // s should be in the range 1..<StarkCurve.N
        XCTAssertThrowsError(try StarkSignature(r: BigInt(1), s: StarkCurve.N))
        XCTAssertThrowsError(try StarkSignature(r: BigInt(1), s: BigInt.zero))

        let signature = try StarkSignature(r: BigInt(1), s: BigInt(2))
        XCTAssertEqual(signature.r, BigInt(1))
        XCTAssertEqual(signature.s, BigInt(2))
    }

    func testSerialized() throws {
        let signature = try StarkSignature(r: BigInt(1), s: BigInt(2))
        XCTAssertEqual(signature.serialized(), "0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002")
    }
}
