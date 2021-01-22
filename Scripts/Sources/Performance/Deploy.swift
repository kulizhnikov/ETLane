import Foundation

struct Deploy {
	private let keyValue: [Deploy.NamedKey: String]
}

extension Deploy.NamedKey {

	var fileName: String? {
		switch self {
			case .title: return "name.txt"
			case .subtitle: return "subtitle.txt"
			case .keywords: return "keywords.txt"
			case .whatsNew: return "release_notes.txt"
			default: return nil
		}
	}

}

public extension Array {

	func isIndexValid(index: Int) -> Bool {
		return index >= 0 && index < self.count
	}

	func safeObject(at index: Int) -> Element? {
		guard self.isIndexValid(index: index) else { return nil }
		return self[index]
	}
}

extension String {
	func fixedValue() -> String {
		self
			.replacingOccurrences(of: "\\n", with: "\n")
			.replacingOccurrences(of: "\r", with: "")
	}
}

extension Deploy {

	enum NamedKey: String, CaseIterable {
		case title = "Title"
		case subtitle = "Subtitle"
		case keywords = "keywords"
		case iPhone8 = "iPhone8"
		case iPhone11 = "iPhone11"
		case whatsNew = "What's new"
		case locale = "locale"
		case previewTimestamp
		case iPadPro = "iPadPro"
		case iPadPro3Gen = "iPadPro3Gen"
	}

	init(string: String, map: [Int: NamedKey]) {
		let cmp = string.components(separatedBy: "\t")
		var keyValue = [Deploy.NamedKey: String]()
		cmp.enumerated().forEach { (idx, item) in
			if let key = map[idx] {
				keyValue[key] = item.fixedValue()
			}
		}
		self.keyValue = keyValue
	}

	subscript(key: NamedKey) -> String {
		let text = self.keyValue[key] ?? ""
		return text
	}

	func screenshotPrefixToIds() -> [String: [String]] {
		var prefixToIds = [String: [String]]()
		prefixToIds["APP_IPHONE_55"] = self[.iPhone8].ids()
		prefixToIds["APP_IPHONE_65"] = self[.iPhone11].ids()
		prefixToIds["APP_IPAD_PRO_129"] = self[.iPadPro].ids()
		prefixToIds["APP_IPAD_PRO_3GEN_129"] = self[.iPadPro3Gen].ids()
		return prefixToIds
	}

	func createFiles(at url: URL) {
		NamedKey.allCases.forEach {
			if let fileName = $0.fileName {
				url.write(self[$0], to: fileName)
			}
		}
	}

}


extension URL {

	func write(_ text: String, to path: String) {
		let url = self.appendingPathComponent(path)
		do {
			print("Write \(url.path)")
			try text.write(to: url, atomically: true, encoding: .utf8)
			print("Done")
		} catch {
			print(">>>>>\(text) write error: \(error) to path \(url)")
		}

	}

}

fileprivate extension String {

	func ids() -> [String] {
		return self.components(separatedBy: ",").map {
			($0 as NSString).trimmingCharacters(in: CharacterSet(charactersIn: "0123456789:").inverted)
		}.filter {
			!$0.isEmpty
		}
	}

}
