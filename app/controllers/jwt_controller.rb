# frozen_string_literal: true

class JwtController < ApplicationController
  rescue_from TokenMissing, with: :authenticated_failed
  rescue_from UnAuthorized, with: :authenticated_failed

  def authorized
    auth_header = request.headers['Authorization']
    if auth_header.present?
      token = auth_header.split(' ')[1]
      decoded_token = JwtService.new.decode_token(token)
      if decoded_token
        @current_user = SessionDto.new(decoded_token['id'], decoded_token['email'], decoded_token['role'])
      else
        raise UnAuthorized
      end
    else
      raise TokenMissing
    end
  end


  private
  def authenticated_failed(exception)
    render json: { message: exception.message }, status: 401
  end

end
