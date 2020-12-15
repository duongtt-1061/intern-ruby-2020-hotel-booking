categories = ["vvip","vip","normal"]
categories.each do |category|
  Category.create!(
    name: category,
    slug: category
  )
end

supplies = ["Air Condition","Heater","Oven mitts","Bed"]
supplies.each do |supply|
  Supply.create!(
    name: supply
  )
end

200.times do |n|
  name = "Room#{n}"
  category_id = Faker::Number.between(from: 1, to: 3)
  price = Faker::Commerce.price(range: 500..1000)
  ward_id = Faker::Number.between(from: 20000, to: 31120)
  max_person = Faker::Number.between(from: 3, to: 20)
  description = Faker::Lorem.paragraphs(number: 1, supplemental: true)
  map = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d31194.656526335482!2d109.18367043955077!3d12.225780700000007!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x317067686a63a527%3A0x2be9aaaa69e2c9f2!2sEvason%20Ana%20Mandara%20Nha%20Trang!5e0!3m2!1sen!2s!4v1606446055503!5m2!1sen!2s"
  address = "Keangnam, Cau Giay, Ha Noi, Vietnam"
  pictures = "paypal2.png"
  Room.create!(
    name: name,
    slug: name,
    category_id: category_id,
    price: price,
    ward_id: ward_id,
    max_person: max_person,
    description: description,
    map: map,
    address: address
  )
end
