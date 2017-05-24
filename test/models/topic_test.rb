require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  def test_has_subjects
    topic = topics(:one)
    assert topic.has_courses?
    
    empty_topic = topics(:two)
    assert_not empty_topic.has_courses?
  end

end
