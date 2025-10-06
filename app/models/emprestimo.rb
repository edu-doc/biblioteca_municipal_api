# frozen_string_literal: true

class Emprestimo < ApplicationRecord
  belongs_to :livro
  belongs_to :usuario
  belongs_to :bibliotecario

  validates :data_emprestimo, :data_limite_devolucao, presence: true

  after_create :marcar_livro_como_emprestado

  def marcar_livro_como_emprestado
    livro.emprestado!
  end
end
