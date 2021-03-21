# frozen_string_literal: true

class Authors::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /authors/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    # You need to implement the method below in your model (e.g. app/models/author.rb)
    @author = Author.from_omniauth(request.env["omniauth.auth"])

    if @author.persisted?
      sign_in_and_redirect @author, event: :authentication # this will throw if @author is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_author_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
