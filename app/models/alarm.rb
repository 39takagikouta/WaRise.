class Alarm < ApplicationRecord
  validates :wake_up_time, presence: true
  validate :must_be_youtube_url
  validate :wake_up_time_minute_must_be_per_ten_minutes

  belongs_to :user
  belongs_to :bootcamp, optional: true
  has_one :viewed_video
  has_many :likes, dependent: :destroy

  def start_time
    wake_up_time
  end

  def self.set_false_to_is_successful(user)
    where(
      user_id: user.id,
      is_successful: nil
    ).where("wake_up_time < ?", Time.now - 10.minutes).update_all(is_successful: false)
  end

  private

  def must_be_youtube_url
    return if custom_video_url.blank?
    unless custom_video_url.include?("youtube.com") || custom_video_url.include?("youtu.be")
      errors.add(:base, "Youtubeの動画以外は登録できません")
    end
  end

  def wake_up_time_minute_must_be_per_ten_minutes
    if wake_up_time && wake_up_time.min % 10 != 0
      errors.add(:base, 'アラームの分数は10分単位でなければなりません')
    end
  end

end
