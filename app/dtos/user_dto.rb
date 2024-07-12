# frozen_string_literal: true

class UserDto
  attr_accessor :id, :email, :name

  def initialize(user)
    @id = user.id
    @email = user.email
    @name = user.name
  end
end
