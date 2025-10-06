# frozen_string_literal: true

FactoryBot.define do
  factory :categoria do
    sequence(:nome) { |n| "#{FFaker::Book.genre} #{n}" }
  end
end
