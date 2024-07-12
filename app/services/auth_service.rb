# frozen_string_literal: true

class AuthService

  def sign_up(email, name, role, password)
    User.create(email: email, name: name, role: role, password: password)
  end

end
