class Place < ActiveRecord::Base
  belongs_to :ic
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
