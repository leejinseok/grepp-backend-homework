# frozen_string_literal: true

require 'test_helper'

class ExamServiceTest < ActiveSupport::TestCase

  def create_sample_user
    User.create(email: "grepp@grepp.com", name: '김그렙', role: 'user', password: 'password')
  end

  def create_sample_admin_user
    User.create(email: "admin@grepp.com", name: '관리자', role: 'admin', password: 'password')
  end


  test "예약신청 실패(3일 후부터 가능)" do
    start_date_time = Time.now + (2 * 24 * 60 * 60)
    end_date_time = start_date_time + (2 * 60 * 60)

    assert_raise(ActionController::BadRequest, "bad request") do
      ExamService.new.reserve_request('그렙 코딩테스트', 1, start_date_time.to_s, end_date_time.to_s, 10000)
    end
  end

  test "예약신청" do
    start_date_time = Time.now + (3 * 24 * 60 * 60)
    end_date_time = start_date_time + (2 * 60 * 60)
    exam = ExamService.new.reserve_request('그렙 코딩테스트', 1, start_date_time.to_s, end_date_time.to_s, 10000)
  end

  test '예약가능 시간 조회' do

    user_create = create_sample_user
    Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user_create.id,
      status: 'confirmed',
      start_date_time: Time.parse("2024-07-15 14:00:00 +0900"),
      end_date_time: Time.parse("2024-07-15 16:00:00 +0900"),
      number_of_applicants: 30000
    )
    Exam.create(
      title: "코딩테스트 2",
      reserved_user_id: user_create.id,
      status: 'confirmed',
      start_date_time: Time.parse("2024-07-15 14:00:00 +0900"),
      end_date_time: Time.parse("2024-07-15 16:00:00 +0900"),
      number_of_applicants: 20000
    )

    date = Date.parse('2024-07-15')
    ExamService.new.find_available_time(date)
  end

  test '예약확정 실패 (응시인원 초과)' do
    user = create_sample_user
    exam1 = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-07-15 14:00:00 +0900"),
      end_date_time: Time.parse("2024-07-15 16:00:00 +0900"),
      number_of_applicants: 30000
    )
    exam2 = Exam.create(
      title: "코딩테스트 2",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-07-15 14:00:00 +0900"),
      end_date_time: Time.parse("2024-07-15 16:00:00 +0900"),
      number_of_applicants: 30000
    )

    admin_user = create_sample_admin_user
    ExamService.new.confirm(exam1.id, admin_user.id)
    assert_raise(ActionController::BadRequest, "bad request") do
      ExamService.new.confirm(exam2.id, admin_user.id)
    end
  end

  test '예약확정' do
    user = create_sample_user
    exam1 = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-07-15 14:00:00 +0900"),
      end_date_time: Time.parse("2024-07-15 16:00:00 +0900"),
      number_of_applicants: 30000
    )

    admin_user = create_sample_admin_user
    ExamService.new.confirm(exam1.id, admin_user.id)
  end

  test '예약확정 실패 (일반사용자)' do
    user = create_sample_user
    exam1 = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-07-15 14:00:00 +0900"),
      end_date_time: Time.parse("2024-07-15 16:00:00 +0900"),
      number_of_applicants: 30000
    )

    assert_raise(PermissionDenied, 'Permission denied') do
      ExamService.new.confirm(exam1.id, user.id)
    end
  end

  test '예약 조회' do
    user = create_sample_user
    for i in 0..20
      Exam.create(
        title: "코딩테스트 #{i}",
        reserved_user_id: user.id,
        status: 'requested',
        start_date_time: Time.parse("2024-07-15 14:00:00"),
        end_date_time: Time.parse("2024-07-15 16:00:00"),
        number_of_applicants: 30000
      )
    end

    exams = ExamService.new.find_all_exam_by_user_id(user.id, 0, 10)
    assert_equal(3, exams.total_pages)
    assert_equal(1, exams.current_page)
    assert_equal(2, exams.next_page)
    assert_nil(exams.prev_page)
    assert_equal(21, exams.total_count)
  end

  test '예약 수정' do
    user = create_sample_user
    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    update_exam = {
      exam_id: exam.id,
      title: '코딩테스트 1-1',
      start_date_time: Time.parse("2024-09-15 16:00:00"),
      end_date_time: Time.parse("2024-09-15 18:00:00"),
      number_of_applicants: 30000
    }

    updated = ExamService.new.update(

      update_exam[:exam_id],
      update_exam[:title],
      update_exam[:start_date_time],
      update_exam[:end_date_time],
      update_exam[:number_of_applicants],
    )

    assert_equal(update_exam[:title], updated.title)
    assert_equal(update_exam[:start_date_time], updated.start_date_time)
    assert_equal(update_exam[:end_date_time], updated.end_date_time)
    assert_equal(update_exam[:number_of_applicants], updated.number_of_applicants)
  end

  test '예약 삭제 (일반 사용자)' do
    user = create_sample_user
    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    ExamService.new.delete_by_not_admin_user(user.id, exam.id)
  end

  test '예약 삭제 실패 (일반 사용자)' do
    user = create_sample_user
    other_user = User.create(email: "ruby@grepp.com", name: '김루비', role: 'user', password: 'password')

    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    assert_raise(PermissionDenied, 'Not your exam') {
      ExamService.new.delete_by_not_admin_user(other_user.id, exam.id)
    }
  end

  test '예약삭제' do
    user = create_sample_user
    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )
    ExamService.new.delete(exam.id)
  end


end
