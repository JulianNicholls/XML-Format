require './xml_reader'

# Test version of XMLReader that allows access to internals.
class TestXMLReader < XMLReader
  attr_reader :buffer, :index
end

reader = TestXMLReader.new 'testfile.txt', 10

puts "Buffer: '#{reader.buffer}', #{reader.index}"

10.times do
  puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"
end

puts "\nPeek: '#{reader.peek_char}' - Buffer: '#{reader.buffer}', #{reader.index}"
puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"

# reader.put_back
# reader.put_back
# puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"

# reader.put_back
# reader.put_back
# puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"

puts "\nBuffer: '#{reader.buffer}', #{reader.index}"
