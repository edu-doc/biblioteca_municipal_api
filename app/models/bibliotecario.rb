# frozen_string_literal: true

class Bibliotecario < ApplicationRecord

  enum :role, { default: 0, admin: 1 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :token, uniqueness: true

  validates :nome, presence: true

  validates :senha_provisoria, presence: true, on: :create

  before_validation :definir_senha_inicial_do_devise, on: :create

  before_create :gerador_token_autenticacao

  def definir_senha_inicial_do_devise
    return unless password.blank? && senha_provisoria.present?

    self.password = senha_provisoria
  end

  def gerador_token_autenticacao
    loop do
      self.token = Devise.friendly_token
      break unless self.class.exists?(token: token)
    end
  end
end
