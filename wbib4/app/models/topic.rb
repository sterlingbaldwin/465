class Topic < ActiveRecord::Base
	has_many :references, dependent: :destroy

	validates :description, presence: true
	validates :title, presence: true
end
