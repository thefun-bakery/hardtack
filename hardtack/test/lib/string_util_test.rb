require 'test_helper'

class StringUtilTest < ActiveSupport::TestCase
  test "string blank?" do
    assert true == StringUtil.blank?(nil)
    assert true == StringUtil.blank?("")
    assert true == StringUtil.blank?(" ")
    assert false == StringUtil.blank?("a ")
  end
end

