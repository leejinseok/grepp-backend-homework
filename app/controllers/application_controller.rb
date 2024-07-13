class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :routing_error
  rescue_from PasswordNotCorrect, with: :auth_failed

  def record_not_found
    render plain: '404 Not Found', status: :not_found
  end

  def routing_error
    render plain: '404 Routing Error', status: :not_found
  end

  def auth_failed(exception)
    render json: { message: exception.message }, status: :unauthorized
  end

end
