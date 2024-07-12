class AuthController < ApplicationController

  before_action :authorized
  skip_before_action :authorized [:login]

  def login

  end

end
