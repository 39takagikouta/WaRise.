class Alarm < ApplicationRecord
  validates :wake_up_time, presence: true
  validate :must_be_youtube_url

  belongs_to :user
  belongs_to :bootcamp, optional: true
  has_one :viewed_video, dependent: :destroy
  has_many :likes, dependent: :destroy

  def start_time
    wake_up_time
  end

  def self.set_false_to_is_successful(user)
    where(
      user_id: user.id,
      is_successful: nil
    ).where("wake_up_time < ?", 10.minutes.ago).find_each do |alarm|
      alarm.update(is_successful: false)
    end
  end

  def self.find_last_alarm(user)
    where.not(is_successful: nil)
      .where(user_id: user.id)
      .order(wake_up_time: :desc)
      .first
  end

  # def self.find_next_alarm(user)
  #   find_by(user_id: user.id, wake_up_time: Time.zone.today.beginning_of_day..Time.zone.tomorrow.end_of_day, is_successful: nil)
  # end

  def self.find_successful_alarms(user, page)
    where(user_id: user.id, is_successful: true)
      .reverse_order
      .page(page)
  end

  def must_be_youtube_url
    return if custom_video_url.blank?

    errors.add(:base, "Youtubeの動画以外は登録できません") unless custom_video_url.include?("youtube.com") || custom_video_url.include?("youtu.be")
  end
end
