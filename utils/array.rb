class Array
  def to_sentence
    sentence = self[0..-2].join(", ") + ", and " + self[-1].to_s if self.size > 1
    sentence ||= self.to_s
  end
end