import Foundation

public protocol DaysToGoServiceProtocol : class {

	func createNewEvent(date: Date, title: String) -> Event
	func allEventMetaDatas() -> [EventMetaData]

	func loadEvent(id: String, completion: @escaping (Event?) -> Void)
	func saveEvent(event: Event, completion: @escaping (Bool) -> Void)
	func deleteEvent(event: Event, completion: @escaping (Bool) -> Void)
}
