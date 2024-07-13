# frozen_string_literal: true

class TokenDto
  attr_accessor :id, :email, :name, :access_token, :refreshToken

  def initialize(id, email, name, access_token, refresh_token)
    @id = id
    @email = email
    @name = name
    @access_token = access_token
    @refresh_token = refresh_token
  end

end
