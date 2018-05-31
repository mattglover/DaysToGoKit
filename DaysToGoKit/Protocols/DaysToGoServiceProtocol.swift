import Foundation

public protocol DaysToGoServiceProtocol {
	func createNewEvent(date: Date, title: String) -> Event
	func saveEvent(event: Event, completion: (Bool) -> Void)
	func loadEvent(id: String, completion: (Event?) -> Void)
	func deleteEvent(event: Event, completion: (Bool) -> Void)
}
