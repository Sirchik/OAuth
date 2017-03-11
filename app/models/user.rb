class User < ApplicationRecord
  has_many :omniauth_providers, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :github]


  def self.from_omniauth(auth)
    @provider = OmniauthProvider.from_omniauth(auth)
    if @provider == nil || @provider.user == nil
      @provider.destroy unless @provider == nil  
      user = where(email: auth.info.email).first_or_create do |user|
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name if user.name.blank?
        user.image = auth.info.image if user.image.blank?
      end
      user.omniauth_providers.create(provider: auth.provider, uid: auth.uid)
      user
    else
      @provider.user
    end
  end

  # def self.new_with_session(params, session)
  # 	super.tap do |user|
  # 		if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
  # 			user.email = data['email'] if user.email.blank?
  # 		end
  # 	end
  # end
end
