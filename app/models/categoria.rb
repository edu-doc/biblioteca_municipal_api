class Categoria < ApplicationRecord

    validates :nome, presence: true
    validates :nome, uniqueness: true

end
