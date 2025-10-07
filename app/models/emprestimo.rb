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

  def registrar_devolucao!
    self.class.transaction do
      update!(data_devolucao: Time.current)
      livro.disponivel!

      if data_devolucao > data_limite_devolucao

        dias_atraso = (data_devolucao.to_date - data_limite_devolucao.to_date).to_i
        valor_multa = dias_atraso * 1.00

        ::Multum.create!(emprestimo: self, valor: valor_multa)
      end
    end
  end
end
