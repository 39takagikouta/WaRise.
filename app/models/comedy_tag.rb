class ComedyTag < ApplicationRecord
  has_many :user_comedy_tags
  has_many :users, through: :user_comedy_tags
end
