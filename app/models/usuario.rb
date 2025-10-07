# frozen_string_literal: true

class Usuario < ApplicationRecord

  has_many :emprestimos

  validates :nome, :cpf, :telefone, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :cpf, uniqueness: { case_sensitive: false }

  validate :cpf_valido

  before_create :cpf_valido
  before_create :gerar_senha_emprestimo

  after_create :enviar_email_com_senha

  def gerar_senha_emprestimo
    self.senha = SecureRandom.hex(4)
  end

  private

  def cpf_valido
    return unless cpf.present? && !CPF.valid?(cpf)

    errors.add(:cpf, 'is invalid')
  end

  def enviar_email_com_senha
    UsuarioMailer.enviar_senha_emprestimo(self).deliver_now
  end
end
