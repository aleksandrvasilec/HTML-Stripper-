# html_stripper.rb
class HTMLStripper
  attr_accessor :strip_comments, :convert_br, :decode_entities, :collapse_spaces

  def initialize
    @strip_comments = true
    @convert_br = true
    @decode_entities = true
    @collapse_spaces = true
  end

  def strip(html_text)
    text = html_text.dup
    # Remove script and style blocks
    text.gsub!(/<script\b[^>]*>.*?<\/script>/mi, '')
    text.gsub!(/<style\b[^>]*>.*?<\/style>/mi, '')
    text.gsub!(/<!--.*?-->/, '') if @strip_comments
    text.gsub!(/<br\s*\/?>/i, "\n") if @convert_br
    text.gsub!(/<[^>]+>/, '')
    text = decode_entities(text) if @decode_entities
    if @collapse_spaces
      text.gsub!(/[ \t]+/, ' ')
      text.gsub!(/\n\s*\n/, "\n\n")
      text.strip!
    end
    text
  end

  def decode_entities(s)
    entities = {
      '&nbsp;' => ' ', '&amp;' => '&', '&lt;' => '<', '&gt;' => '>',
      '&quot;' => '"', '&#39;' => "'", '&apos;' => "'", '&copy;' => '©',
      '&reg;' => '®', '&trade;' => '™', '&euro;' => '€', '&pound;' => '£',
      '&yen;' => '¥', '&cent;' => '¢', '&sect;' => '§', '&deg;' => '°'
    }
    entities.each { |ent, char| s.gsub!(ent, char) }
    s
  end

  def strip_file(filepath)
    content = File.read(filepath)
    strip(content)
  end
end

def main
  stripper = HTMLStripper.new
  puts "=== HTML Stripper ==="
  loop do
    puts "\n1. Strip HTML from input text"
    puts "2. Strip HTML from file"
    puts "3. Toggle options (comments: #{stripper.strip_comments}, convert_br: #{stripper.convert_br}, decode_entities: #{stripper.decode_entities}, collapse_spaces: #{stripper.collapse_spaces})"
    puts "4. Exit"
    print "Choose: "
    choice = gets.chomp.strip
    case choice
    when '1'
      puts "Enter HTML text (end with empty line):"
      lines = []
      loop do
        line = gets.chomp
        break if line.empty?
        lines << line
      end
      html_text = lines.join("\n")
      result = stripper.strip(html_text)
      puts "\nProcessed result:\n#{result}"
    when '2'
      print "Enter file path: "
      fname = gets.chomp.strip
      begin
        result = stripper.strip_file(fname)
        puts "\nProcessed result:\n#{result}"
      rescue => e
        puts "Error: #{e.message}"
      end
    when '3'
      stripper.strip_comments = !stripper.strip_comments
      stripper.convert_br = !stripper.convert_br
      stripper.decode_entities = !stripper.decode_entities
      stripper.collapse_spaces = !stripper.collapse_spaces
      puts "Options toggled."
    when '4'
      puts "Goodbye!"
      break
    else
      puts "Invalid choice."
    end
  end
end

main if __FILE__ == $0
