import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Zinnia_SwiftTests.allTests),
    ]
}
#endif
