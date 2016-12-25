class UsersController < Devise::OmniauthCallbacksController
  def vkontakte
    @user = User.find_for_vkontakte_oauth request.env["omniauth.auth"]
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_path
    end
  end
end
