class User < ActiveRecord::Base
  mount_base64_uploader :photo, PhotoUploader
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  mount_base64_uploader :photo, PhotoUploader
  has_many :wishlists
  has_many :properties
  enum kind: [:user, :admin]
end
