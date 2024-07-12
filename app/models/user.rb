class User < ApplicationRecord

  def authenticate(plain_password)
    BCrypt::Password.new(password) == plain_password
  end

end
