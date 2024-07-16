class ExamController < JwtController
  before_action :authorized


  def get_exams
    user_id = @current_user.id
    role = @current_user.role

    page = params[:page]
    page_size = params[:page_size]

    if role == User::ROLE_ADMIN
      exams = ExamService.new.find_all_exam(page, page_size)
    else
      exams = ExamService.new.find_all_my_exam(user_id, page, page_size)
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
    }
  end

end
