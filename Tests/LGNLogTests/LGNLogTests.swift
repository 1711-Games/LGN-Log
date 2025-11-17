import XCTest
@testable import LGNLog

final class LGNLogTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(LGN_Log().text, "Hello, World!")
    }

    func testConcurrency() async throws {
        LoggingSystem.bootstrap(LGNLogger.init)

        LGNLogger.logLevel = .error
        LGNLogger.hideTimezone = true
        LGNLogger.hideLabel = true
        LGNLogger.requestIDKey = "someOtherRequestID"
    }
}
