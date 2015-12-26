# Token class
class Token
  attr_reader :type, :text

  def initialize(text)
    @type = :text
    @text = text
  end

  def output(spacer)
    spacer.output @text
  end
end

# Text holder
class TextToken < Token
end

# Null Token

class NullToken < Token
  def initialize(*)
    @type = :null
  end

  def output(*)
  end
end

# Opening or single XML tag
class OpenToken < Token
  def initialize(text)
    super
    @type = :open
  end

  def output(spacer)
    super
    spacer.indent unless '/?'.include? @text[-2]
  end
end

# Closing XML tag
class CloseToken < Token
  def initialize(text)
    super
    @type = :close
  end

  def output(spacer)
    spacer.outdent
    super
  end
end
