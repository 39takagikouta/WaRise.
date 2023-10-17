class PreferencesController < ApplicationController
  def new
    @preference_form = PreferenceForm.new
    @comedy_tags = ComedyTag.all
  end

  def create
    @preference_form = PreferenceForm.new(preference_params)
    binding.pry
    if @preference_form.save(@preference_form, current_user)
      binding.pry
      redirect_to mypage_path, notice: '嗜好性が登録されました'
    else
      binding.pry
      @comedy_tags = ComedyTag.all
      render :new
    end
  end

  def edit
    @form = PreferenceForm.new
    @user_comedy_tag = current_user.comedy_tags
    @user_keywords = current_user.keywords
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
    params.require(:preference_form).permit(
      :before_split_keyword_names,
      :min_video_length_minutes,
      :min_video_length_seconds,
      :max_video_length_minutes,
      :max_video_length_seconds,
      comedy_tag_ids: []
    )
  end

end
