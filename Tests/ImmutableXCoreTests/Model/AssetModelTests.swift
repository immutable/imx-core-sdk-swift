@testable import ImmutableXCore
import XCTest

final class AssetModelTests: XCTestCase {
    func testFormatQuantity() throws {
        XCTAssertEqual(erc721AssetStub1.quantity, "1")
        try XCTAssertEqual(erc721AssetStub1.formatQuantity(), "1")

        XCTAssertEqual(erc20AssetStub1.quantity, "0.0101")
        try XCTAssertEqual(erc20AssetStub1.formatQuantity(), "10100")

        XCTAssertEqual(ethAssetStub1.quantity, "0.0101")
        try XCTAssertEqual(ethAssetStub1.formatQuantity(), "10100000000000000")

        XCTAssertThrowsError(try ETHAsset(quantity: "invalid").formatQuantity())

        XCTAssertThrowsError(try DummyAsset(quantity: "1").formatQuantity())
    }
}

struct DummyAsset: AssetModel {
    let quantity: String

    func asSignableToken() -> SignableToken {
        fatalError("Not needed for testFormatQuantity")
    }
}
