require './xml_reader'

# Test version of XMLReader that allows access to internals.
class TestXMLReader < XMLReader
  attr_reader :buffer, :index
end

reader = TestXMLReader.new 'testfile.txt', 15

puts "Buffer: '#{reader.buffer}', #{reader.index}"

16.times do
  puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"
end

reader.put_back
puts "\n'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"

reader.put_back
reader.put_back
puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"

reader.put_back
reader.put_back
puts "'#{reader.next_char}' - Buffer: '#{reader.buffer}', #{reader.index}"

puts "\nBuffer: '#{reader.buffer}', #{reader.index}"
