import XCTest

class DemoTests: XCTestCase {

    func testDemo() throws {
        let x = "OK"
        XCTAssertEqual(x, "OK")
    }
}