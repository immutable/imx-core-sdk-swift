import Foundation
import XCTest

extension XCTestCase {
    /// Expects that the async code will throw
    @discardableResult
    func XCTAssertThrowsErrorAsync(
        testName: String = #function,
        file: StaticString = #filePath,
        line: UInt = #line,
        test: () async throws -> Void
    ) async -> Error? {
        do {
            try await test()
            XCTFail("\(testName) should have failed", file: file, line: line)
            return nil
        } catch {
            // Success
            return error
        }
    }
}
