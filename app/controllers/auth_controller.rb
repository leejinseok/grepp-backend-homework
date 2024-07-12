class AuthController < ApplicationController

  before_action :authorized
  skip_before_action :authorized, only: [:login, :sign_up]

  def login
    params_permit = params.permit(:email, :password)
    AuthService.new.login(params_permit[:email], params_permit[:password])
  end

  def sign_up
    params_permit = params.permit(:email, :name, :role, :password)

    user = AuthService.new.sign_up(
      params_permit[:email],
      params_permit[:name],
      params_permit[:role],
      params_permit[:password]
    )

    user_dto_new = UserDto.new(user)
    render json: user_dto_new, status: :created
  end

end
