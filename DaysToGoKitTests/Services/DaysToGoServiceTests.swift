import XCTest
@testable import DaysToGoKit

class DaysToGoServiceTests: XCTestCase {

	var sut: DaysToGoService!

	func testCanCreateNewEvent() {
		sut = DaysToGoService()
		let event = sut.createNewEvent(date: Date(), title: "DaysToGoService Demo Event")
		XCTAssertNotNil(event)
	}
}
