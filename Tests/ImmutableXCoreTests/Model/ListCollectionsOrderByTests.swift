@testable import ImmutableXCore
import XCTest

final class ListCollectionsOrderByTests: XCTestCase {
    func testAsApiArgument() throws {
        XCTAssertEqual(ListCollectionsOrderBy.name.asApiArgument, .name)
        XCTAssertEqual(ListCollectionsOrderBy.address.asApiArgument, .address)
        XCTAssertEqual(ListCollectionsOrderBy.projectId.asApiArgument, .projectId)
        XCTAssertEqual(ListCollectionsOrderBy.createdAt.asApiArgument, .createdAt)
        XCTAssertEqual(ListCollectionsOrderBy.updatedAt.asApiArgument, .updatedAt)
        XCTAssertEqual(
            ListCollectionsOrderBy.allCases.map(\.rawValue),
            CollectionsAPI.OrderBy_listCollections.allCases.map(\.rawValue)
        )
    }
}
