# frozen_string_literal: true

class Emprestimo < ApplicationRecord
  belongs_to :livro
  belongs_to :usuario
  belongs_to :bibliotecario

  MAX_RENOVATIONS = 2

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

  def renovar!
    if data_devolucao.present?
      errors.add(:base, 'Não é possível renovar um empréstimo que já foi devolvido.')
      return false
    end

    if contador_renovacao >= MAX_RENOVATIONS
      errors.add(:contador_renovacao, "Limite de #{MAX_RENOVATIONS} renovações atingido.")
      return false
    end

    novo_limite = self.class.calcular_data_limite(data_limite_devolucao, 15)

    self.class.transaction do
      update!(
        data_limite_devolucao: novo_limite,
        contador_renovacao: contador_renovacao + 1
      )
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def self.data_limite_inicial(data_emprestimo)
    calcular_data_limite(data_emprestimo, 15)
  end

  private

  def self.calcular_data_limite(data_base, dias_uteis_a_somar)
    data_limite = data_base

    while dias_uteis_a_somar.positive?
      data_limite += 1.day
      dias_uteis_a_somar -= 1 if (1..5).cover?(data_limite.wday)
    end

    data_limite.beginning_of_day
  end

end
