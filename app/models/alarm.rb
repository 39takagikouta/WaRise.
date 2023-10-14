class Alarm < ApplicationRecord
  belongs_to :user

  def start_time
    wake_up_time
  end
end
