class Topic < ActiveRecord::Base
	has_many :references, dependent: :destroy

	validates :desciption, presence: true
	validates :title, presence: true
end
