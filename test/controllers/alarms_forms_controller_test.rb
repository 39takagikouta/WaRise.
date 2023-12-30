require "test_helper"

class AlarmsFormsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get alarms_forms_new_url
    assert_response :success
  end

  test "should get create" do
    get alarms_forms_create_url
    assert_response :success
  end
end
