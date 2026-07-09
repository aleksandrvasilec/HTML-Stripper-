// HtmlStripper.cs
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

class HtmlStripper
{
    public bool StripComments { get; set; } = true;
    public bool ConvertBr { get; set; } = true;
    public bool DecodeEntities { get; set; } = true;
    public bool CollapseSpaces { get; set; } = true;

    public string Strip(string htmlText)
    {
        string text = htmlText;
        // Remove script and style blocks
        text = Regex.Replace(text, @"<script\b[^>]*>.*?</script>", "", RegexOptions.Singleline | RegexOptions.IgnoreCase);
        text = Regex.Replace(text, @"<style\b[^>]*>.*?</style>", "", RegexOptions.Singleline | RegexOptions.IgnoreCase);
        if (StripComments)
            text = Regex.Replace(text, @"<!--.*?-->", "", RegexOptions.Singleline);
        if (ConvertBr)
            text = Regex.Replace(text, @"<br\s*/?>", "\n", RegexOptions.IgnoreCase);
        // Remove tags
        text = Regex.Replace(text, @"<[^>]+>", "");
        if (DecodeEntities)
            text = DecodeHTMLEntities(text);
        if (CollapseSpaces)
        {
            text = Regex.Replace(text, @"[ \t]+", " ");
            text = Regex.Replace(text, @"\n\s*\n", "\n\n");
            text = text.Trim();
        }
        return text;
    }

    private string DecodeHTMLEntities(string s)
    {
        var entities = new Dictionary<string, string>
        {
            {"&nbsp;", " "}, {"&amp;", "&"}, {"&lt;", "<"}, {"&gt;", ">"},
            {"&quot;", "\""}, {"&#39;", "'"}, {"&apos;", "'"}, {"&copy;", "©"},
            {"&reg;", "®"}, {"&trade;", "™"}, {"&euro;", "€"}, {"&pound;", "£"},
            {"&yen;", "¥"}, {"&cent;", "¢"}, {"&sect;", "§"}, {"&deg;", "°"}
        };
        foreach (var kv in entities)
            s = s.Replace(kv.Key, kv.Value);
        return s;
    }

    public string StripFile(string filepath)
    {
        string content = File.ReadAllText(filepath);
        return Strip(content);
    }

    static void Main()
    {
        var stripper = new HtmlStripper();
        Console.WriteLine("=== HTML Stripper ===");
        while (true)
        {
            Console.WriteLine("\n1. Strip HTML from input text");
            Console.WriteLine("2. Strip HTML from file");
            Console.WriteLine($"3. Toggle options (comments: {stripper.StripComments}, convert_br: {stripper.ConvertBr}, decode_entities: {stripper.DecodeEntities}, collapse_spaces: {stripper.CollapseSpaces})");
            Console.WriteLine("4. Exit");
            Console.Write("Choose: ");
            string choice = Console.ReadLine()?.Trim() ?? "";
            switch (choice)
            {
                case "1":
                    Console.WriteLine("Enter HTML text (end with empty line):");
                    var lines = new List<string>();
                    while (true)
                    {
                        string line = Console.ReadLine() ?? "";
                        if (line == "") break;
                        lines.Add(line);
                    }
                    string htmlText = string.Join("\n", lines);
                    string result = stripper.Strip(htmlText);
                    Console.WriteLine("\nProcessed result:\n" + result);
                    break;
                case "2":
                    Console.Write("Enter file path: ");
                    string fname = Console.ReadLine()?.Trim() ?? "";
                    try
                    {
                        result = stripper.StripFile(fname);
                        Console.WriteLine("\nProcessed result:\n" + result);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Error: " + e.Message);
                    }
                    break;
                case "3":
                    stripper.StripComments = !stripper.StripComments;
                    stripper.ConvertBr = !stripper.ConvertBr;
                    stripper.DecodeEntities = !stripper.DecodeEntities;
                    stripper.CollapseSpaces = !stripper.CollapseSpaces;
                    Console.WriteLine("Options toggled.");
                    break;
                case "4":
                    Console.WriteLine("Goodbye!");
                    return;
                default:
                    Console.WriteLine("Invalid choice.");
                    break;
            }
        }
    }
}
