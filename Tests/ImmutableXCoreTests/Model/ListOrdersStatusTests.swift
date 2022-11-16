@testable import ImmutableXCore
import XCTest

final class ListOrdersStatusTests: XCTestCase {
    func testAsApiArgument() throws {
        XCTAssertEqual(ListOrdersStatus.active.asApiArgument, .active)
        XCTAssertEqual(ListOrdersStatus.filled.asApiArgument, .filled)
        XCTAssertEqual(ListOrdersStatus.cancelled.asApiArgument, .cancelled)
        XCTAssertEqual(ListOrdersStatus.expired.asApiArgument, .expired)
        XCTAssertEqual(ListOrdersStatus.inactive.asApiArgument, .inactive)
        XCTAssertEqual(
            ListOrdersStatus.allCases.map(\.rawValue),
            OrdersAPI.Status_listOrders.allCases.map(\.rawValue)
        )
    }
}
