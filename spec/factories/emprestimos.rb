# frozen_string_literal: true

FactoryBot.define do
  factory :emprestimo do
    association :livro
    association :usuario
    association :bibliotecario

    data_emprestimo { FFaker::Date.between(14.days.ago, Date.today) }
    data_limite_devolucao { FFaker::Date.between(Date.today, 14.days.from_now) }
    data_devolucao { nil }
    contador_renovacao { 0 }
  end
end
