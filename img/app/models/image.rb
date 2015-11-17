class Image < ActiveRecord::Base
  belongs_to :user

  has_many :image_users, dependent: :destroy
  has_many :tags, dependent: :destroy

  mount_uploader :attachment, UploadedFileUploader
end
