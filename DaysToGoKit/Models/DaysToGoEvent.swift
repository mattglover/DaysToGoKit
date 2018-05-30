import Foundation

struct DaysToGoEvent: Event {
	private(set) var id: UUID
	var date: Date = Date()
	var title: String = ""

	init(date: Date, title: String) {
		self.id = UUID.init()
		self.date = date
		self.title = title
	}
}
