class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :is_displayed, presence: :true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :alarms, dependent: :destroy
  has_many :user_comedy_tags, dependent: :destroy
  has_many :comedy_tags, through: :user_comedy_tags
  has_many :viewed_videos, dependent: :destroy
  has_many :keywords, dependent: :destroy

end
