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

  def created_at!
    self.remember_created_at = Time.now
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = if email_is_verified
                auth.info.email
              else
                "#{auth.uid}@#{auth.provider}.com"
              end
      user = User.new(
                provider: auth.provider,
                password: Devise.friendly_token[0,20],
                email:    email,
                uid:      auth.uid
              )
      user.created_at!
	    user.save
	  end
	  user
  end
end
