class AlarmsController < ApplicationController
  def mypage
    @alarm = Alarm.find_by(user_id: current_user.id, is_successful: nil)
    @alarms = Alarm.where(user_id: current_user.id)
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end
end
