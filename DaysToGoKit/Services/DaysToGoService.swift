import Foundation

public class DaysToGoService : DaysToGoServiceProtocol {

	public init() {

	}

	public func createNewEvent(date: Date, title: String) -> Event {
		let event = DaysToGoEvent(date: date, title: title)
		return event
	}
}
