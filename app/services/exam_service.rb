# frozen_string_literal: true

class ExamService

  MAXIMUM_APPLICANTS_NUMBER = 50000
  STATUS_CONFIRMED = "confirmed"
  STATUS_REQUESTED = "requested"

  def find_all_exam_by_user_id(user_id, page, page_size)
    Exam.order(id: :desc).where(reserved_user_id: user_id).page(page).per(page_size)
  end

  def find_all_exam(page, page_size)
    Exam.order(id: :desc).page(page).per(page_size)
  end

  def update(exam_id, title, start_date_time, end_date_time, number_of_applicants)
    validate(start_date_time, end_date_time, number_of_applicants)

    exam = Exam.find(exam_id)
    exam.update(
      title: title,
      start_date_time: start_date_time,
      end_date_time: end_date_time,
      number_of_applicants: number_of_applicants
    )
    exam
  end

  # 예약 가능시간 조회
  def find_available_time(date)
    times = []

    for i in 0..47
      start_minutes = i * 30
      start_horus = start_minutes / 60
      start_remaining_minutes = start_minutes % 60
      start_date_time = Time.parse("#{date.to_s} #{start_horus}:#{start_remaining_minutes}")

      end_minutes = start_minutes + 30
      end_hours = end_minutes / 60
      end_remaining_minutes = end_minutes % 60
      end_date_time = Time.parse("#{date.to_s} #{end_hours}:#{end_remaining_minutes}")

      sum_of_applicants = Exam.where("start_date_time <= ? AND end_date_time >= ? AND status = ?", start_date_time, end_date_time, STATUS_CONFIRMED)
                              .sum(:number_of_applicants)

      current_time_available_info = {
        start_date_time: start_date_time,
        end_date_time: end_date_time,
        total_number_of_applicants_confirmed_between: sum_of_applicants,
        status: 'available'
      }

      if sum_of_applicants >= MAXIMUM_APPLICANTS_NUMBER
        current_time_available_info[:status] = 'unavailable'
      end

      times.push(current_time_available_info)
    end
    times
  end

  # 예약 확정
  def confirm(exam_id, executor_id)
    executor = User.find(executor_id)

    if executor.role != User::ROLE_ADMIN
      raise PermissionDenied, 'Permission denied'
    end

    exam = Exam.find(exam_id)
    start_date_time = exam.start_date_time
    end_date_time = exam.end_date_time

    total_number_of_applicants = total_number_of_applicants_confirmed_between(start_date_time, end_date_time)

    if total_number_of_applicants + exam.number_of_applicants > MAXIMUM_APPLICANTS_NUMBER
      raise ActionController::BadRequest.new("Maximum number of applicants is reached. Available at that time (#{start_date_time} ~ #{end_date_time}): #{MAXIMUM_APPLICANTS_NUMBER - total_number_of_applicants}")
    end

    exam.update(status: STATUS_CONFIRMED)
  end

  # 시험 예약 신청
  def reserve_request(title, reserved_user_id, start_date_time, end_date_time, number_of_applicants)
    start_date_time = Time.parse(start_date_time)
    end_date_time = Time.parse(end_date_time)

    # unless is_datetime_three_days_later(start_date_time)
    #   raise ActionController::BadRequest.new("Unavailable exam date time")
    # end
    #
    # if number_of_applicants > MAXIMUM_APPLICANTS_NUMBER
    #   raise ActionController::BadRequest.new("Maximum number of applicants is reached")
    # end
    #
    # # 해당 시간에 예약확정된 인원이 5만이 넘어가는지 확인
    # total_number_of_applicants_between = total_number_of_applicants_confirmed_between(start_date_time, end_date_time)
    # if total_number_of_applicants_between >= MAXIMUM_APPLICANTS_NUMBER
    #   raise ActionController::BadRequest.new("Maximum number of applicants is reached")
    # end
    #
    # # 최대 허용 인원에 현재 예약 된 인원을 차감해서 현재 수용가능한 인원을 알려줌
    # if total_number_of_applicants_between + number_of_applicants > MAXIMUM_APPLICANTS_NUMBER
    #   raise ActionController::BadRequest.new("Only #{MAXIMUM_APPLICANTS_NUMBER - total_number_of_applicants_between} available at that time")
    # end

    validate(start_date_time, end_date_time, number_of_applicants)

    Exam.create(
      title: title,
      reserved_user_id: reserved_user_id,
      start_date_time: start_date_time,
      end_date_time: end_date_time,
      number_of_applicants: number_of_applicants,
      status: STATUS_REQUESTED
    )
  end

  private

  def validate(start_date_time, end_date_time, number_of_applicants)
    # 3일 확인
    unless is_datetime_three_days_later(start_date_time)
      raise ActionController::BadRequest.new("Unavailable exam date time")
    end

    # 요청하는 응시 인원수가 5만명을 초과하는가
    if number_of_applicants > MAXIMUM_APPLICANTS_NUMBER
      raise ActionController::BadRequest.new("Maximum number of applicants is reached")
    end

    # 해당 시간에 예약확정된 인원이 5만이 넘어가는지 확인
    total_number_of_applicants_between = total_number_of_applicants_confirmed_between(start_date_time, end_date_time)
    if total_number_of_applicants_between >= MAXIMUM_APPLICANTS_NUMBER
      raise ActionController::BadRequest.new("Maximum number of applicants is reached")
    end

    # 최대 허용 인원에 현재 예약 된 인원을 차감해서 현재 수용가능한 인원을 알려줌
    if total_number_of_applicants_between + number_of_applicants > MAXIMUM_APPLICANTS_NUMBER
      raise ActionController::BadRequest.new("Only #{MAXIMUM_APPLICANTS_NUMBER - total_number_of_applicants_between} available at that time")
    end
  end

  private

  def is_datetime_three_days_later(date_time)
    # 3일 전에 예약이 가능, 즉 시험 시작 시간은 현재시간 이후로부터 3일이후부터 가능
    three_days_later = Time.now + (3 * 24 * 60 * 60) # 3일을 초로 변환
    three_days_later = Time.at(three_days_later.to_i)

    date_time >= three_days_later
  end

  # 해당 시간에 확정된 시험 정보를 토대로 응시인원 파악

  private

  def total_number_of_applicants_confirmed_between(start_date_time, end_date_time)
    Exam.where("start_date_time <= ? AND end_date_time >= ? AND status = ?", start_date_time, end_date_time, STATUS_CONFIRMED)
        .sum(:number_of_applicants)
  end

end
