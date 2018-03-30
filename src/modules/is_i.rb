class String
  def is_i?
     /\A[-+]?\d+\z/ === self
  end
end