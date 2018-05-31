import Foundation

extension URL {
	static func eventFileURL(id: String) -> URL {
		let documentsURL = String.documentsURL()
		let eventFilename = "\(id).dat"
		return documentsURL.appendingPathComponent(eventFilename, isDirectory: false)
	}

	static func eventMetaDateFileURL() -> URL {
		let documentsURL = String.documentsURL()
		let eventMetaDateFilename = "eventMetaDatas.dat"
		return documentsURL.appendingPathComponent(eventMetaDateFilename, isDirectory: false)
	}
}
