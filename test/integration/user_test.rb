require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #
  test "manage_staff" do
    get '/user/manage_staff'
    byebug
  end
end
