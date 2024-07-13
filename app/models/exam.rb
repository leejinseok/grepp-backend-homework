class Exam < ApplicationRecord
  belongs_to :reserved_user, class_name: 'User', foreign_key: 'reserved_user_id'
end
