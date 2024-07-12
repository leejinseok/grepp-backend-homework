require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest

  test "sign_up test" do
    params = { email: "test@test.com", name: '김그렙', role: 'user', password: "password" }
    post '/api/v1/auth/sign_up', params: params
    body = JSON.parse(response.body)

    assert_not_nil(body["id"])
    assert_equal(params[:email], body['email'])
    assert_equal(params[:name], body['name'])
    assert_response :created
  end

  test "login 404 not found test" do
    params = { email: "test@test.com", password: "password" }
    post '/api/v1/auth/login', params: params
    assert_equal(response.body, "404 Not Found")
    assert_response :not_found
  end

end
