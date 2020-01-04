require 'test_helper'

class HomeVisitCountTest < ActiveSupport::TestCase
  test "get field" do
    home_two_visit_count = home_visit_counts(:home_two_visit_count)
    assert_not_nil home_two_visit_count.home_id
    assert_not_nil home_two_visit_count.visit_count
  end
end
