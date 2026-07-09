🧹 HTML Stripper – Multi‑Language Edition

A comprehensive **HTML tag remover** that extracts plain text from HTML input by stripping all tags, attributes, comments, and optionally handling HTML entities and `<br>` tags.  
Built in **7 programming languages** – perfect for web scraping, content extraction, or learning.

## ✨ Features
- **Strip all tags** – removes `<...>` and any content inside angle brackets (including attributes).
- **Remove comments** – strips `<!-- ... -->` blocks.
- **Handle `<br>` tags** – converts `<br>` to newline (`\n`) for better readability.
- **Decode HTML entities** – converts `&nbsp;`, `&amp;`, `&lt;`, `&gt;`, `&quot;`, `&#39;`, etc. to their characters.
- **Strip `<script>` and `<style>`** – removes entire blocks of script and style content (including inner text).
- **Preserve text** – keeps text nodes, but collapses multiple whitespace (optional).
- **Batch processing** – read input from console or file, process in bulk.
- **Interactive CLI** – choose options (strip comments, decode entities, convert `<br>` to newline).

## 🗂 Languages & Files
| Language          | File                     |
|-------------------|--------------------------|
| Python            | `html_stripper.py`       |
| Go                | `html_stripper.go`       |
| JavaScript        | `html_stripper.js`       |
| C#                | `HtmlStripper.cs`        |
| Java              | `HtmlStripper.java`      |
| Ruby              | `html_stripper.rb`       |
| Swift             | `html_stripper.swift`    |

## 🚀 How to Run
Each file is standalone – run it with the appropriate interpreter/compiler:

| Language | Command |
|----------|---------|
| Python   | `python html_stripper.py` |
| Go       | `go run html_stripper.go` |
| JavaScript | `node html_stripper.js` |
| C#       | `dotnet run` (or `csc HtmlStripper.cs`) |
| Java     | `javac HtmlStripper.java && java HtmlStripper` |
| Ruby     | `ruby html_stripper.rb` |
| Swift    | `swift html_stripper.swift` |

## 📊 Example Session
=== HTML Stripper ===

Strip HTML from input text

Strip HTML from file

Toggle options (strip comments, convert br, decode entities)

Exit
Choose: 1

Enter HTML text (end with empty line):

<p>Hello, <b>world</b>! <a href="http://example.com">Click here</a>.</p> <!-- this is a comment --> <br> &nbsp;This is a test.
Processed result:
Hello, world! Click here.

This is a test.

text

## 📁 File Format
Any HTML or text file (UTF-8) – the tool extracts all plain text content.

## 🔧 Technical Details
- **Regex approach** – removes tags using `/<[^>]*>/` and comments with `<!--.*?-->` (with proper flags).
- **Entity decoding** – uses built‑in HTML entity maps or a custom dictionary.
- **Whitespace handling** – collapses multiple spaces/newlines into single ones (configurable).

## 🤝 Contributing
Add support for more HTML entities, XML processing, or integrate with a full HTML parser for better accuracy – PRs welcome!

## 📜 License
MIT – use freely.
