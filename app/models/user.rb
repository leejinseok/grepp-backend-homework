class User < ApplicationRecord
  has_many :exams, class_name: 'Exam', foreign_key: 'reserved_id'

  def authenticate(plain_password)
    BCrypt::Password.new(password) == plain_password
  end

end
