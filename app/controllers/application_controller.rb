class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :routing_error
  rescue_from PasswordNotCorrect, with: :auth_failed
  rescue_from PermissionDenied, with: :auth_failed

  protect_from_forgery with: :null_session

  def record_not_found(exception)
    render json: {  message: exception.message }, status: :not_found
  end

  def routing_error
    render plain: '404 Routing Error', status: :not_found
  end

  def auth_failed(exception)
    render json: { message: exception.message }, status: :unauthorized
  end

  def permission_denied(exception)
    render json: { message: exception.message }, status: :forbidden
  end

end
