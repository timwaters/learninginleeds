require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    course = courses(:one)
    get course_url(course)
   
    assert_response :success
    
  end

  test "should get index" do
    get courses_url
    assert_response :success
  
    assert_select 'h1', "/Adult Learning in Leeds/"
  end
  
  #topics
  
  #search
  
  #search with postcode / location
  
  #venue
  
  #provider
  
  

end
