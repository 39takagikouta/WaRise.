class PreferencesController < ApplicationController
  def new
    @preference_form = PreferenceForm.new(user_id: current_user.id)
    @comedy_tags = ComedyTag.all
  end

  def create
    @preference_form = PreferenceForm.new(preference_params)
    if @preference_form.save
      redirect_to mypage_path, notice: '嗜好性が登録されました'
    else
      @comedy_tags = ComedyTag.all #必要か？
      render :new
    end
  end

  def edit
    @form = PreferenceForm.new(user_id: current_user.id)
    @comedy_tags = ComedyTag.all
  end

  def update
    @form = PreferenceForm.new(preference_params)
    if @form.save
      redirect_to user_path(current_user), notice: '嗜好性が更新されました'
    else
      @comedy_tags = ComedyTag.all
      render :edit
    end
  end

  private

  def preference_params
    params.require(:preference_form).permit(:user_id, :min_video_length, :max_video_length, comedy_tag_ids: [], keyword_names: '')
  end

end
