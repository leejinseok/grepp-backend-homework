# frozen_string_literal: true

class SessionDto
  attr_reader :id, :email, :role

  def initialize(id, email, role)
    @id = id
    @email = email
    @role = role
  end

end
