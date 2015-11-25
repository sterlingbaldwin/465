class Image < ActiveRecord::Base
  belongs_to user
  has_many tags, dependent: :destroy
  has_many image_users, dependent: :destroy
end
