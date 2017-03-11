class OmniauthProvider < ApplicationRecord
	belongs_to :user

  def self.from_omniauth(auth)
    OmniauthProvider.where(provider: auth.provider, uid: auth.uid).first
  end

end
