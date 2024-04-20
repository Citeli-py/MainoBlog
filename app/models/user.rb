class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:name]

  # Incluir nome no nosso usuário
  validates :name, presence: true , uniqueness: true
  has_many :posts

end
