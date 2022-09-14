@testable import ImmutableXCore
import XCTest

final class BuyCryptoWorkflowTests: XCTestCase {
    let usersAPI = UsersAPIMock.self
    lazy var exchangesAPI = ExchangesAPIMock()
    lazy var moonpayAPI = MoonpayAPIMock()

    override func setUp() {
        super.setUp()

        ImmutableXCore.shared = coreStub1

        usersAPI.resetMock()
        exchangesAPI.resetMock()
        moonpayAPI.resetMock()

        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.returnValue = usersAPIResponseStub1
        usersAPI.mock(usersCompanion)

        let transactionCompanion = ExchangesAPIMockTransactionIdCompanion()
        transactionCompanion.returnValue = transactionIdResponseStub1
        exchangesAPI.mock(transactionCompanion)

        let currenciesCompanion = ExchangesAPIMockCurrenciesCompanion()
        currenciesCompanion.returnValue = currenciesReponseStub1
        exchangesAPI.mock(currenciesCompanion)

        let buyCryptoComanion = MoonpayAPIMockBuyCryptoURLCompanion()
        buyCryptoComanion.returnValue = "expected url"
        moonpayAPI.mock(buyCryptoComanion)
    }

    func testBuyCryptoURLSuccess() async throws {
        let response = try await BuyCryptoWorkflow.buyCryptoURL(
            colorCodeHex: "#000000",
            signer: SignerMock(),
            base: .ropsten,
            moonpayAPI: moonpayAPI,
            exchangesAPI: exchangesAPI,
            usersAPI: usersAPI
        )

        XCTAssertEqual(response, "expected url")
    }

    func testBuyCryptoURLThrowsWhenNotRegistered() async {
        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.returnValue = GetUsersApiResponse(accounts: [])
        usersAPI.mock(usersCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await BuyCryptoWorkflow.buyCryptoURL(
                colorCodeHex: "#000000",
                signer: SignerMock(),
                base: .ropsten,
                moonpayAPI: self.moonpayAPI,
                exchangesAPI: self.exchangesAPI,
                usersAPI: self.usersAPI
            )
        }
    }

    func testBuyCryptoURLThrowsWhenTransactionIdFails() async {
        let transactionCompanion = ExchangesAPIMockTransactionIdCompanion()
        transactionCompanion.throwableError = DummyError.something
        exchangesAPI.mock(transactionCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await BuyCryptoWorkflow.buyCryptoURL(
                colorCodeHex: "#000000",
                signer: SignerMock(),
                base: .ropsten,
                moonpayAPI: self.moonpayAPI,
                exchangesAPI: self.exchangesAPI,
                usersAPI: self.usersAPI
            )
        }
    }

    func testBuyCryptoURLThrowsWhenSupportedCurrenciesFails() async {
        let currenciesCompanion = ExchangesAPIMockCurrenciesCompanion()
        currenciesCompanion.throwableError = DummyError.something
        exchangesAPI.mock(currenciesCompanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await BuyCryptoWorkflow.buyCryptoURL(
                colorCodeHex: "#000000",
                signer: SignerMock(),
                base: .ropsten,
                moonpayAPI: self.moonpayAPI,
                exchangesAPI: self.exchangesAPI,
                usersAPI: self.usersAPI
            )
        }
    }

    func testBuyCryptoURLThrowsWhenBuyCryptoFails() async {
        let buyCryptoComanion = MoonpayAPIMockBuyCryptoURLCompanion()
        buyCryptoComanion.throwableError = DummyError.something
        moonpayAPI.mock(buyCryptoComanion)

        await XCTAssertThrowsErrorAsync {
            _ = try await BuyCryptoWorkflow.buyCryptoURL(
                colorCodeHex: "#000000",
                signer: SignerMock(),
                base: .ropsten,
                moonpayAPI: self.moonpayAPI,
                exchangesAPI: self.exchangesAPI,
                usersAPI: self.usersAPI
            )
        }
    }
}
