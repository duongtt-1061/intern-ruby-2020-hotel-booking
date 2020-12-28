class OrderWorker
  include Sidekiq::Worker

  def perform order_id
    OrderMailer.create_order(order_id).deliver_now
  end
end
