import BigInt
@testable import ImmutableXCore
import XCTest

final class ArrayExtensionsTests: XCTestCase {
    func testAsHexString() throws {
        let hex = "3035919acd61e97b3ecdc75ff8beed8d1803f7ea3cad2937926ae59cc3f8070d4"
        XCTAssertEqual(
            hex.sanitizeBytes().hexaToBytes.asHexString(byteLength: 32),
            "0x035919acd61e97b3ecdc75ff8beed8d1803f7ea3cad2937926ae59cc3f8070d4"
        )
        XCTAssertEqual(
            hex.sanitizeBytes(byteSize: 2).hexaToBytes.asHexString(byteLength: 64), "0x0" + hex
        )
    }
}
