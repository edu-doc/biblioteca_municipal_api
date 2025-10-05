# frozen_string_literal: true

class Bibliotecario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :email, uniqueness: true

  before_create :gerar_senha_provisoria

  private

  def gerar_senha_provisoria
    self.senha_provisoria = SecureRandom.hex(8)
  end
end
