import XCTest
@testable import EventEmitter

final class EventEmitterTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var token: String?
        var tokenDidChange = EventEffect<String?>.eventEffect()
        let tokenUpdates = tokenDidChange.watch { newToken in
            token = newToken
        }
        XCTAssertEqual(token, nil)
        tokenDidChange.request("Hello World")
        XCTAssertEqual(token, "Hello World")
        tokenUpdates.finish()
        tokenDidChange.request("Hello.")
        XCTAssertEqual(token, "Hello World")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
