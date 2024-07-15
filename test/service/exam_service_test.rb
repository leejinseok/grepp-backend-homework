# frozen_string_literal: true

require 'test_helper'

class ExamServiceTest < ActiveSupport::TestCase

  test "예약신청 실패 테스트" do
    start_date_time = Time.now + (2 * 24 * 60 * 60)
    end_date_time = start_date_time + (2 * 60 * 60)

    assert_raise(ActionController::BadRequest, "bad request") do
      ExamService.new.reserve_request('그렙 코딩테스트', 1, start_date_time.to_s, end_date_time.to_s, 10000)
    end

  end

  test "예약신청 테스트" do
    start_date_time = Time.now + (3 * 24 * 60 * 60)
    end_date_time = start_date_time + (2 * 60 * 60)
    ExamService.new.reserve_request('그렙 코딩테스트', 1, start_date_time.to_s, end_date_time.to_s, 10000)
  end

  test '예약가능 시간 조회' do

    user_create = User.create(email: "grepp@grepp.com", name: '김그렙', role: 'user', password: 'password')
    Exam.create(title: "코딩테스트 3", reserved_user_id: user_create.id, status: 'confirmed', start_date_time: Time.parse("2024-07-15 14:00:00 +0900"), end_date_time: Time.parse("2024-07-15 16:00:00 +0900"), limit_user_count: 30000)
    Exam.create(title: "코딩테스트 4", reserved_user_id: user_create.id, status: 'confirmed', start_date_time: Time.parse("2024-07-15 14:00:00 +0900"), end_date_time: Time.parse("2024-07-15 16:00:00 +0900"), limit_user_count: 20000)

    date = Date.parse('2024-07-15')
    times = ExamService.new.find_available_reserve_time(date)
    times.each do |time|
      puts time
    end
  end

end
