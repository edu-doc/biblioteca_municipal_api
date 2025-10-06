# frozen_string_literal: true

FactoryBot.define do
  factory :usuario do
    nome { FFaker::Name.name }
    cpf { FFaker::IdentificationBR.cpf }
    telefone { FFaker::PhoneNumber.phone_number }
    email { FFaker::Internet.email }
  end
end
