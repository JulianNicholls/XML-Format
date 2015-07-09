# Reader of files, that buffers and ensures that 10 characters of pushback
class XMLReader
  def initialize(filename, chunk = 1_048_576 * 5)
    @file = open filename
    @chunk = chunk
    refill
  rescue => e
    $stderr.puts "Cannot open #{filename}: #{e.message}"
    exit 1
  end

  # The difference between next_char and peek_char is that peek_char returns
  # the current character and only moves on if it's a newline.

  def next_char
    return nil if @buffer.nil?

    loop do
      char = @buffer[@index]
      @index += 1
      refill if @index == @buffer.size

      return char unless char =~ /[\r\n]/
    end
  end

  def peek_char
    return nil if @buffer.nil?

    loop do
      char = @buffer[@index]
      return char unless char =~ /[\r\n]/

      @index += 1
      refill if @index == @buffer.size
    end
  end

  private

  def refill
    @buffer = @file.read @chunk
    @index = 0
  end
end
