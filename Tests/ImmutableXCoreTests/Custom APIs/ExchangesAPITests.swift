@testable import ImmutableXCore
import XCTest

final class ExchangesAPITests: XCTestCase {
    let builderMock = RequestBuilderFactoryMock()
    lazy var exchangesAPI = ExchangesAPI(requestBuilderFactory: builderMock)

    override func setUp() {
        super.setUp()
        ImmutableXCore.shared = coreStub1
    }

    func testGetTransactionIdSuccessful() async throws {
        builderMock.mock(.success(Response(response: HTTPURLResponse(), body: transactionIdResponseStub1)))

        let response = try await exchangesAPI.getTransactionId(GetTransactionIdRequest(walletAddress: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f", provider: .moonpay))
        XCTAssertEqual(response.id, 123)
    }

    func testGetTransactionIdFailure() async {
        builderMock.mock(Result<Response<GetSignedMoonpayResponse>, ErrorResponse>.failure(.error(400, nil, nil, DummyError.something)))

        await XCTAssertThrowsErrorAsync {
            _ = try await self.exchangesAPI.getTransactionId(GetTransactionIdRequest(walletAddress: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f", provider: .moonpay))
        }
    }

    func testGetCurrenciesSuccessful() async throws {
        let codes = [CurrencyCode(currencyCode: "code", enabled: true)]
        builderMock.mock(.success(Response(response: HTTPURLResponse(), body: codes)))

        let response = try await exchangesAPI.getCurrencies(address: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f")
        XCTAssertEqual(response.currencyCodes, ["code": "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f"])
    }

    func testGetCurrenciesFailure() async {
        builderMock.mock(Result<Response<[CurrencyCode]>, ErrorResponse>.failure(.error(400, nil, nil, DummyError.something)))

        await XCTAssertThrowsErrorAsync {
            _ = try await self.exchangesAPI.getCurrencies(address: "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f")
        }
    }
}
