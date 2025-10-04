# frozen_string_literal: true

class Bibliotecario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :nome, presence: true
  validates :senha_provisoria, presence: true, on: :create
end
