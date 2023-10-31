class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :ranking]

  include YoutubeApi

  def mypage
    Alarm.set_false_to_is_successful(current_user)
    @last_alarm = Alarm.where.not(is_successful: nil)
                  .where(user_id: current_user.id)
                  .order(wake_up_time: :desc)
                  .first
    @alarm = Alarm.find_by(user_id: current_user.id, wake_up_time: Time.zone.today.beginning_of_day..Time.zone.tomorrow.end_of_day,
                           is_successful: nil)
    @alarms = Alarm.where(user_id: current_user.id)
  end

  def new
    @alarm = Alarm.new
    @alarm.wake_up_time = Time.zone.now.tomorrow.beginning_of_day
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

  def recommend
    @alarm = Alarm.find_by(user_id: current_user.id, wake_up_time: Time.zone.today.beginning_of_day..Time.zone.tomorrow.end_of_day,
                           is_successful: nil)

    if @alarm.custom_video_url.present?
      video_id = extract_video_id_from_url(@alarm.custom_video_url)
      @item = OpenStruct.new(id: OpenStruct.new(video_id: video_id))
    else
      query = current_user.set_query
      @search_results = find_videos(query, current_user)
      @item = @search_results.items.reject { |item| current_user.viewed_videos.pluck(:video_id).include?(item.id.video_id) }.first
    end

    unless @item
      redirect_to mypage_path, alert: '申し訳ありません。設定していただいた検索ワードと動画の時間でレコメンドできる動画が無くなりました。検索ワードか時間、またはその両方を変更してください。'
    end
  end

  def index
    @alarms = Alarm.joins(:user)
                   .where(users: { is_displayed: true }, is_successful: true)
                   .reverse_order
                   .page(params[:page])
  end

  def ranking
    @users = User.joins(:alarms)
                 .where(alarms: { is_successful: true,
                                  wake_up_time: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month }, is_displayed: true)
                 .group(:id)
                 .select('users.*, COUNT(alarms.id) AS alarm_count')
                 .order('alarm_count DESC')
  end

  private

    def set_alarm
      @alarm = current_user.alarms.find(params[:id])
    end

    def extract_video_id_from_url(url)
      if url.include?("youtube.com")
        url.split("v=").last.split("&").first
      elsif url.include?("youtu.be")
        url.split("/").last.split("?").first
      end
    end

    def alarm_params
      params.require(:alarm).permit(:wake_up_time, :custom_video_url)
    end
end
