# frozen_string_literal: true

class JwtService

  SECRET_KEY = Rails.application.secret_key_base

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    begin
      JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0]
    rescue JWT::DecodeError
      nil
    end
  end

end
