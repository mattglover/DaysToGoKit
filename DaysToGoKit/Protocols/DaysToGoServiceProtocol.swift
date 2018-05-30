import Foundation

public protocol DaysToGoServiceProtocol {
	func createNewEvent(date: Date, title: String) -> Event
}
