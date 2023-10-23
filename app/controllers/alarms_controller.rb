class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:edit, :update, :destroy]

  def mypage
    Alarm.set_false_to_is_successful(current_user)
    @last_alarm = Alarm.where.not(is_successful: nil)
                  .where(user_id: current_user.id)
                  .order(wake_up_time: :desc)
                  .first
    @alarm = Alarm.find_by(user_id: current_user.id, wake_up_time: Date.today.beginning_of_day..Date.tomorrow.end_of_day, is_successful: nil)
    @alarms = Alarm.where(user_id: current_user.id)
  end

  def new
    @alarm = Alarm.new
    @alarm.wake_up_time = Time.now.tomorrow.beginning_of_day
  end

  def create
    @alarm = current_user.alarms.new(alarm_params)
    if @alarm.save
      redirect_to mypage_path, notice: 'アラームが正常に登録されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @alarm.update(alarm_params)
      redirect_to mypage_path, notice: 'アラームが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @alarm.destroy
    redirect_to mypage_path, notice: 'アラームが正常に削除されました。'
  end

  private

  def set_alarm
    @alarm = current_user.alarms.find(params[:id])
  end

  def alarm_params
    params.require(:alarm).permit(:wake_up_time, :custom_video_url)
  end
end
