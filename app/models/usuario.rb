# frozen_string_literal: true

class Usuario < ApplicationRecord
  validates :nome, :cpf, :telefone, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :cpf, uniqueness: { case_sensitive: false }

  validate :cpf_valido

  before_create :cpf_valido
  before_create :gerar_senha_emprestimo

  def gerar_senha_emprestimo
    self.senha = SecureRandom.hex(8)
  end

  private

  def cpf_valido
    return unless cpf.present? && !CPF.valid?(cpf)

    errors.add(:cpf, 'is invalid')
  end
end
