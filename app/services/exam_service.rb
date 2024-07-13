# frozen_string_literal: true

class ExamService

  def reserve(title, reserved_user_id, start_date_time, end_date_time, limit_user_count)
    # 해당 시간에 예약확정된 인원 + 현재 예약하려는 인원제한이 5만이 넘어가는지 확인
    Exam.create(
      title: title,
      reserved_user_id: reserved_user_id,
      start_date_time: start_date_time,
      end_date_time: end_date_time,
      limit_user_count: limit_user_count,
    )
  end

end
