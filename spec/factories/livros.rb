# frozen_string_literal: true

FactoryBot.define do
  factory :livro do
    titulo { FFaker::Book.title }
    autor { FFaker::Book.author }
    status { :disponivel }
    observacoes { FFaker::Lorem.sentence }
    association :categoria
  end
end
