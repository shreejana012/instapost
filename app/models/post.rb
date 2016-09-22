class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments, dependent: :destroy
	
	validates :photo, :description, :user_id, presence: true
	mount_uploader :photo, PhotoUploader

end
