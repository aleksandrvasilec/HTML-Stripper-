// html_stripper.go
package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"strings"
)

type HTMLStripper struct {
	StripComments  bool
	ConvertBr      bool
	DecodeEntities bool
	CollapseSpaces bool
}

func NewHTMLStripper() *HTMLStripper {
	return &HTMLStripper{
		StripComments:  true,
		ConvertBr:      true,
		DecodeEntities: true,
		CollapseSpaces: true,
	}
}

func (s *HTMLStripper) Strip(htmlText string) string {
	text := htmlText
	// Remove <script> and <style> blocks
	reScript := regexp.MustCompile(`(?is)<script\b[^>]*>.*?</script>`)
	text = reScript.ReplaceAllString(text, "")
	reStyle := regexp.MustCompile(`(?is)<style\b[^>]*>.*?</style>`)
	text = reStyle.ReplaceAllString(text, "")

	if s.StripComments {
		reComment := regexp.MustCompile(`<!--.*?-->`)
		text = reComment.ReplaceAllString(text, "")
	}
	if s.ConvertBr {
		reBr := regexp.MustCompile(`(?i)<br\s*/?>`)
		text = reBr.ReplaceAllString(text, "\n")
	}
	// Remove all tags
	reTag := regexp.MustCompile(`<[^>]+>`)
	text = reTag.ReplaceAllString(text, "")

	if s.DecodeEntities {
		text = decodeHTMLEntities(text)
	}
	if s.CollapseSpaces {
		space := regexp.MustCompile(`[ \t]+`)
		text = space.ReplaceAllString(text, " ")
		newlines := regexp.MustCompile(`\n\s*\n`)
		text = newlines.ReplaceAllString(text, "\n\n")
		text = strings.TrimSpace(text)
	}
	return text
}

func decodeHTMLEntities(s string) string {
	// Basic entity map
	entities := map[string]string{
		"&nbsp;": " ", "&amp;": "&", "&lt;": "<", "&gt;": ">",
		"&quot;": "\"", "&#39;": "'", "&apos;": "'", "&copy;": "©",
		"&reg;": "®", "&trade;": "™", "&euro;": "€", "&pound;": "£",
		"&yen;": "¥", "&cent;": "¢", "&sect;": "§", "&deg;": "°",
	}
	for ent, char := range entities {
		s = strings.ReplaceAll(s, ent, char)
	}
	return s
}

func (s *HTMLStripper) StripFile(filepath string) (string, error) {
	data, err := ioutil.ReadFile(filepath)
	if err != nil {
		return "", err
	}
	return s.Strip(string(data)), nil
}

func main() {
	stripper := NewHTMLStripper()
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println("=== HTML Stripper ===")
	for {
		fmt.Printf("\n1. Strip HTML from input text\n")
		fmt.Printf("2. Strip HTML from file\n")
		fmt.Printf("3. Toggle options (comments: %v, convert_br: %v, decode_entities: %v, collapse_spaces: %v)\n",
			stripper.StripComments, stripper.ConvertBr, stripper.DecodeEntities, stripper.CollapseSpaces)
		fmt.Println("4. Exit")
		fmt.Print("Choose: ")
		scanner.Scan()
		choice := strings.TrimSpace(scanner.Text())
		switch choice {
		case "1":
			fmt.Println("Enter HTML text (end with empty line):")
			var lines []string
			for {
				scanner.Scan()
				line := scanner.Text()
				if line == "" {
					break
				}
				lines = append(lines, line)
			}
			htmlText := strings.Join(lines, "\n")
			result := stripper.Strip(htmlText)
			fmt.Println("\nProcessed result:\n", result)
		case "2":
			fmt.Print("Enter file path: ")
			scanner.Scan()
			fname := strings.TrimSpace(scanner.Text())
			result, err := stripper.StripFile(fname)
			if err != nil {
				fmt.Println("Error:", err)
			} else {
				fmt.Println("\nProcessed result:\n", result)
			}
		case "3":
			stripper.StripComments = !stripper.StripComments
			stripper.ConvertBr = !stripper.ConvertBr
			stripper.DecodeEntities = !stripper.DecodeEntities
			stripper.CollapseSpaces = !stripper.CollapseSpaces
			fmt.Println("Options toggled.")
		case "4":
			fmt.Println("Goodbye!")
			return
		default:
			fmt.Println("Invalid choice.")
		}
	}
}
