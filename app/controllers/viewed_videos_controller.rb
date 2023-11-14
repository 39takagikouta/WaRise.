class ViewedVideosController < ApplicationController
  def create
    @viewed_video = current_user.viewed_videos.new(video_id: params[:video_id])

    return unless @viewed_video.save

    case params[:redirect_to]
    when 'mypage'
      @alarm = Alarm.find_by(id: params[:alarm_id])
      update_is_successful_and_comment
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

    def update_is_successful_and_comment
      @alarm.update(is_successful: true)
      @alarm.update(alarm_params)
    end

    def alarm_params
      params.require(:alarm).permit(:comment)
    end
end
