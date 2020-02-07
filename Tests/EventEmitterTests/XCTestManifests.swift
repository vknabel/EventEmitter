import XCTest
@testable import EventEmitter

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EventEmitterTests.allTests),
    ]
}
#endif
