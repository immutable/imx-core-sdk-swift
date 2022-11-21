import BigInt
@testable import ImmutableXCore
import XCTest

final class ECPublicKeyTests: XCTestCase {
    private let privateKeyNumber = StarkCurve.N - 1

    private let expectedEvenCurve = ECCurvePoint(
        x: BigInt("874739451078007766457464989774322083649278607533249481151382481072868806602"),
        y: BigInt("3465835996594612382828747225282121752581686814550857218630150674910346159074")
    )

    private let oddCurve = ECCurvePoint(
        x: BigInt("874739451078007766457464989774322083649278607533249481151382481072868806602"),
        y: BigInt("3465835996594612382828747225282121752581686814550857218630150674910346159073")
    )

    func testInitPrivateKey() throws {
        let privateKey = try ECPrivateKey(number: privateKeyNumber)
        let publicKey = try ECPublicKey(privateKey: privateKey)

        XCTAssertEqual(publicKey.point, expectedEvenCurve)
        XCTAssertEqual(publicKey.number, BigInt(data: Data([0x02]) + expectedEvenCurve.x.as256bitLongData()))
        XCTAssertEqual(publicKey, try ECPublicKey(privateKey: privateKey))
    }

    func testInitCurvePoint() throws {
        let publicKey = try ECPublicKey(point: oddCurve)
        XCTAssertEqual(publicKey.point, oddCurve)
        XCTAssertEqual(publicKey.number, BigInt(data: Data([0x03]) + oddCurve.x.as256bitLongData()))
    }
}
