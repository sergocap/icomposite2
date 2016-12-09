class OriginalPlace < ActiveRecord::Base
  belongs_to :ic
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  after_create :create_image

  def create_image
    img = Magick::Image.read(ic.image.path)[0]
    w = ic.place_width
    x1 = w * x
    h = ic.place_height
    y1 = h * y
    img.crop!(x1, y1, w, h, true)
    file = Tempfile.new(['image', '.png'])
    img.write(file.path)
    update_attribute(:image, file)
    file.close
    file.unlink
  end
end
