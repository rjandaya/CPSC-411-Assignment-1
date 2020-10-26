import XCTest

import RestfulServerTests

var tests = [XCTestCaseEntry]()
tests += RestfulServerTests.allTests()
XCTMain(tests)
