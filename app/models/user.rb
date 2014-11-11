class User < ActiveRecord::Base
  has_merit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :omniauthable, :omniauth_providers => [:twitter]

  has_many :image_annotations

  has_many :annotated_images,  -> { uniq }, :through => :image_annotations, :source => :image

  has_many :achievement_notifications
end
