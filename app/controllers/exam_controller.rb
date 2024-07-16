class ExamController < JwtController
  before_action :authorized

  def confirm
    exam_id = params[:exam_id].to_i
    user_id = @current_user.id
    ExamService.new.confirm(exam_id, user_id)
    head 200
  end

  def get_available_time
    date = params[:date]
    date = Date.parse(date.to_s)
    available_times = ExamService.new.find_available_time(date)
    render json: { available_times: available_times }, status: 200
  end

  def reserve_request
    user_id = @current_user.id
    title = params[:title]
    start_date_time = params[:start_date_time].to_s
    end_date_time = params[:end_date_time].to_s
    number_of_applicants = params[:number_of_applicants].to_i

    exam = ExamService.new.reserve_request(title, user_id, start_date_time, end_date_time, number_of_applicants)
    render json: { exam: ExamDto.new(exam) }, status: 201
  end

  def get_exams
    user_id = @current_user.id
    role = @current_user.role

    page = params[:page]
    page_size = params[:page_size]

    if role == User::ROLE_ADMIN
      exams = ExamService.new.find_all_exam(page, page_size)
    else
      exams = ExamService.new.find_all_exam_by_user_id(user_id, page, page_size)
    end

    render json: {
      items: exams,
      page: {
        total_pages: exams.total_pages,
        current_page: exams.current_page,
        total_count: exams.total_count,
        next_page: exams.next_page,
        prev_page: exams.prev_page,
      }
    }, status: 200
  end

end
