# Reader of files, that buffers and ensures that 10 characters of pushback
class XMLReader
  SLACK = 10

  def initialize(filename, chunk = 1_048_576 * 5)
    @file = open filename
    @chunk = chunk
    refill
  rescue => e
    $stderr.puts "Cannot open #{filename}: #{e.message}"
    exit 1
  end

  def next_char
    return nil if @buffer.size == SLACK

    loop do
      @char = @buffer[@index]
      @index += 1
      refill if @index == @buffer.size

      return @char unless @char =~ /[\r\n]/
    end
  end

  def put_back
    @index -= 1
    fail 'put_back has gone too far.' if @index == -1
  end

  private

  def refill
    @buffer = @buffer.nil? ? ' ' * 10 : @buffer.slice(-SLACK..-1)
    read = @file.read @chunk
    @buffer << read unless read.nil?
    @index = SLACK
  end
end
