class Admins::BaseController < ApplicationController
  before_action :authenticate_user!, :check_admin_role

  layout "admins"

  private

  def check_admin_role
    return if current_user.admin?

    flash[:danger] = t "admins.not_admin"
    redirect_to login_path
  end
end
