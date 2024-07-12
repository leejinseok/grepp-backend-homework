class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :routing_error

  def authorized
    Rails.logger.info "Before Action authorized"    # 사용자 인증 로직
    # 예: JWT 토큰을 확인하여 사용자 인증 여부를 결정
  end

  def record_not_found
    render plain: '404 Not Found', status: :not_found
  end

  def routing_error
    render plain: '404 Routing Error', status: :not_found
  end

end
