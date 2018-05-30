import Foundation

public protocol Event {
	var id: UUID { get }
	var date: Date { get set }
	var title: String { get set }

	init(date: Date, title: String)
}
