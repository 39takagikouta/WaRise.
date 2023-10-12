require "test_helper"

class AlarmsControllerTest < ActionDispatch::IntegrationTest
  test "should get mypage" do
    get alarms_mypage_url
    assert_response :success
  end
end
