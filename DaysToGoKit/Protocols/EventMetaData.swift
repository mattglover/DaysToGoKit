import Foundation

public protocol EventMetaData: Codable {
	var id: UUID { get set }
	var date: Date { get set }
	var title: String { get set }
}
