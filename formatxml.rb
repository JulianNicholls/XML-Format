# Simple:                                 2M                    5M
#   real	1101m26.333s                   real  12m20.276s    12m7.9s
#   user	19m38.589s      18m46.7s       user  12m8.402s     12m0.6s
#   sys	    8m1.223s        7m45.402s    sys   0m6.491s      0m4.9s

require './xml_reader'

# Token class
Token = Struct.new(:type, :text)

# Format an XML file with indentation and newlines after closing tags.
class XMLFormatter
  def initialize(filename)
    @reader = XMLReader.new filename
    @indent = 0
  end

  def process
    loop do
      token = next_token
      break if token.nil?

      case token.type
      when :open   then  process_opening_tag token
      when :close  then  output_tag token
      when :text   then  output_text token
      else
        fail "Bad token returned from next_token: #{token}"
      end
    end
  end

  private

  def next_token
    text = @reader.peek_char
    return nil if text.nil?

    if text == '<'
      text = read_until_close
      Token.new(text[1] == '/' ? :close : :open, text)
    else
      text = read_until_open
      Token.new(:text, text)
    end
  end

  # Process a sequence like <name>Julian</name>
  def process_opening_tag(open_token)
    # If another tag follows the first, output the first and return
    return output_tag(open_token) if @reader.peek_char == '<'

    # Some sort of text follows for sure
    text_token = next_token

    # If the next character isn't a tag lead-in, output what we have
    # and return
    if @reader.peek_char != '<'
      output_tag open_token
      output_text text_token
      return
    end

    # It should be a closing tag now...
    close_token = next_token
    fail "Not a close: #{open_token} #{text_token} #{close_token}" unless
      close_token.type == :close

    format_tagged_item(open_token, text_token, close_token)
  end

  def read_until_close
    read_until('>')
  end

  def read_until_open
    read_upto('<')
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

  def read_upto(last)
    str = ''

    loop do
      char = @reader.peek_char
      break if char == last
      str += @reader.next_char
    end
    str
  end

  def format_tagged_item(open, text, close)
    indent
    puts "#{open.text}#{text.text}#{close.text}"
  end

  def output_tag(token)
    adjust_indent token

    indent
    puts token.text

    adjust_indent token
  end

  def adjust_indent(token)
    if token.type == :close
      @indent -= 1
      fail 'Indent has gone through 0' if @indent < 0
    else
      @indent += 1 unless '/?'.include? token.text[-2]
      fail 'Indent has gone too far' if @indent > 50
    end
  end

  def output_text(token)
    indent
    puts token.text
  end

  def indent
    print '  ' * @indent
  end
end

filename = ARGV[0] || 'ha_roadworks_2015_06_29.xml'

formatter = XMLFormatter.new filename
formatter.process
