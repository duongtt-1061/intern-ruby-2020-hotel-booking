class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :date_start, :date_end, :price, :room_id,
             :status, :created_at
end
