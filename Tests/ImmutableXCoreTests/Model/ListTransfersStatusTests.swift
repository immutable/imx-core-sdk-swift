@testable import ImmutableXCore
import XCTest

final class ListTransfersStatusTests: XCTestCase {
    func testAsApiArgument() throws {
        XCTAssertEqual(ListTransfersStatus.success.asApiArgument, .success)
        XCTAssertEqual(ListTransfersStatus.failure.asApiArgument, .failure)
        XCTAssertEqual(
            ListTransfersStatus.allCases.map(\.rawValue),
            TransfersAPI.Status_listTransfers.allCases.map(\.rawValue)
        )
    }
}
