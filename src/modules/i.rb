class String
  def i?
    Integer(self)
    true
  rescue
    false
  end
end
