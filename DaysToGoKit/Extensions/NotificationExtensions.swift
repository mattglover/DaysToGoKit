import Foundation

extension Notification.Name {
	public static var eventsUpdated: Notification.Name {
		return .init(rawValue: "DaysToGoService.eventsUpdated")
	}
	public static var eventUpdated: Notification.Name {
		return .init(rawValue: "DaysToGoService.eventUpdated")
	}
	public static var eventAdded: Notification.Name {
		return .init(rawValue: "DaysToGoService.eventAdded")
	}
	public static var eventDeleted: Notification.Name {
		return .init(rawValue: "DaysToGoService.eventDeleted")
	}
}
