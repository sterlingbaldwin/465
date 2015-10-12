class Reference < ActiveRecord::Base
  	belongs_to :topic
	validates:url, presence: true
end
