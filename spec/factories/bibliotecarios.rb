# frozen_string_literal: true

FactoryBot.define do
  factory :bibliotecario do
    email { FFaker::Internet.email }
    nome { FFaker::Name.name }
    senha_provisoria { FFaker::Internet.password }
  end
end
