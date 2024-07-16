class AuthController < JwtController

  before_action :authorized
  skip_before_action :authorized, only: [:login, :sign_up]

  def login
    params_permit = params.permit(:email, :password)
    user = AuthService.new.login(params_permit[:email], params_permit[:password])
    token = JwtService.new.encode_token(id: user[:id], name: user[:name], email: user[:email], role: user[:role])
    token_dto = TokenDto.new(user.id, user.email, user.name, token, nil)
    render json: token_dto, status: :ok
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
