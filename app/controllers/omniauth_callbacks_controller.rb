class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line = basic_action

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
      existing = false
      existing = true if @profile.persisted?
      if @profile.email.blank?
        email = @omniauth["info"]["email"] || "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
        @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email:,
                                                name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
      end
      @profile.set_values(@omniauth)
      sign_in(:user, @profile)
    end

    if existing
      flash[:notice] = "ログインしました。"
      redirect_to mypage_path
    else
      flash[:notice] = "新規登録が完了しました。"
      redirect_to new_preference_path(current_user)
    end
  end

  def fake_email(_uid, _provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
