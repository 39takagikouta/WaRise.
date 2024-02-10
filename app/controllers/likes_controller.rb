class LikesController < ApplicationController
  def create
    current_user.likes.create(alarm_id: params[:alarm_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.likes.find_by(alarm_id: params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end
end
