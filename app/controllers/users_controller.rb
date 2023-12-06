class UsersController < ApplicationController
  def show; end

  def toggle_display
    current_user.toggle(:is_displayed).save
    redirect_to user_path(current_user), notice: '表示設定を変更しました。'
  end
end

private

def user_params
  params.require(:user).permit(:is_displayed)
end
