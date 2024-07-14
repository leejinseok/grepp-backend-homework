# frozen_string_literal: true

class ExamService

  def reserve(title, reserved_user_id, start_date_time, end_date_time, limit_user_count)
    start_date_time = Time.parse(start_date_time)
    end_date_time = Time.parse(end_date_time)

    # 3일 전에 예약이 가능, 즉 시험 시작 시간은 지금으로 부터 3일이후부터 가능
    three_days_later = Time.now + (3 * 24 * 60 * 60) # 3일을 초로 변환
    three_days_later = Time.at(three_days_later.to_i)

    if start_date_time < three_days_later
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
    )
  end

end
