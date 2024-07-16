require "test_helper"

class ExamControllerTest < ActionDispatch::IntegrationTest

  test "예약 조회 컨트롤러 (일반 사용자)" do
    user = User.create(email: "test@grepp.com", name: '김그렙', role: 'user', password: "password")
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
    token = JwtService.new.encode_token(id: user[:id], name: user[:name], email: user[:email], role: user[:role])
    params = {page: 0, page_size: 10}
    get '/api/v1/exams', params: params, headers: { Authorization: "Bearer #{token}" }
    body = JSON.parse(response.body)

    assert_equal(params[:page_size], body["items"].size)
    assert_equal(3, body["page"]["total_pages"])
    assert_equal(1, body["page"]["current_page"])
    assert_equal(21, body["page"]["total_count"])
    assert_nil(body["page"]["prev_page"])
    assert_response :success
  end

  test "예약 조회 컨트롤러 (관리자)" do
    admin_user = User.create(email: "admin@grepp.com", name: '관리자', role: 'admin', password: "password")
    user = User.create(email: "test@grepp.com", name: '김그렙', role: 'user', password: "password")
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

    token = JwtService.new.encode_token(id: admin_user[:id], name: admin_user[:name], email: admin_user[:email], role: admin_user[:role])
    params = {page: 0, page_size: 10}
    get '/api/v1/exams', params: params, headers: { Authorization: "Bearer #{token}" }
    assert_response :success
  end

end
