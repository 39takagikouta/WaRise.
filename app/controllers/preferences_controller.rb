class PreferencesController < ApplicationController
  def new
    @preference_form = PreferenceForm.new
    @comedy_tags = ComedyTag.all
  end

  def edit
    @preference_form = load_current_user_preferences
    @comedy_tags = ComedyTag.all
  end

  def create
    @preference_form = PreferenceForm.new(preference_params)
    if @preference_form.save(@preference_form, current_user)
      redirect_to mypage_path, notice: '登録が完了しました。早速アラームを作成してみましょう！'
    else
      @comedy_tags = ComedyTag.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @preference_form = PreferenceForm.new(preference_params)
    if @preference_form.save(@preference_form, current_user)
      redirect_to user_path(current_user), notice: 'お笑い嗜好性が更新されました'
    else
      @comedy_tags = ComedyTag.all
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_current_user_preferences
    keywords_names = current_user.keywords.present? ? current_user.keywords.pluck(:name).join('、') : nil

    PreferenceForm.new(
      comedy_tag_ids: current_user.user_comedy_tags.pluck(:comedy_tag_id),
      before_split_keyword_names: keywords_names,
      video_length: User.video_lengths[current_user.video_length]
    )
  end

  def preference_params
    params.require(:preference_form).permit(
      :before_split_keyword_names,
      :video_length,
      comedy_tag_ids: []
    )
  end
end
