require './xml_reader'

# Test version of XMLReader that allows access to internals.
class TestXMLReader < XMLReader
  attr_reader :buffer, :index
end

reader = TestXMLReader.new 'testfile.txt', 10

puts "Buffer: '#{reader.buffer}', #{reader.index}"

str = ''

10.times do
  puts "'#{reader.peek_char}' - Buffer: '#{reader.buffer}', #{reader.index}"
  str << reader.next_char
end

raise 'Bad Reads' if str != 'ABCDEFGHIJ'

str = reader.read_upto 'P'
raise "Bad Reads: #{str}" if str != 'KLMNO'

str = reader.read_until '9'
raise 'Bad Reads' if str != 'PQRSTUVWXYZ0123456789'

raise "Not nil: #{reader.peek_char}" unless reader.peek_char.nil?
raise "Not nil: #{reader.next_char}" unless reader.next_char.nil?
