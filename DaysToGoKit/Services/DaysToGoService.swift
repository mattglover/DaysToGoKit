import Foundation

fileprivate protocol EventPersistance { }
fileprivate protocol EventMetaDataPersistance { }

public class DaysToGoService: DaysToGoServiceProtocol {

	private var eventMetaDatas = [EventMetaData]() {
		didSet {
			NotificationCenter.default.post(name: .eventsUpdated, object: nil, userInfo: nil)
		}
	}

	public init() {
		eventMetaDatas = loadEventMetaDatas()
	}

	public func createNewEvent(date: Date, title: String) -> Event {
		let event = DaysToGoEvent(date: date, title: title)
		return event
	}

	public func allEventMetaDatas() -> [EventMetaData] {
		return eventMetaDatas.sorted(by: { $0.date < $1.date } )
	}
}

extension DaysToGoService: EventMetaDataPersistance {
	
	private func saveEventMetaDatas(eventMetaDatas: [EventMetaData], completion: @escaping (Bool) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			let eventMetaDatas = eventMetaDatas as! [DaysToGoEventMetaData]
			guard let archiveData = try? JSONEncoder().encode(eventMetaDatas) else {
				DispatchQueue.main.async {
					completion(false)
				}
				return
			}

			let eventMetaDatasFileURL = URL.eventMetaDateFileURL()
			let success = NSKeyedArchiver.archiveRootObject(archiveData, toFile: eventMetaDatasFileURL.path)
			DispatchQueue.main.async {
				completion(success)
			}
		}
	}

	private func loadEventMetaDatas() -> [EventMetaData] {
		let eventMetaDatasFileURL = URL.eventMetaDateFileURL()
		guard let unarchivedData = NSKeyedUnarchiver.unarchiveObject(withFile: eventMetaDatasFileURL.path) as? Data else {
			return [EventMetaData]()
		}

		guard let unarchivedEventMetaDatas = try? JSONDecoder().decode([DaysToGoEventMetaData].self, from: unarchivedData) else {
			return [EventMetaData]()
		}

		return unarchivedEventMetaDatas
	}
}

extension DaysToGoService: EventPersistance {

	public func saveEvent(event: Event, completion: @escaping (Bool) -> Void) {

		// Attempt to save event
		DispatchQueue.global(qos: .userInitiated).async {
			let event = event as! DaysToGoEvent
			guard let archiveData = try? JSONEncoder().encode(event) else {
				DispatchQueue.main.async {
					completion(false)
				}
				return
			}

			let eventFileURL = URL.eventFileURL(id: event.id.uuidString)
			let success = NSKeyedArchiver.archiveRootObject(archiveData, toFile: eventFileURL.path)

			if success {
				// if successful then update EventMetaDatas and save that
				let eventMetaData = DaysToGoEventMetaData(id: event.id, date: event.date, title: event.title)
				if let indexOfEventMetaData = self.eventMetaDatas.index(where: {$0.id == event.id}) {
					self.eventMetaDatas[indexOfEventMetaData] = eventMetaData
					NotificationCenter.default.post(name: .eventUpdated, object: nil, userInfo: ["event" : event])
				} else {
					self.eventMetaDatas.append(eventMetaData)
					NotificationCenter.default.post(name: .eventAdded, object: nil, userInfo: ["event" : event])
				}
				self.saveEventMetaDatas(eventMetaDatas: self.eventMetaDatas, completion: { (success) in
					DispatchQueue.main.async {
						completion(success)
					}
				})
			} else {
				DispatchQueue.main.async {
					completion(false)
				}
			}
		}
	}

	public func loadEvent(id: String, completion: @escaping (Event?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			let eventFileURL = URL.eventFileURL(id: id)
			guard let unarchivedEventData = NSKeyedUnarchiver.unarchiveObject(withFile: eventFileURL.path) as? Data else {
				DispatchQueue.main.async {
					completion(nil)
				}
				return
			}

			guard let unarchivedEvent = try? JSONDecoder().decode(DaysToGoEvent.self, from: unarchivedEventData) else {
				DispatchQueue.main.async {
					completion(nil)
				}
				return
			}

			DispatchQueue.main.async {
				completion(unarchivedEvent)
			}
		}
	}

	public func deleteEvent(event: Event, completion: @escaping (Bool) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			let eventFileURL = URL.eventFileURL(id: event.id.uuidString)
			let fileManager = FileManager.default
			guard fileManager.fileExists(atPath: eventFileURL.path) else {
				DispatchQueue.main.async {
					completion(false)
				}
				return
			}

			guard let _ = try? fileManager.removeItem(atPath: eventFileURL.path) else {
				DispatchQueue.main.async {
					completion(false)
				}
				return
			}
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: .eventDeleted, object: event.id, userInfo: nil)
				completion(true)
			}
		}
	}
}

extension Array where Element: EventMetaData {
	func indexOfEventMetaData(withId id: UUID) -> Int? {
		let index = self.index(where: {$0.id == id})
		return index
	}
}
