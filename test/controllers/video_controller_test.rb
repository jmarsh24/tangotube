require 'test_helper'

class VideoControllerTest < ActionDispatch::IntegrationTest
  test 'the truth' do
    assert true
  end

  def add_index
    @stories = Story.label

    some_actions_to_be_tested
  end
end
