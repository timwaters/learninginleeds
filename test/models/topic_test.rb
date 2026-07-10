require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  def test_has_courses
    topic = topics(:one)
    topic.update_count
    assert topic.has_courses?
    
    empty_topic = topics(:two)
    empty_topic.update_count
    assert_not empty_topic.has_courses?
  end

end
