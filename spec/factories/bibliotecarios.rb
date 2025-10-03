# frozen_string_literal: true

FactoryBot.define do
  factory :bibliotecario do
    email { FFaker::Internet.email }
    password { '123456' }
  end
end
