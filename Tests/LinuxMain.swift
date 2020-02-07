import XCTest

import EventEmitterTests

var tests = [XCTestCaseEntry]()
tests += EventEmitterTests.allTests()
XCTMain(tests)
