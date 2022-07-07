import BigInt
@testable import ImmutableXCore
import XCTest

final class PublicKeyTests: XCTestCase {
    private let privateKeyNumber = StarkCurve.N - 1

    private let expectedEvenCurve = CurvePoint(
        x: BigInt("874739451078007766457464989774322083649278607533249481151382481072868806602"),
        y: BigInt("3465835996594612382828747225282121752581686814550857218630150674910346159074")
    )

    private let oddCurve = CurvePoint(
        x: BigInt("874739451078007766457464989774322083649278607533249481151382481072868806602"),
        y: BigInt("3465835996594612382828747225282121752581686814550857218630150674910346159073")
    )

    func testInitPrivateKey() throws {
        let privateKey = try PrivateKey(number: privateKeyNumber)
        let publicKey = try PublicKey(privateKey: privateKey)

        XCTAssertEqual(publicKey.point, expectedEvenCurve)
        XCTAssertEqual(publicKey.compressedData, Data([0x02]) + expectedEvenCurve.x.as256bitLongData())
        XCTAssertEqual(publicKey, try PublicKey(privateKey: privateKey))
    }

    func testInitCurvePoint() throws {
        let publicKey = try PublicKey(point: oddCurve)
        XCTAssertEqual(publicKey.point, oddCurve)
        XCTAssertEqual(publicKey.compressedData, Data([0x03]) + oddCurve.x.as256bitLongData())
    }
}
