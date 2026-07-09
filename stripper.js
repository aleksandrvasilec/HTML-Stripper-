// html_stripper.js
const readline = require('readline');
const fs = require('fs');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

class HTMLStripper {
    constructor() {
        this.stripComments = true;
        this.convertBr = true;
        this.decodeEntities = true;
        this.collapseSpaces = true;
    }

    strip(htmlText) {
        let text = htmlText;
        // Remove script and style blocks
        text = text.replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, '');
        text = text.replace(/<style\b[^>]*>[\s\S]*?<\/style>/gi, '');
        if (this.stripComments) {
            text = text.replace(/<!--[\s\S]*?-->/g, '');
        }
        if (this.convertBr) {
            text = text.replace(/<br\s*\/?>/gi, '\n');
        }
        // Remove all tags
        text = text.replace(/<[^>]+>/g, '');
        if (this.decodeEntities) {
            text = this.decodeHTMLEntities(text);
        }
        if (this.collapseSpaces) {
            text = text.replace(/[ \t]+/g, ' ');
            text = text.replace(/\n\s*\n/g, '\n\n');
            text = text.trim();
        }
        return text;
    }

    decodeHTMLEntities(text) {
        const entities = {
            '&nbsp;': ' ', '&amp;': '&', '&lt;': '<', '&gt;': '>',
            '&quot;': '"', '&#39;': "'", '&apos;': "'", '&copy;': '©',
            '&reg;': '®', '&trade;': '™', '&euro;': '€', '&pound;': '£',
            '&yen;': '¥', '&cent;': '¢', '&sect;': '§', '&deg;': '°'
        };
        for (const [ent, char] of Object.entries(entities)) {
            text = text.replace(new RegExp(ent, 'g'), char);
        }
        return text;
    }

    stripFile(filepath) {
        const data = fs.readFileSync(filepath, 'utf8');
        return this.strip(data);
    }
}

async function main() {
    const stripper = new HTMLStripper();
    console.log("=== HTML Stripper ===");
    while (true) {
        console.log(`\n1. Strip HTML from input text`);
        console.log(`2. Strip HTML from file`);
        console.log(`3. Toggle options (comments: ${stripper.stripComments}, convert_br: ${stripper.convertBr}, decode_entities: ${stripper.decodeEntities}, collapse_spaces: ${stripper.collapseSpaces})`);
        console.log("4. Exit");
        const choice = await ask("Choose: ");
        switch (choice.trim()) {
            case '1': {
                console.log("Enter HTML text (end with empty line):");
                const lines = [];
                while (true) {
                    const line = await ask("");
                    if (line === '') break;
                    lines.push(line);
                }
                const htmlText = lines.join('\n');
                const result = stripper.strip(htmlText);
                console.log("\nProcessed result:\n", result);
                break;
            }
            case '2': {
                const fname = await ask("Enter file path: ");
                try {
                    const result = stripper.stripFile(fname);
                    console.log("\nProcessed result:\n", result);
                } catch (e) {
                    console.log("Error:", e.message);
                }
                break;
            }
            case '3': {
                stripper.stripComments = !stripper.stripComments;
                stripper.convertBr = !stripper.convertBr;
                stripper.decodeEntities = !stripper.decodeEntities;
                stripper.collapseSpaces = !stripper.collapseSpaces;
                console.log("Options toggled.");
                break;
            }
            case '4':
                console.log("Goodbye!");
                rl.close();
                return;
            default:
                console.log("Invalid choice.");
        }
    }
}

main().catch(console.error);
