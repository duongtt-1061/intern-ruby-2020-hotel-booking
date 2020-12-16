FactoryBot.define do
  factory :room do
    name {Faker::Name.unique.name}
    slug {name}
    price {Faker::Number.decimal(l_digits: 3, r_digits: 3)}
    max_person {2}
    description {"lorems ipsum..."}
    map {"lorems ipsums..."}
    address {"lorems ipsums..."}
    created_at {Faker::Date.between(from: "2019-11-23", to: "2020-01-25")}
  end
end
