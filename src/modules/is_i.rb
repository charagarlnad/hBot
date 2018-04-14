class String
  def is_i?
     /\A[-+]?\d+\z/ === self
  end
end

class NilClass
  def is_i?
     false
  end
end