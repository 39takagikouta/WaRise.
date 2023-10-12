class Alarm < ApplicationRecord
  belongs_to :user

  def self.tomorrow_wake_up_for(user)
    current_time = Time.zone.now
    beginning_of_day = current_time.beginning_of_day
    end_of_day = current_time.end_of_day
    where(user: user).where('wake_up_time > ? AND wake_up_time <= ?', beginning_of_day, end_of_day + 1.day).first
  end
end
