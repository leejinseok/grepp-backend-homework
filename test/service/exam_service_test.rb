# frozen_string_literal: true

require 'test_helper'

class ExamServiceTest < ActiveSupport::TestCase

  test "reserve fail test" do
    start_date_time = Time.now + (2 * 24 * 60 * 60)
    end_date_time = start_date_time + (2 * 60 * 60)

    assert_raise(ActionController::BadRequest, "bad request") do
      ExamService.new.reserve('그렙 코딩테스트', 1, start_date_time.to_s, end_date_time.to_s, 100)
    end

  end

  test "reserve test" do
    start_date_time = Time.now + (3 * 24 * 60 * 60)
    end_date_time = start_date_time + (2 * 60 * 60)
    ExamService.new.reserve('그렙 코딩테스트', 1, start_date_time.to_s, end_date_time.to_s, 100)
  end

end
