# frozen_string_literal: true

class AuthService

  def sign_up(email, name, role, password)
    hash = BCrypt::Password.create(password)
    User.create(email: email, name: name, role: role, password: hash)
  end

  def login(email, password)
    user_find_by = User.find_by(email: email)
    if user_find_by == nil
      raise ActiveRecord::RecordNotFound, 'No exist email'
    end
      authenticated = user_find_by.authenticate(password)

    if authenticated == false
      raise PasswordNotCorrect
    end

    user_find_by
  end

end
