import Foundation
import Common

struct Args {
	var output: String = ""
	var skip_screenshots: Bool = false
	var download_preview: Bool = false
	var labels = [String]()

	public enum ArgsError: Error {
		case noTSVPath
		case noOutputPath
		case noLabel
	}

	func check() throws {
		if self.labels.isEmpty { throw ArgsError.noTSVPath }
		if self.output.isEmpty { throw ArgsError.noOutputPath }
	}
}

public extension Error {

	var locd: String {
		return "\(self.localizedDescription) - \(self)"
	}

}

