# frozen_string_literal: true

FactoryBot.define do
  factory :multum do
    association :emprestimo
    valor { FFaker::Random.rand(5.0..100.0).round(2) }
    status { :pendente }
    data_pagamento { FFaker::Time.between(30.days.ago, Time.now) }
  end
end
