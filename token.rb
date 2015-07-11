# Token class
Token = Struct.new(:type, :text) do
  def output(spacer)
    spacer.output
    puts @text
  end
end

# Opening or single XML tag
class OpenToken < Token
  def initialize(text)
    @type = :open
    @text = text
  end

  def output(spacer)
    super
    spacer.indent unless '/?'.include? @text[-2]
  end
end

# Closing XML tag
class CloseToken < Token
  def initialize(text)
    @type = :close
    @text = text
  end

  def output(spacer)
    spacer.outdent
    super
  end
end

# Text
class TextToken < Token
  def initialize(text)
    @type = :text
    @text = text
  end
end
