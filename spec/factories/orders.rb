FactoryBot.define do
  factory :order do
    date_start {Faker::Date.between(from: "2020-12-01", to: "2020-12-15")}
    date_end {Faker::Date.between(from: "2020-12-16", to: "2020-12-20")}
    price {Faker::Number.decimal(l_digits: 3, r_digits: 3)}
    quantity_person {1}
    status {Settings.status.pendding}
  end
end
