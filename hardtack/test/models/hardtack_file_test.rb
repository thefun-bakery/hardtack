require 'test_helper'

class HardtackFileTest < ActiveSupport::TestCase
  test "get field" do
    hardtack_file = hardtack_files(:one)
    assert_not_nil hardtack_file.name
    assert_not_nil hardtack_file.upload_complete
    assert_not_nil hardtack_file.user
  end
end
