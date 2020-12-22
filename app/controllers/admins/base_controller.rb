class Admins::BaseController < ApplicationController
  before_action :check_login, :check_admin_role

  layout "admins"

  private

  def check_admin_role
    return if current_user.admin?

    flash[:danger] = t "admins.not_admin"
    redirect_to login_path
  end

  def check_login
    return if user_signed_in?

    flash[:danger] = t "something_wrong"
    redirect_to root_path
  end
end
