# Simple:                                 2M                    5M
#   real	1101m26.333s                   real  12m20.276s    12m7.9s
#   user	19m38.589s      18m46.7s       user  12m8.402s     12m0.6s
#   sys	    8m1.223s        7m45.402s    sys   0m6.491s      0m4.9s

require './xml_reader'

# Format an XML file with indentation and newlines after closing tags.
class XMLFormatter
  def initialize(filename)
    @reader = XMLReader.new filename
    @indent = 0
  end

  def process
    loop do
      item = @reader.next_char
      break if item.nil?

      if item == '<'
        process_opening_tag
      else
        item += read_until_open   # lone text_item
        format_item item
      end
    end
  end

  private

  def process_opening_tag
    open = '<' + read_until_close

    return format_bracketed_item(open) if open[1] == '/'

    text = @reader.next_char

    if text == '<'
      format_bracketed_item open
      return @reader.put_back
    end

    text += read_until_open

    close = read_until_close
    fail "Not a close: #{open} #{text} #{close}" unless close[1] == '/'

    format_tagged_item(open, text, close)
  end

  def read_until_close
    read_until('>')
  end

  def read_until_open
    str = read_until('<')
    str.slice!(-1)        # Remove last char
    @reader.put_back      # and return it to be re-read
    str
  end

  def read_until(last)
    str = ''

    loop do
      char = @reader.next_char
      str += char
      break if char == last
    end
    str
  end

  def format_item(item)
    if item[0] == '<'
      format_bracketed_item item
    else
      format_text_item item
    end
  end

  def format_tagged_item(open, text, close)
    indent
    puts "#{open}#{text}#{close}"
  end

  def format_bracketed_item(item)
    @indent -= 1 if (item[1] == '/')
    fail 'Indent has gone through 0' if @indent < 0
    indent
    puts item

    @indent += 1 if item[1] != '/' && item[-2] != '/'
    fail 'Indent gone too far' if @indent > 50
  end

  def format_text_item(item)
    indent
    puts item
  end

  def indent
    print '  ' * @indent
  end
end

filename = ARGV[0] || 'ha_roadworks_2015_06_29.xml'

formatter = XMLFormatter.new filename
formatter.process
