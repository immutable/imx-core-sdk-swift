@testable import ImmutableXCore
import XCTest

final class ImmutableXBaseTests: XCTestCase {
    func testPublicApiUrl() async throws {
        XCTAssertEqual(ImmutableXBase.production.publicApiUrl, "https://api.x.immutable.com")
        XCTAssertEqual(ImmutableXBase.sandbox.publicApiUrl, "https://api.sandbox.x.immutable.com")
    }

    func testMoonpayApiKey() async throws {
        XCTAssertEqual(ImmutableXBase.production.moonpayApiKey, "pk_live_lgGxv3WyWjnWff44ch4gmolN0953")
        XCTAssertEqual(ImmutableXBase.sandbox.moonpayApiKey, "pk_test_nGdsu1IBkjiFzmEvN8ddf4gM9GNy5Sgz")
    }

    func testBuyCryptoUrl() async throws {
        XCTAssertEqual(ImmutableXBase.production.buyCryptoUrl, "https://buy.moonpay.io")
        XCTAssertEqual(ImmutableXBase.sandbox.buyCryptoUrl, "https://buy-staging.moonpay.io")
    }
}
