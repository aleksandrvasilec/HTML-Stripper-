# html_stripper.py
import re
import html
import sys
from typing import Tuple, Optional

class HTMLStripper:
    def __init__(self, strip_comments=True, convert_br=True, decode_entities=True, collapse_spaces=True):
        self.strip_comments = strip_comments
        self.convert_br = convert_br
        self.decode_entities = decode_entities
        self.collapse_spaces = collapse_spaces

    def strip(self, html_text: str) -> str:
        # Remove script and style blocks (with their content)
        text = re.sub(r'<script\b[^>]*>.*?</script>', '', html_text, flags=re.DOTALL | re.IGNORECASE)
        text = re.sub(r'<style\b[^>]*>.*?</style>', '', text, flags=re.DOTALL | re.IGNORECASE)

        # Optionally remove comments
        if self.strip_comments:
            text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)

        # Convert <br> to newline
        if self.convert_br:
            text = re.sub(r'<br\s*/?>', '\n', text, flags=re.IGNORECASE)

        # Remove all remaining tags
        text = re.sub(r'<[^>]+>', '', text)

        # Decode HTML entities
        if self.decode_entities:
            text = html.unescape(text)

        # Collapse whitespace (optional)
        if self.collapse_spaces:
            text = re.sub(r'[ \t]+', ' ', text)
            text = re.sub(r'\n\s*\n', '\n\n', text)
            text = text.strip()

        return text

    def strip_file(self, filepath: str) -> str:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        return self.strip(content)

def main():
    stripper = HTMLStripper()
    print("=== HTML Stripper ===")
    while True:
        print("\n1. Strip HTML from input text")
        print("2. Strip HTML from file")
        print("3. Toggle options (comments: {}, convert_br: {}, decode_entities: {}, collapse_spaces: {})".format(
            stripper.strip_comments, stripper.convert_br, stripper.decode_entities, stripper.collapse_spaces))
        print("4. Exit")
        choice = input("Choose: ").strip()
        if choice == '1':
            print("Enter HTML text (end with empty line):")
            lines = []
            while True:
                line = input()
                if line == '':
                    break
                lines.append(line)
            html_text = '\n'.join(lines)
            result = stripper.strip(html_text)
            print("\nProcessed result:\n", result)
        elif choice == '2':
            fname = input("Enter file path: ").strip()
            try:
                result = stripper.strip_file(fname)
                print("\nProcessed result:\n", result)
            except FileNotFoundError:
                print("File not found.")
            except Exception as e:
                print(f"Error: {e}")
        elif choice == '3':
            # Toggle options
            stripper.strip_comments = not stripper.strip_comments
            stripper.convert_br = not stripper.convert_br
            stripper.decode_entities = not stripper.decode_entities
            stripper.collapse_spaces = not stripper.collapse_spaces
            print("Options toggled.")
        elif choice == '4':
            print("Goodbye!")
            break
        else:
            print("Invalid choice.")

if __name__ == "__main__":
    main()
