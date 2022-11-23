import BigInt
@testable import ImmutableXCore
import XCTest

final class StarkCurveTests: XCTestCase {
    func testModN() throws {
        XCTAssertEqual(StarkCurve.modN(18926), BigInt(18926).modulus(StarkCurve.N))
    }

    func testModP() throws {
        XCTAssertEqual(StarkCurve.modP(18926), BigInt(18926).modulus(StarkCurve.P))
    }

    func testModInverseN() throws {
        let value1 = BigInt(123_123)
        let value2 = BigInt(543_543)
        XCTAssertEqual(StarkCurve.modInverseN(value1, value2), StarkCurve.divide(value1, by: value2, mod: StarkCurve.N))
    }

    func testModInverseP() throws {
        let value1 = BigInt(123_123)
        let value2 = BigInt(543_543)
        XCTAssertEqual(StarkCurve.modInverseP(value1, value2), StarkCurve.divide(value1, by: value2, mod: StarkCurve.P))
    }

    func testAdditionReturnsNilWhenXsAreEqualButYsDifferent() throws {
        let p1 = ECCurvePoint(x: BigInt(1), y: BigInt(2))
        let p2 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        XCTAssertNil(StarkCurve.addition(p1, p2))
    }

    func testAdditionReturnsP2IfP1IsNil() throws {
        let p2 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        XCTAssertEqual(StarkCurve.addition(nil, p2), p2)
    }

    func testAdditionReturnsP1IfP2IsNil() throws {
        let p1 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        XCTAssertEqual(StarkCurve.addition(p1, nil), p1)
    }

    func testAdditionDoublesPointIfP1AndP2AreEqual() throws {
        let p1 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        let p2 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        XCTAssertEqual(
            StarkCurve.addition(p1, p2),
            ECCurvePoint(
                x: BigInt("402055865407347912633035864788341122847011912814621855552565784015096891163"),
                y: BigInt("2144297948839188867376191278871152655184063535011316562947017514747183419543")
            )
        )
    }

    func testAdditionAddsPointIfP1AndP2AreDifferent() throws {
        let p1 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        let p2 = ECCurvePoint(x: BigInt(2), y: BigInt(4))
        XCTAssertEqual(
            StarkCurve.addition(p1, p2),
            ECCurvePoint(
                x: BigInt("3618502788666131213697322783095070105623107215331596699973092056135872020479"),
                y: BigInt.zero
            )
        )
    }

    func testMultiply() throws {
        let p1 = ECCurvePoint(x: BigInt(1), y: BigInt(3))
        XCTAssertEqual(
            StarkCurve.multiply(p1, by: BigInt(5)),
            ECCurvePoint(
                x: BigInt("2425062519850715417264908027841285451121663001259327672961971078160192455827"),
                y: BigInt("1911311605951940726530513999887245307038092470678989998898051714701747274728")
            )
        )
    }

    func testMultiplyG() throws {
        XCTAssertEqual(
            StarkCurve.multiplyG(by: BigInt(5)),
            StarkCurve.multiply(StarkCurve.G, by: BigInt(5))
        )
    }

    func testGeneratePrivateKey() throws {
        let pair1 = StarkCurve.generatePrivateKey()
        let pair2 = StarkCurve.generatePrivateKey()

        XCTAssertNotEqual(pair1, pair2)
    }
}
