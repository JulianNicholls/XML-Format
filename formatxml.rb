#!/usr/bin/env ruby -I.

# Simple:                                 2M                    5M
#   real	1101m26.333s                   real  12m20.276s    12m7.9s
#   user	19m38.589s      18m46.7s       user  12m8.402s     12m0.6s
#   sys	    8m1.223s        7m45.402s    sys   0m6.491s      0m4.9s

require './xml_reader'
require './token'
require './spacer'

# Format an XML file with indentation and newlines after closing tags.
class XMLFormatter
  def initialize(filename)
    @reader = XMLReader.new filename
    @spacer = Spacer.new
  end

  def process
    while (token = next_token)
      process_token token
    end
  end

  private

  def next_token
    return TextToken.new(read_until_open) unless @reader.peek_char == '<'

    text = read_until_close

    return collect_CDATA(text) if text[0..8] == '<![CDATA['

    text[1] == '/' ? CloseToken.new(text) : OpenToken.new(text)
  rescue
    nil
  end

  def process_token(token)
    case token.type
    when :open          then  process_opening_tag token
    when :close, :text  then  token.output @spacer
    else
      fail "Bad token returned from next_token: #{token}"
    end
  end

  # Process a sequence like <name>Julian</name>
  def process_opening_tag(open_token)
    skip_whitespace
    # If another tag follows the first, output the first and return
    return open_token.output(@spacer) if @reader.peek_char == '<'

    # Some sort of text follows for sure
    text_token = next_token

    # It should be a closing tag now...
    close_token = next_token
    fail "Not a close: #{open_token} #{text_token} #{close_token}" unless
      close_token.type == :close

    format_tagged_item(open_token, text_token, close_token)
  end

  def skip_whitespace
    @reader.skip_whitespace
  end

  def collect_CDATA(text)
    text += read_until_close until text[-3..-2] == ']]'

    TextToken.new(text[9..-4])
  end

  def read_until_close
    @reader.read_until '>'
  end

  def read_until_open
    @reader.read_upto '<'
  end

  def format_tagged_item(open, text, close)
    @spacer.output "#{open.text}#{text.text}#{close.text}"
  end
end

filename = ARGV[0] || 'ha_roadworks_2015_06_29.xml'

formatter = XMLFormatter.new filename
formatter.process
