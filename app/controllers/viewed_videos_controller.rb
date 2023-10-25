class ViewedVideosController < ApplicationController
  def create
    @viewed_video = ViewedVideo.new(viewed_video_params)

    if @viewed_video.save
      case params[:redirect_to]
      when 'mypage'
        redirect_to mypage_path
      when 'recommend'
        binding.pry
        redirect_to recommend_path
      else
        flash[:error] = '不明なリダイレクト先です'
        redirect_to mypage_path
      end
    else
      flash[:error] = '動画情報の保存に失敗しました'
      redirect_to mypage_path
    end
  end

  private

  def viewed_video_params
    {
      video_id: params[:format],
      user_id: current_user.id
    }
  end
end
