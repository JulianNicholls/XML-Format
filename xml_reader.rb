# Reader of files, that buffers and ensures that 10 characters of pushback
class XMLReader
  def initialize(filename, chunk = 1_048_576 * 5)
    @file = open filename
    @chunk = chunk
    refill
  rescue => error
    $stderr.puts "Cannot open #{filename}: #{error.message}"
    exit 1
  end

  def read_until(last)
    str = read_upto last
    str << next_char
  end

  def read_upto(last)
    str = ''

    str << next_char while peek_char != last
    str
  end

  def next_char
    char = peek_char
    increment
    char
  rescue
    nil
  end

  def peek_char
    loop do
      char = @buffer[@index]
      return char unless char =~ /[\r\n]/
      increment
    end
  rescue
    nil
  end

  private

  def increment
    @index += 1
    refill if @index == @buffer.size
  end

  def refill
    @buffer = @file.read @chunk
    @index = 0
  end
end
