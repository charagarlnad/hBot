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

  # 1:1 implementation of how File.read works
  def realistic_read(amount)
    return nil if @data.nil?
    buffer = @data[0...amount]
    @data = @data[amount..-1]
    buffer
  end

  # Returns all the file at once and disregards the amount, works for how RestClient reads from it, 5-6x faster with small files, thousands of times faster with large files.
  def read(*)
    return nil unless @data
    buffer = @data
    @data = nil
    buffer
  end
end
