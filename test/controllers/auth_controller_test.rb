require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest

  test "sign_up test" do
    params = { email: "test@test.com", name: '김그렙', role: 'user', password: "password" }
    post '/api/v1/auth/sign_up', params: params
    body = JSON.parse(response.body)
    assert_not_nil(body["id"])
    assert_equal(params[:email], body['email'])
    assert_equal(params[:name], body['name'])
    assert_response 201
  end

  def sign_up
    params = { email: "test@test.com", name: '김그렙', role: 'user', password: "password" }
    post '/api/v1/auth/sign_up', params: params
    JSON.parse(response.body)
  end

  test "login 404 not found test" do
    params = { email: "test@test.com", password: "password" }
    post '/api/v1/auth/login', params: params
    assert_equal(response.body, "404 Not Found")
    assert_response 404
  end

  test "login success" do
    sign_up
    params = { email: "test@test.com", password: "password" }
    post '/api/v1/auth/login', params: params
    assert_response 200
  end

  test "login password not correct" do
    sign_up
    params = { email: "test@test.com", password: "password1" }
    post '/api/v1/auth/login', params: params
    response_json = JSON.parse(response.body)
    assert_equal(response_json["message"], "Password not correct")
    assert_response 401
  end

  test "session test" do
    get '/api/v1/auth/session'
    body = response.body
    assert_response 401
  end

end
