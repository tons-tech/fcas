require 'test_helper'

class DepartmentControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get department_new_url
    assert_response :success
  end

end
