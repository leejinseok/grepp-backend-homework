class ApplicationController < ActionController::Base

  def authorized
    Rails.logger.info "Before Action authorized"    # 사용자 인증 로직
    # 예: JWT 토큰을 확인하여 사용자 인증 여부를 결정
  end

end
