require 'test_helper'

class V1::HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @v1_home = homes(:one)
  end

  test "should get index" do
    get v1_homes_url, as: :json
    assert_response :success
  end

  test "should create v1_home" do
    assert_difference('Home.count') do
      post v1_homes_url, params: { v1_home: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show v1_home" do
    get v1_home_url(@v1_home), as: :json
    assert_response :success
  end

  test "should update v1_home" do
    patch v1_home_url(@v1_home), params: { v1_home: {  } }, as: :json
    assert_response 200
  end

  test "should destroy v1_home" do
    assert_difference('Home.count', -1) do
      delete v1_home_url(@v1_home), as: :json
    end

    assert_response 204
  end
end
