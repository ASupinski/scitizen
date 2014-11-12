class User < ActiveRecord::Base
  has_merit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :omniauth_providers => [:twitter, :facebook]

  has_many :image_annotations

  has_many :annotated_images,  -> { uniq }, :through => :image_annotations, :source => :image

  has_many :achievement_notifications

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid)
    if user.nil? 
      User.new(
        provider = auth.provider,
        password = Devise.friendly_token[0,20],
        email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
        uid: auth.uid
      )
      user.skip_confirmation!
	  user.save!
	end
	user
  end
end
