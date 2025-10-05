# frozen_string_literal: true

class Bibliotecario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :token, uniqueness: true

  before_create :gerar_senha_provisoria

  def gerar_senha_provisoria
    self.senha_provisoria = SecureRandom.hex(8)
  end

  def gerador_token_autenticacao
    loop do
      self.token = Devise.friendly_token
      break unless self.class.exists?(token: token)
    end
  end
end
