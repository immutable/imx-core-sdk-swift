@testable import ImmutableXCore
import XCTest

final class ListAssetsOrderByTests: XCTestCase {
    func testAsApiArgument() throws {
        XCTAssertEqual(ListAssetsOrderBy.name.asApiArgument, .name)
        XCTAssertEqual(ListAssetsOrderBy.updatedAt.asApiArgument, .updatedAt)
        XCTAssertEqual(
            ListAssetsOrderBy.allCases.map(\.rawValue),
            AssetsAPI.OrderBy_listAssets.allCases.map(\.rawValue)
        )
    }
}
