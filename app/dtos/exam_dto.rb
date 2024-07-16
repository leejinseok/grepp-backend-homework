# frozen_string_literal: true

class ExamDto
  attr_accessor :id, :title, :reserved_user_id, :start_date_time, :end_date_time, :number_of_applicants


  def initialize(exam)
    @id = exam.id
    @title = exam.title
    @reserved_user_id = exam.reserved_user_id
    @start_date_time = exam.start_date_time
    @end_date_time = exam.end_date_time
    @number_of_applicants = exam.number_of_applicants
  end

end
