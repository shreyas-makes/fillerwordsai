require 'test_helper'

class UploadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:one)
    sign_in @user
    
    # Create a mock file for testing
    @file = fixture_file_upload('test.mp4', 'video/mp4')
  end

  test "should get new" do
    get new_upload_url
    assert_response :success
  end

  test "should not create video without file" do
    assert_no_difference('Video.count') do
      post uploads_url, params: { 
        video: { 
          title: 'Test Video', 
          description: 'Test Description'
        } 
      }
    end

    assert_response :unprocessable_entity
  end
end 