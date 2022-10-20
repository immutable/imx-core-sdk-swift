@testable import ImmutableXCore
import XCTest

final class MoonpayAPITests: XCTestCase {
    let builderMock = RequestBuilderFactoryMock()
    lazy var moonpayAPI = MoonpayAPI(requestBuilderFactory: builderMock, core: coreStub1)

    let request = GetBuyCryptoURLRequest(
        apiKey: "pk_test_nGdsu1IBkjiFzmEvN8ddf4gM9GNy5Sgz",
        colorCodeHex: "#008000",
        externalTransaction: 123,
        walletAddress: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f",
        currencies: [
            "gods_immutable": "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f",
        ]
    )

    override func setUp() {
        super.setUp()
        ImmutableX.shared = coreStub1
        builderMock.mock(.success(Response(response: HTTPURLResponse(), body: signedMoonpayResponseStub1)))
    }

    func testRequestEncodedString() async throws {
        XCTAssertEqual(try request.asURLEncodedString(), "apiKey=pk_test_nGdsu1IBkjiFzmEvN8ddf4gM9GNy5Sgz&baseCurrencyCode=usd&colorCode=%23#008000&externalTransactionId=123&walletAddress=0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f&walletAddresses=%7B%22gods_immutable%22%3A%220xa76e3eeb2f7143165618ab8feaabcd395b6fac7f%22%7D")
    }

    func testGetBuyCryptoURLSuccessful() async throws {
        let url = try await moonpayAPI.getBuyCryptoURL(request)
        XCTAssertEqual(url, "https://buy-staging.moonpay.io/?apiKey=pk_test_nGdsu1IBkjiFzmEvN8ddf4gM9GNy5Sgz&baseCurrencyCode=usd&colorCode=%23#008000&externalTransactionId=123&walletAddress=0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f&walletAddresses=%7B%22gods_immutable%22%3A%220xa76e3eeb2f7143165618ab8feaabcd395b6fac7f%22%7D&signature=signature")
    }

    func testGetBuyCryptoURLFailure() async {
        builderMock.mock(Result<Response<GetSignedMoonpayResponse>, ErrorResponse>.failure(.error(400, nil, nil, DummyError.something)))

        await XCTAssertThrowsErrorAsync {
            _ = try await self.moonpayAPI.getBuyCryptoURL(request)
        }
    }
}
