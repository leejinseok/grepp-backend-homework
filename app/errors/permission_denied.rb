# frozen_string_literal: true

class PermissionDenied < StandardError
  def initialize(msg = 'Permission denied')
    super(msg)
  end

end
