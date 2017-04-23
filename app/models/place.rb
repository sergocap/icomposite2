class Place < ActiveRecord::Base
  belongs_to :ic
  belongs_to :user
  has_attached_file :image, default_url: '/images/missing_place.png'
  validates :image, attachment_presence: true
  validates_attachment_content_type :image,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width,
    :hex_component, :r_component, :g_component, :b_component,
    :pre_height, :pre_width

  def process_image
    img = Magick::Image.read(image.path)[0]
    img.resize!(pre_width.to_f, pre_height.to_f, Magick::LanczosFilter, 1.0)
    img.crop!(crop_x.to_f, crop_y.to_f, crop_width.to_f, crop_height.to_f, true) if crop_height != '0' && crop_width != '0'
    target_width = 120
    if crop_width.to_f > target_width
      resize_f = crop_width.to_f * 1.0 / target_width
      target_height = crop_height.to_f / resize_f
      img.resize!(target_width, target_height, Magick::LanczosFilter, 1.0)
    end
    img = svg_save(img)
    img.write(image.path)
  end

  def svg_save(img)
    color_str = "rgb(#{r_component},#{g_component},#{b_component})"
    rect = Magick::Image.new(img.columns, img.rows) { self.background_color = color_str }
    img.composite(rect, 0, 0, Magick::MultiplyCompositeOp)
  end

  def width
    FastImage.size(image.path)[0]
  end

  def height
    FastImage.size(image.path)[1]
  end
end
