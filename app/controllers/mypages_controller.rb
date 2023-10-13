class MypagesController < ApplicationController
  def mypage
    @next_wake_up = Alarm.find_by(user_id: current_user.id, is_successful: nil)
    @alarms = Alarm.where(user_id: current_user.id)
    binding.pry
  end
end
