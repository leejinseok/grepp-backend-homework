# frozen_string_literal: true

class JwtController < ApplicationController
  rescue_from TokenMissing, with: :authenticated_failed
  rescue_from UnAuthorized, with: :authenticated_failed

  SECRET_KEY = Rails.application.secret_key_base

  def authorized
    auth_header = request.headers['Authorization']
    if auth_header.present?
      token = auth_header.split(' ')[1]
      decoded_token = decode_token(token)
      if decoded_token
        @current_user = User.find_by(id: decoded_token['user_id'])
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
