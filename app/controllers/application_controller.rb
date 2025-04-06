class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_view_mode

  private

  def set_view_mode
    cookie_value = cookies[:view]&.to_sym
    @view_mode = ApplicationHelper::VIEW_MODES.key?(cookie_value) ? cookie_value : ApplicationHelper::DEFAULT_VIEW_MODE
  end
end
