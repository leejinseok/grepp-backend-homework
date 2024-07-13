# frozen_string_literal: true

class TokenMissing < StandardError
  def initialize
    super("Token missing")
  end

end
