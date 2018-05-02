# https://gist.github.com/Roughsketch/78f4c100217771d3195eafc1dfc5aa2a
class BinaryImage
  def initialize(data, name)
    @data = data
    @name = name
  end

  def path
    @name
  end

  def original_filename
    @name
  end

  def read(amount)
    return nil if @data.nil?
    buffer = @data[0...amount]
    @data = @data[amount..-1]
    buffer
  end
end
