class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :alarms, dependent: :destroy
  has_many :user_comedy_tags
  has_many :comedy_tags, through: :user_comedy_tags
end
