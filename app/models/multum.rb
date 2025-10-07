# frozen_string_literal: true

class Multum < ApplicationRecord
  belongs_to :emprestimo

  enum :status, { pendente: 0, pago: 1 }

  validates :valor, :status, presence: true
end
