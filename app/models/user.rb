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

  def set_query
    tags = self.comedy_tags.pluck(:name)
    keywords = self.keywords.pluck(:name)
    query_elements = []
    query_elements.concat(tags) if tags.present?
    query_elements.concat(keywords) if keywords.present?
    query = query_elements.join(" ")
  end

  def self.take_ranking
    joins(:alarms)
      .where(alarms: { is_successful: true,
                       wake_up_time: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month },
             is_displayed: true)
      .group(:id)
      .select('users.*, COUNT(alarms.id) AS alarm_count')
      .order('alarm_count DESC')
  end

  def reset_comedy_tags_and_keywords
    user_comedy_tags.destroy_all
    keywords.destroy_all
  end

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
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
end
