module StringUtil
  def self.blank?(str)
    return true if str.nil?
    return true if str.strip.empty?
    return false
  end
end
