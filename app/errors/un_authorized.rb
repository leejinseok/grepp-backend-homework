# frozen_string_literal: true

class UnAuthorized < StandardError
  def initialize
    super("You are not authorized")
  end

end
