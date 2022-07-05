@testable import ImmutableXCore
import XCTest

final class ImmutableXCoreTests: XCTestCase {
    func testSdkVersion() {
        XCTAssertEqual(ImmutableXCore.sdkVersion, "0.1.0")
    }
}
