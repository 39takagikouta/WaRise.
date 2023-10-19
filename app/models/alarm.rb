class Alarm < ApplicationRecord
  validates :wake_up_time, presence: true

  belongs_to :user
  belongs_to :bootcamp, optional: true

  def start_time
    wake_up_time
  end

  def self.set_false_to_is_successful(user)
    where(
      user_id: user.id,
      is_successful: nil
    ).where("wake_up_time < ?", Time.now - 10.minutes).update_all(is_successful: false)
  end
end
