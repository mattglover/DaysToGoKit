import Foundation

public class DaysToGoService : DaysToGoServiceProtocol {

	public init() {

	}

	public func createNewEvent(date: Date, title: String) -> Event {
		let event = DaysToGoEvent(date: date, title: title)
		return event
	}

	public func saveEvent(event: Event, completion: (Bool) -> Void) {
		let eventFileURL = URL.eventFileURL(id: event.id.uuidString)

		let event = event as! DaysToGoEvent
		guard let archiveData = try? JSONEncoder().encode(event) else {
			completion(false)
			return
		}

		let success = NSKeyedArchiver.archiveRootObject(archiveData, toFile: eventFileURL.path)
		completion(success)
	}

	public func loadEvent(id: String, completion: (Event?) -> Void) {
		let eventFileURL = URL.eventFileURL(id: id)
		guard let unarchivedEventData = NSKeyedUnarchiver.unarchiveObject(withFile: eventFileURL.path) as? Data else {
			completion(nil)
			return
		}

		guard let unarchivedEvent = try? JSONDecoder().decode(DaysToGoEvent.self, from: unarchivedEventData) else {
			completion(nil)
			return
		}

		completion(unarchivedEvent)
	}

	public func deleteEvent(event: Event, completion: (Bool) -> Void) {
		let eventFileURL = URL.eventFileURL(id: event.id.uuidString)
		let fileManager = FileManager.default
		guard fileManager.fileExists(atPath: eventFileURL.path) else {
			completion(false)
			return
		}

		guard let _ = try? fileManager.removeItem(atPath: eventFileURL.path) else {
			completion(false)
			return
		}

		completion(true)
	}
}

extension URL {
	static func eventFileURL(id: String) -> URL {
		let documentsURL = String.documentsURL()
		let eventFilename = "\(id).dat"
		return documentsURL.appendingPathComponent(eventFilename, isDirectory: false)
	}
}

extension String {
	static func documentsURL() -> URL {
		let fileManager = FileManager.default
		return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
	}
}
