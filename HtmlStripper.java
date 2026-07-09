// HtmlStripper.java
import java.io.*;
import java.util.*;
import java.util.regex.*;

public class HtmlStripper {
    private boolean stripComments = true;
    private boolean convertBr = true;
    private boolean decodeEntities = true;
    private boolean collapseSpaces = true;

    public String strip(String htmlText) {
        String text = htmlText;
        text = text.replaceAll("(?is)<script\\b[^>]*>.*?</script>", "");
        text = text.replaceAll("(?is)<style\\b[^>]*>.*?</style>", "");
        if (stripComments)
            text = text.replaceAll("<!--.*?-->", "");
        if (convertBr)
            text = text.replaceAll("(?i)<br\\s*/?>", "\n");
        text = text.replaceAll("<[^>]+>", "");
        if (decodeEntities)
            text = decodeEntities(text);
        if (collapseSpaces) {
            text = text.replaceAll("[ \\t]+", " ");
            text = text.replaceAll("\\n\\s*\\n", "\n\n");
            text = text.trim();
        }
        return text;
    }

    private String decodeEntities(String s) {
        Map<String, String> entities = new HashMap<>();
        entities.put("&nbsp;", " "); entities.put("&amp;", "&");
        entities.put("&lt;", "<"); entities.put("&gt;", ">");
        entities.put("&quot;", "\""); entities.put("&#39;", "'");
        entities.put("&apos;", "'"); entities.put("&copy;", "©");
        entities.put("&reg;", "®"); entities.put("&trade;", "™");
        entities.put("&euro;", "€"); entities.put("&pound;", "£");
        entities.put("&yen;", "¥"); entities.put("&cent;", "¢");
        entities.put("&sect;", "§"); entities.put("&deg;", "°");
        for (Map.Entry<String, String> e : entities.entrySet())
            s = s.replace(e.getKey(), e.getValue());
        return s;
    }

    public String stripFile(String filepath) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(filepath))) {
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line).append("\n");
        }
        return strip(sb.toString());
    }

    public static void main(String[] args) throws IOException {
        HtmlStripper stripper = new HtmlStripper();
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("=== HTML Stripper ===");
        while (true) {
            System.out.println("\n1. Strip HTML from input text");
            System.out.println("2. Strip HTML from file");
            System.out.printf("3. Toggle options (comments: %b, convert_br: %b, decode_entities: %b, collapse_spaces: %b)\n",
                    stripper.stripComments, stripper.convertBr, stripper.decodeEntities, stripper.collapseSpaces);
            System.out.println("4. Exit");
            System.out.print("Choose: ");
            String choice = reader.readLine().trim();
            switch (choice) {
                case "1":
                    System.out.println("Enter HTML text (end with empty line):");
                    StringBuilder sb = new StringBuilder();
                    while (true) {
                        String line = reader.readLine();
                        if (line.isEmpty()) break;
                        sb.append(line).append("\n");
                    }
                    String htmlText = sb.toString();
                    String result = stripper.strip(htmlText);
                    System.out.println("\nProcessed result:\n" + result);
                    break;
                case "2":
                    System.out.print("Enter file path: ");
                    String fname = reader.readLine().trim();
                    try {
                        result = stripper.stripFile(fname);
                        System.out.println("\nProcessed result:\n" + result);
                    } catch (FileNotFoundException e) {
                        System.out.println("File not found.");
                    } catch (Exception e) {
                        System.out.println("Error: " + e.getMessage());
                    }
                    break;
                case "3":
                    stripper.stripComments = !stripper.stripComments;
                    stripper.convertBr = !stripper.convertBr;
                    stripper.decodeEntities = !stripper.decodeEntities;
                    stripper.collapseSpaces = !stripper.collapseSpaces;
                    System.out.println("Options toggled.");
                    break;
                case "4":
                    System.out.println("Goodbye!");
                    return;
                default:
                    System.out.println("Invalid choice.");
            }
        }
    }
}
