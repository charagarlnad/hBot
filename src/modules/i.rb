class String
  def i?
    Integer(self)
    true
  rescue
    false
  end
end

class NilClass
  def i?
    false
  end
end
