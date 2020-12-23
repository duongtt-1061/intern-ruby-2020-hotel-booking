class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def valid_date_for_booking
    @date_start = params[:date_start].presence || Time.zone.today.to_s
    @date_end = params[:date_end].presence || @date_start
  end

  def get_booked_room_for_booking
    @booked_room = Booking.by_room_id(params[:room_id])
                          .not_in_order(params[:order_exist].presence || 0)
                          .check_status_by_date @date_start, @date_end
  end
end
