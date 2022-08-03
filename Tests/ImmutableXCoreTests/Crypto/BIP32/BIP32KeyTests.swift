import BigInt
@testable import ImmutableXCore
import XCTest

final class BIP32KeyTests: XCTestCase {
    let seed = Data(hex: "4c4a250231bcac7beb165aec4c9b049b4ba40ad8dd287dc79b92b1ffcf20cdcf")

    func testDeriveThrowsForInvalidPath() throws {
        let path = "m/purpose'/layer'/application'/ethAddress1'/ethAddress2'/1"
        XCTAssertThrowsError(try BIP32Key.derive(seed: seed, path: path), "unhashed/formatted path") { error in
            XCTAssertTrue(error is ImmutableXCoreError)
        }
    }

    func testDerive() throws {
        let path = "m/2645'/579218131'/211006541'/1534045311'/1431804530'/1"
        XCTAssertEqual(
            try BIP32Key.derive(seed: seed, path: path),
            "57384e99059bb1c0e51d70f0fca22d18d7191398dd39d6b9b4e0521174b2377a"
        )
    }
}
