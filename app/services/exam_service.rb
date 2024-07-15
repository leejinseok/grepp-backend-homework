# frozen_string_literal: true

class ExamService

  # 예약 가능시간 조회
  def find_available_reserve_time(date)
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

      sum_of_limit_user_count = Exam.where("start_date_time <= ? AND end_date_time >= ? AND status = ?", start_date_time, end_date_time, 'confirmed')
                                  .sum(:limit_user_count)

      current_time_available_info = {
        start_date_time: start_date_time,
        end_date_time: end_date_time,
        sum_of_limit_user_count: sum_of_limit_user_count,
        status: 'available'
      }

      if sum_of_limit_user_count >= 50000
        current_time_available_info[:status] = 'unavailable'
      end

      times.push(current_time_available_info)
    end
    times
  end

  # 예약 확정
  def confirm(exam_id) end

  # 시험 예약 신청
  def reserve_request(title, reserved_user_id, start_date_time, end_date_time, limit_user_count)
    start_date_time = Time.parse(start_date_time)
    end_date_time = Time.parse(end_date_time)

    unless is_datetime_three_days_later(start_date_time)
      raise ActionController::BadRequest.new("Unavailable exam date time")
    end

    # 해당 시간에 예약확정된 인원 + 현재 예약하려는 인원제한이 5만이 넘어가는지 확인
    Exam.where("start_date_time <= ? AND end_date_time >= ? AND status = ?", start_date_time, end_date_time, 'confirmed')

    Exam.create(
      title: title,
      reserved_user_id: reserved_user_id,
      start_date_time: start_date_time,
      end_date_time: end_date_time,
      limit_user_count: limit_user_count,
      status: 'requested'
    )
  end

  private

  def is_datetime_three_days_later(date_time)
    # 3일 전에 예약이 가능, 즉 시험 시작 시간은 현재시간 이후로부터 3일이후부터 가능
    three_days_later = Time.now + (3 * 24 * 60 * 60) # 3일을 초로 변환
    three_days_later = Time.at(three_days_later.to_i)

    date_time >= three_days_later
  end

end
