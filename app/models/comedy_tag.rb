class ComedyTag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :user_comedy_tags, dependent: :destroy
  has_many :users, through: :user_comedy_tags
end
