class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line = basic_action

  def failure
    redirect_to root_path, alert: 'LINEログインに失敗しました。'
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
      existing = @profile.persisted?
      if @profile.email.blank?
        email = @omniauth["info"]["email"] || "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
        @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email:,
                                                name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
        image_url = @omniauth["info"]["image"].presence || "app/assets/images/default.png"
        @profile.remote_image_url = image_url

        @profile.save
      end

      # if existing && (@profile.name != @omniauth["info"]["name"] || @profile.image != @omniauth["info"]["image"])
      #   @profile.update(
      #     name: @omniauth["info"]["name"],
      #     image: @omniauth["info"]["image"]
      #   )
      # end

      @profile.set_values(@omniauth)
      sign_in(:user, @profile)

      if existing
        flash[:notice] = "ログインしました。"
        redirect_to mypage_path
      else
        flash[:notice] = "新規登録が完了しました。"
        redirect_to new_preference_path
      end
    else
      failure
    end
  end

  def fake_email(_uid, _provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
