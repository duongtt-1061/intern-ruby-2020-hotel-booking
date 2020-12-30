class OrderMailer < ApplicationMailer
  def create_order order_id
    @order = Order.find_by id: order_id
    @user = User.find_by id: @order.user_id
    mail to: @user.email, subject: t("subject_mail_order_new")
  end
end
