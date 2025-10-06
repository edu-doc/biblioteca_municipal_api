# frozen_string_literal: true

FactoryBot.define do
  factory :categoria do
    nome { FFaker::Book.genre }
  end
end
