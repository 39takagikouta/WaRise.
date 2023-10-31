class ViewedVideosController < ApplicationController
  def create
    @viewed_video = current_user.viewed_videos.new(viewed_video_params)

    return unless @viewed_video.save

    case params[:redirect_to]
    when 'mypage'
      @alarm = Alarm.find_by(id: params[:alarm_id])
      @alarm.update(is_successful: true)
      @viewed_video.update(alarm_id: @alarm.id)
      redirect_to mypage_path
    when 'recommend'
      redirect_to recommend_path
    else
      flash[:error] = '不明なリダイレクト先です'
      redirect_to mypage_path
    end
  end

  private

    def viewed_video_params
      { video_id: params[:video_id] }
    end
end
