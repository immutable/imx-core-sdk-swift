import BigInt
@testable import ImmutableXCore
import XCTest

final class BigIntExtensionsTests: XCTestCase {
    func testIsEven() throws {
        XCTAssertEqual(BigInt(1).isEven, false)
        XCTAssertEqual(BigInt(2).isEven, true)
        XCTAssertEqual(BigInt(14234).isEven, true)
        XCTAssertEqual(BigInt(23423).isEven, false)
        XCTAssertEqual(BigInt("402055865407347912633035864788341122847011912814621855552565784015096891163").isEven, false)
    }

    func testHexStringInit() {
        XCTAssertEqual(BigInt(hexString: "1376eb19ad1b0"), BigInt(342_423_542_354_352))
        XCTAssertEqual(BigInt(hexString: "0x1376eb19ad1b0"), BigInt(342_423_542_354_352))
        XCTAssertEqual(
            BigInt(hexString: "7cefd165c3a374ac3e05170d699bf6549e371522883b447b284a3c16fc04ccc"), BigInt("3531907180084456080948977704976059596947036969275297986324692124860996930764")
        )
    }

    func testAsString() {
        XCTAssertEqual(BigInt(342_423_542_354_352).asString(uppercased: false, radix: 16), "1376eb19ad1b0")
        XCTAssertEqual(BigInt(342_423_542_354_352).asString(uppercased: true, radix: 16), "1376EB19AD1B0")
        XCTAssertEqual(BigInt(342_423_542_354_352).asString(radix: 10), "342423542354352")
        XCTAssertEqual(BigInt(hexString: "7cefd165c3a374ac3e05170d699bf6549e371522883b447b284a3c16fc04ccc")!.asString(radix: 10), "3531907180084456080948977704976059596947036969275297986324692124860996930764")
    }

    func testAsStringLength64() {
        XCTAssertEqual(BigInt(342_423_542_354_352).asHexStringLength64(), "0000000000000000000000000000000000000000000000000001376eb19ad1b0")
        XCTAssertEqual(BigInt(342_423_542_354_352).asHexStringLength64(uppercased: true), "0000000000000000000000000000000000000000000000000001376EB19AD1B0")
    }

    func testAs256bitLongData() {
        XCTAssertEqual(BigInt(342_423_542_354_352).as256bitLongData(), "0000000000000000000000000000000000000000000000000001376eb19ad1b0".hexToData())
    }
}
