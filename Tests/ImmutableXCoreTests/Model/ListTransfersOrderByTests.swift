@testable import ImmutableXCore
import XCTest

final class ListTransfersOrderByTests: XCTestCase {
    func testAsApiArgument() throws {
        XCTAssertEqual(ListTransfersOrderBy.transactionId.asApiArgument, .transactionId)
        XCTAssertEqual(ListTransfersOrderBy.updatedAt.asApiArgument, .updatedAt)
        XCTAssertEqual(ListTransfersOrderBy.createdAt.asApiArgument, .createdAt)
        XCTAssertEqual(ListTransfersOrderBy.senderEtherKey.asApiArgument, .senderEtherKey)
        XCTAssertEqual(ListTransfersOrderBy.receiverEtherKey.asApiArgument, .receiverEtherKey)
        XCTAssertEqual(
            ListTransfersOrderBy.allCases.map(\.rawValue),
            TransfersAPI.OrderBy_listTransfers.allCases.map(\.rawValue)
        )
    }
}
