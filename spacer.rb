# Indentation handler
class Spacer
  def initialize(width = 2)
    @width = width
    @level = 0
  end

  def indent
    @level += 1
  end

  def outdent
    @level -= 1
    raise 'Indent went past 0' if @level < 0
  end

  def output(text)
    print ' ' * (@width * @level)
    puts text
  end
end
