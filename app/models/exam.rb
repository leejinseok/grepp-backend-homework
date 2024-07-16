class Exam < ApplicationRecord
  belongs_to :reserved_user, class_name: 'User', foreign_key: 'reserved_user_id'

  def equal_reserved_user_id(user_id)
    reserved_user.id == user_id
  end
end
