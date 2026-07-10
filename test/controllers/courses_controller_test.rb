require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    course = courses(:one)
    get course_path(course.lcc_code)
   
    assert_response :success
  end

  test "should get index" do
    get courses_url
    assert_response :success
  
    assert_select 'h1', /Leeds Adult Learning/
  end
  
  #topics
  
  #search
  
  #search with postcode / location
  
  #venue
  
  #provider
  
  

end
