class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :is_displayed, inclusion: { in: [true, false] }

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

  mount_uploader :image, ImageUploader

  def set_query
    tags = comedy_tags.pluck(:name)
    keywords = self.keywords.pluck(:name)
    query_elements = []
    query_elements.concat(tags) if tags.present?
    query_elements.concat(keywords) if keywords.present?
    query_elements.join(" ")
  end

  def self.set_ranking
    joins(:alarms)
      .where(alarms: { is_successful: true,
                       wake_up_time: Time.zone.today.all_month },
             is_displayed: true)
      .group(:id)
      .select('users.*, COUNT(alarms.id) AS alarm_count')
      .order('alarm_count DESC')
  end

  def reset_comedy_tags_and_keywords
    user_comedy_tags.destroy_all
    keywords.destroy_all
  end

  def count_wake_up_this_month
    alarms.where(is_successful: true, wake_up_time: Time.zone.today.all_month).count
  end

  def count_total_wake_up
    alarms.where(is_successful: true).count
  end

  def count_consecutive_wake_up
    count = 0
    today = Time.current.to_date
    yesterday = 1.day.ago.to_date
    alarms = self.alarms.order(wake_up_time: :desc)
    latest_time = alarms.first&.wake_up_time&.to_date

    return count if latest_time.nil? || (latest_time != today && latest_time != yesterday)

    count += 1

    alarms.each_cons(2) do |prev_alarm, alarm|
      prev_date = prev_alarm.wake_up_time.to_date
      date = alarm.wake_up_time.to_date
      next if prev_date == date
      break unless prev_date - 1.day == date

      count += 1
    end

    count
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
    save!
  end
end
