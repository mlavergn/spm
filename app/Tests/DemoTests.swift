import XCTest
@testable import DemoFmwk

class DemoTests: XCTestCase {

    func testDemo() throws {
        let actual = Demo.demo()
        XCTAssertTrue(actual.hasPrefix("OK"))
    }
}