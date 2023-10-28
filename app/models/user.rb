class User < ApplicationRecord

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :is_displayed, presence: :true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]


  has_many :alarms, dependent: :destroy
  has_many :user_comedy_tags, dependent: :destroy
  has_many :comedy_tags, through: :user_comedy_tags
  has_many :viewed_videos, dependent: :destroy
  has_many :keywords, dependent: :destroy
  has_many :likes, dependent: :destroy

  enum video_length: { any: 0, short: 1, medium: 2, long: 3 }


  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

end
