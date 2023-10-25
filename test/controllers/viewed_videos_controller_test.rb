require "test_helper"

class ViewedVideosControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get viewed_videos_create_url
    assert_response :success
  end
end
