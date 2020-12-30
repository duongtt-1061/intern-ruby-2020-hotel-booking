FactoryBot.define do
  factory :user do
    email {Faker::Internet.unique.email}
    name {Faker::Name.unique.name}
    password {"123456"}
    role {0}
    created_at {Faker::Date.between(from: "2019-11-23", to: "2020-01-25")}
    confirmed_at {"2020-12-22 09:18:16"}
    confirmation_sent_at {"2020-12-22 09:16:46"}
  end
end
