import XCTest
@testable import DemoFramework

class DemoTests: XCTestCase {

    func testDemo() throws {
        let actual = Demo.demo()
        XCTAssertTrue(actual.hasPrefix("OK"))
    }
}