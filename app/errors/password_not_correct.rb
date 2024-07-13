# frozen_string_literal: true

class PasswordNotCorrect < StandardError
  def initialize(msg="Password not correct")
    super(msg)
  end

end
