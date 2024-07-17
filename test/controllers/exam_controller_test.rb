require "test_helper"

class ExamControllerTest < ActionDispatch::IntegrationTest

  def create_sample_user
    User.create(email: "test@grepp.com", name: '김그렙', role: 'user', password: "password")
  end

  def create_sample_admin_user
    User.create(email: "admin@grepp.com", name: '관리자', role: 'admin', password: "password")
  end

  def generate_token(user)
    JwtService.new.encode_token(id: user[:id], name: user[:name], email: user[:email], role: user[:role])
  end

  test '예약가능 시간조회 (컨트롤러)' do
    user = create_sample_user
    token = generate_token(user)

    Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'confirmed',
      start_date_time: Time.parse("2024-07-15 04:00:00"),
      end_date_time: Time.parse("2024-07-15 06:00:00"),
      number_of_applicants: 50000
    )

    params = {date: '2024-07-15'}
    get '/api/v1/exams/available_times', params: params, headers: { Authorization: "Bearer #{token}" }
    body = JSON.parse(response.body)

    available_times_count = 0
    body.each do |time|
      if time['status'] == 'available'
        available_times_count += 1
      end
    end

    assert_equal(44, available_times_count)
    assert_response 200
  end

  test '예약 신청 (컨트롤러)' do
    user = create_sample_user
    token = generate_token(user)
    params = {
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      start_date_time: Time.parse("2024-10-01 14:00:00"),
      end_date_time: Time.parse("2024-10-01 16:00:00"),
      number_of_applicants: 30000
    }
    post '/api/v1/exams/request', params: params, headers: {  Authorization: "Bearer #{token}" }
    assert_response 201
  end

  test "예약 조회 일반사용자 (컨트롤러)" do
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
    token = generate_token(user)
    params = {page: 0, page_size: 10}
    get '/api/v1/exams', params: params, headers: { Authorization: "Bearer #{token}" }
    body = JSON.parse(response.body)

    assert_equal(params[:page_size], body["items"].size)
    assert_equal(3, body["page"]["total_pages"])
    assert_equal(1, body["page"]["current_page"])
    assert_equal(21, body["page"]["total_count"])
    assert_nil(body["page"]["prev_page"])
    assert_response 200
  end

  test "예약 조회 관리자 (컨트롤러)" do
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

    token = generate_token(admin_user)
    params = {page: 0, page_size: 10}
    get '/api/v1/exams', params: params, headers: { Authorization: "Bearer #{token}" }
    assert_response 200
  end

  test '예약 확정 (컨트롤러)' do
    admin_user = User.create(email: "admin@grepp.com", name: '관리자', role: 'admin', password: "password")
    token = generate_token(admin_user)
    user = User.create(email: "test@grepp.com", name: '김그렙', role: 'user', password: "password")

    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-07-15 14:00:00"),
      end_date_time: Time.parse("2024-07-15 16:00:00"),
      number_of_applicants: 30000
    )

    patch "/api/v1/exams/#{exam.id}/confirm", headers: { Authorization: "Bearer #{token}" }
    assert_response 200
  end

  test '예약 변경 (일반 사용자)' do
    user = create_sample_user
    token = generate_token(user)

    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    params = {
      title: '코딩테스트 1-1',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 40000
    }

    patch "/api/v1/exams/#{exam.id}", params: params,  headers: { Authorization: "Bearer #{token}" }
    body = JSON.parse(response.body)

    assert_equal(params[:title], body["title"])
    assert_equal(params[:start_date_time], body["start_date_time"])
    assert_equal(params[:end_date_time], body["end_date_time"])
    assert_equal(params[:number_of_applicants], body["number_of_applicants"])
    assert_response 200
  end

  test '예약 변경 (관리자)' do
    user = create_sample_user

    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    admin_user = create_sample_admin_user
    token = generate_token(admin_user)

    params = {
      title: '코딩테스트 1-1',
      start_date_time: Time.parse("2024-09-15 16:00:00"),
      end_date_time: Time.parse("2024-09-15 18:00:00"),
      number_of_applicants: 40000
    }

    patch "/api/v1/exams/#{exam.id}", params: params,  headers: { Authorization: "Bearer #{token}" }
    body = JSON.parse(response.body)

    assert_equal(params[:title], body["title"])
    assert_equal(params[:start_date_time], body["start_date_time"])
    assert_equal(params[:end_date_time], body["end_date_time"])
    assert_equal(params[:number_of_applicants], body["number_of_applicants"])
    assert_response 200
  end

  test '예약 삭제 (일반 사용자)' do
    user = create_sample_user
    token = generate_token(user)
    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    delete "/api/v1/exams/#{exam.id}", headers: { Authorization: "Bearer #{token}" }
    assert_response 200
  end

  test '예약 삭제 실패 (일반 사용자)' do
    user = create_sample_user
    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    other_user = User.create(email: "ruby@grepp.com", name: '김루비', role: 'user', password: "password")
    token = generate_token(other_user)

    delete "/api/v1/exams/#{exam.id}", headers: { Authorization: "Bearer #{token}" }
    body = JSON.parse(response.body)
    assert_equal("Not your exam", body["message"])
    assert_response 401
  end

  test '예약 삭제 (관리자)' do
    user = create_sample_user
    exam = Exam.create(
      title: "코딩테스트 1",
      reserved_user_id: user.id,
      status: 'requested',
      start_date_time: Time.parse("2024-09-15 14:00:00"),
      end_date_time: Time.parse("2024-09-15 16:00:00"),
      number_of_applicants: 30000
    )

    admin_user = create_sample_admin_user
    token = generate_token(admin_user)

    delete "/api/v1/exams/#{exam.id}", headers: { Authorization: "Bearer #{token}" }
    assert_response 200
  end


end
