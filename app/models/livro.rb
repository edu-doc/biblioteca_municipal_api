# frozen_string_literal: true

class Livro < ApplicationRecord
  belongs_to :categoria

  enum :status, { disponivel: 0, emprestado: 1 }

  validates :titulo, :autor, :status, presence: true
end
