class Comment < ApplicationRecord
	belongs_to :post
	belongs_to :user

	validates :text, :user_id, :post_id, presence: true
end
