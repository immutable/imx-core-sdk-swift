@testable import ImmutableXCore
import XCTest

final class ListOrdersOrderByTests: XCTestCase {
    func testAsApiArgument() throws {
        XCTAssertEqual(ListOrdersOrderBy.createdAt.asApiArgument, .createdAt)
        XCTAssertEqual(ListOrdersOrderBy.expiredAt.asApiArgument, .expiredAt)
        XCTAssertEqual(ListOrdersOrderBy.sellQuantity.asApiArgument, .sellQuantity)
        XCTAssertEqual(ListOrdersOrderBy.buyQuantity.asApiArgument, .buyQuantity)
        XCTAssertEqual(ListOrdersOrderBy.buyQuantityWithFees.asApiArgument, .buyQuantityWithFees)
        XCTAssertEqual(ListOrdersOrderBy.updatedAt.asApiArgument, .updatedAt)
        XCTAssertEqual(
            ListOrdersOrderBy.allCases.map(\.rawValue),
            OrdersAPI.OrderBy_listOrders.allCases.map(\.rawValue)
        )
    }
}
