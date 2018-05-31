import Foundation

struct DaysToGoEventMetaData: EventMetaData, Codable {
	var id: UUID
	var date: Date
	var title: String
}
