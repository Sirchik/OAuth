class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  Devise.omniauth_providers.each{|p| 
    define_method p do
      # byebug
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user = :no_email
        session["devise.#{p.to_s.downcase}_data"] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      else
        if @user.persisted?
          sign_in_and_redirect @user#, :event => :authentification
          set_flash_message(:notice, :success, :kind => OmniAuth::Utils.camelize(p)) if is_navigational_format?
        else
          session["devise.#{p.to_s.downcase}_data"] = request.env['omniauth.auth']
          redirect_to new_user_registration_url
        end
      end
    end
  }


  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  def failure
    super
    redirect_to root_path
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
