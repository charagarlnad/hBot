class String
  def i?
    Integer(self)
    true
  rescue ArgumentError
    false
  end
end
