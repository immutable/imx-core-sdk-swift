@testable import ImmutableXCore
import XCTest

final class IMXTimestampTests: XCTestCase {
    let returnSignature = "0xc5b53280e17b53d130eed7f00fc4270c29910fc30445af60dbb6abd82dc98f5923fb2fa2" +
        "a8940c1d6d871c984f19954d25d913857e798d0c8f3fe98b57e7bcb61c"
    let expectedSerializedSignature = "0xc5b53280e17b53d130eed7f00fc4270c29910fc30445af60dbb6abd82dc98f5923fb2fa2" +
        "a8940c1d6d871c984f19954d25d913857e798d0c8f3fe98b57e7bcb601"

    func testRequest() async throws {
        let signer = SignerMock()
        signer.signMessageReturnValue = returnSignature

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = try XCTUnwrap(dateFormatter.date(from: "2016-01-23T12:34:56Z"))

        let (timestamp, signature) = try await IMXTimestamp.request(signer: signer, date: date)

        XCTAssertEqual(signer.signMessageReceivedMessage, "1453552496")
        XCTAssertEqual(timestamp, "1453552496")
        XCTAssertEqual(signature, expectedSerializedSignature)
    }
}
