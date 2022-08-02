import Foundation
import XCTest

extension XCTestCase {
    /// Expects that the async code will throw
    @discardableResult
    func XCTAssertThrowsErrorAsync(testName: String = #function, file: StaticString = #filePath, line: UInt = #line, timeout: TimeInterval = 20, test: @escaping () async throws -> Void) -> Error? {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: testName)

        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        XCTAssertEqual(XCTWaiter().wait(for: [expectation], timeout: timeout), .completed, file: file, line: line)

        if thrownError == nil {
            XCTFail("\(testName) should have failed", file: file, line: line)
        }

        return thrownError
    }
}
