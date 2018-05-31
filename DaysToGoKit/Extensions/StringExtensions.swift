import Foundation

extension String {
	static func documentsURL() -> URL {
		let fileManager = FileManager.default
		return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
	}
}
