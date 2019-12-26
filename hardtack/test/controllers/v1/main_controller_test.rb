require 'test_helper'
require 'login'

class V1::MainControllerTest < ActionDispatch::IntegrationTest
  setup do
    @v1_home = homes(:home_one)
    @hardtack_token = Login.login(@v1_home.user)
  end

  test "should show v1_main/mine" do
    get v1_main_mine_url,
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success
  end

  test "should show v1_main/1" do
    get v1_main_url(@v1_home),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success
  end
end
