import XCTest
@testable import DaysToGoKit

class DaysToGoEventTests: XCTestCase {

	var sut: DaysToGoEvent!

	func testCanCreateEvent() {
		sut = DaysToGoEvent(date: Date(), title: "Demo Title")
		XCTAssertNotNil(sut)
	}
}
