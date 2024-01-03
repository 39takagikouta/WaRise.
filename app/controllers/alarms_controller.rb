class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :ranking]

  include YoutubeApi

  def mypage
    Alarm.set_false_to_is_successful(current_user)
    @last_alarm = Alarm.find_last_alarm(current_user)
    @alarm = Alarm.find_next_alarm(current_user)
    @alarms = Alarm.where(user_id: current_user.id)
  end

  def index
    @alarms = Alarm.find_successful_alarms(params[:page])
  end

  def new
    @alarm = Alarm.new
  end

  def edit; end

  def create
    @alarms = []
    success = true

    ActiveRecord::Base.transaction do
      alarm_data = params[:alarm][:alarm].reject { |k, _| k == "TEMPLATE_INDEX" }
      alarm_data.each do |_, alarm_attrs|
        alarm = current_user.alarms.new(alarm_attrs_params(alarm_attrs))
        @alarms << alarm
        unless alarm.save
          success = false
          raise ActiveRecord::Rollback
        end
      end
    end

    if success
      @alarms.each do |alarm|
        job = SendNotificationJob.set(wait_until: alarm.wake_up_time).perform_later(alarm)
        alarm.update(job_id: job.provider_job_id)
      end
      redirect_to mypage_path, notice: 'アラームが正常に登録されました。'
    else
      @alarm = @alarms.find { |a| a.errors.any? } || current_user.alarms.new
      render :new
    end
  end

  def update
    if @alarm.update(alarm_params)
      Sidekiq::ScheduledSet.new.find_job(@alarm.job_id).try(:delete) if @alarm.job_id.present?
      job = SendNotificationJob.set(wait_until: @alarm.wake_up_time).perform_later(@alarm)
      @alarm.update(job_id: job.provider_job_id)
      redirect_to mypage_path, notice: 'アラームが正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @alarm.destroy
    redirect_to mypage_path, notice: 'アラームが正常に削除されました。', status: :see_other
  end

  def recommend
    @alarm = Alarm.find_next_alarm(current_user)
    @item = @alarm.custom_video_url.present? ? fetch_custom_video_item : fetch_recommended_video_item

    redirect_to mypage_path, alert: '申し訳ありません。設定していただいた検索ワードと動画の時間でレコメンドできる動画が無くなりました。検索ワードか時間、またはその両方を変更してください。' unless @item
  end

  def ranking
    @users = User.set_ranking
  end

  def new_alarm_fields
    @index = params[:index].to_i
    @alarm = Alarm.new
    render partial: 'alarm_fields', locals: { alarm: @alarm, index: @index }
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

  def fetch_custom_video_item
    video_id = extract_video_id_from_url(@alarm.custom_video_url)
    item = Struct.new(:id)
    item.new(Struct.new(:video_id).new(video_id))
  end

  def fetch_recommended_video_item
    query = current_user.set_query
    search_results = find_videos(query, current_user)
    filter_viewed_videos(search_results)
  end

  def filter_viewed_videos(search_results)
    search_results.items.reject { |item| current_user.viewed_videos.pluck(:video_id).include?(item.id.video_id) }.first
  end

  def alarm_params
    params.require(:alarm).permit(:wake_up_time, :custom_video_url)
  end

  def alarm_attrs_params(alarm_attrs)
    alarm_attrs.permit(:wake_up_time, :custom_video_url)
  end
end
