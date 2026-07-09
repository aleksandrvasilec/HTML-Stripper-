// html_stripper.swift
import Foundation

class HTMLStripper {
    var stripComments = true
    var convertBr = true
    var decodeEntities = true
    var collapseSpaces = true

    func strip(_ htmlText: String) -> String {
        var text = htmlText
        // Remove script and style blocks
        text = text.replacingOccurrences(of: "<script\\b[^>]*>.*?</script>", with: "", options: [.regularExpression, .caseInsensitive])
        text = text.replacingOccurrences(of: "<style\\b[^>]*>.*?</style>", with: "", options: [.regularExpression, .caseInsensitive])
        if stripComments {
            text = text.replacingOccurrences(of: "<!--.*?-->", with: "", options: .regularExpression)
        }
        if convertBr {
            text = text.replacingOccurrences(of: "<br\\s*/?>", with: "\n", options: [.regularExpression, .caseInsensitive])
        }
        text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        if decodeEntities {
            text = decodeHTMLEntities(text)
        }
        if collapseSpaces {
            text = text.replacingOccurrences(of: "[ \\t]+", with: " ", options: .regularExpression)
            text = text.replacingOccurrences(of: "\\n\\s*\\n", with: "\n\n", options: .regularExpression)
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return text
    }

    func decodeHTMLEntities(_ s: String) -> String {
        var result = s
        let entities: [String: String] = [
            "&nbsp;": " ", "&amp;": "&", "&lt;": "<", "&gt;": ">",
            "&quot;": "\"", "&#39;": "'", "&apos;": "'", "&copy;": "©",
            "&reg;": "®", "&trade;": "™", "&euro;": "€", "&pound;": "£",
            "&yen;": "¥", "&cent;": "¢", "&sect;": "§", "&deg;": "°"
        ]
        for (entity, char) in entities {
            result = result.replacingOccurrences(of: entity, with: char)
        }
        return result
    }

    func stripFile(_ filepath: String) throws -> String {
        let content = try String(contentsOfFile: filepath, encoding: .utf8)
        return strip(content)
    }
}

func main() {
    let stripper = HTMLStripper()
    print("=== HTML Stripper ===")
    while true {
        print("\n1. Strip HTML from input text")
        print("2. Strip HTML from file")
        print("3. Toggle options (comments: \(stripper.stripComments), convert_br: \(stripper.convertBr), decode_entities: \(stripper.decodeEntities), collapse_spaces: \(stripper.collapseSpaces))")
        print("4. Exit")
        print("Choose: ", terminator: "")
        guard let choice = readLine()?.trimmingCharacters(in: .whitespaces) else { continue }
        switch choice {
        case "1":
            print("Enter HTML text (end with empty line):")
            var lines: [String] = []
            while true {
                guard let line = readLine() else { break }
                if line.isEmpty { break }
                lines.append(line)
            }
            let htmlText = lines.joined(separator: "\n")
            let result = stripper.strip(htmlText)
            print("\nProcessed result:\n\(result)")
        case "2":
            print("Enter file path: ", terminator: "")
            guard let fname = readLine()?.trimmingCharacters(in: .whitespaces) else { break }
            do {
                let result = try stripper.stripFile(fname)
                print("\nProcessed result:\n\(result)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        case "3":
            stripper.stripComments.toggle()
            stripper.convertBr.toggle()
            stripper.decodeEntities.toggle()
            stripper.collapseSpaces.toggle()
            print("Options toggled.")
        case "4":
            print("Goodbye!")
            return
        default:
            print("Invalid choice.")
        }
    }
}

main()
