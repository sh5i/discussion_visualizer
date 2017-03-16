class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend Enumerize
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many  :comments
  has_many  :edges
  has_many  :tags
  has_many  :logs

  enumerize :role,  in: [:admin, :general], default: :general,  predicates: true
end
