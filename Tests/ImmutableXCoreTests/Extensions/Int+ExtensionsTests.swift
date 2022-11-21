import BigInt
@testable import ImmutableXCore
import XCTest

final class IntExtensionsTests: XCTestCase {
    func testByteCountFromBitCount() throws {
        XCTAssertEqual(BigInt(123_123_123).bitWidth.byteCountFromBitCount, 4)
        XCTAssertEqual(
            BigInt("402055865407347912633035864788341122847011912814621855552565784015096891163")
                .bitWidth.byteCountFromBitCount,
            32
        )
    }
}
