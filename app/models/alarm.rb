class Alarm < ApplicationRecord
  validates :wake_up_time, presence: true

  belongs_to :user

  def start_time
    wake_up_time
  end
end
