class Place < ActiveRecord::Base
  belongs_to :ic
  has_attached_file :image, default_url: '/images/missing.png'
  validates :image, attachment_presence: true
  validates_attachment_content_type :image,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width,
    :r_component, :g_component, :b_component,
    :pre_height, :pre_width

  extend Enumerize
  enumerize :state, in: [:new, :crop_edit, :color_edit, :draft, :published], :default => :new

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
    img.write(image.path)
    svg_save
  end

  def svg_save
    unless r_component == '1' && g_component == '1' && b_component == '1'
      svg_string = "
            <svg height='#{height}' width='#{width}'>
              <defs>
                <filter id='fp1'>
                  <feComponentTransfer>
                    <feFuncR slope='#{r_component}' type='linear'></feFuncR>
                    <feFuncG slope='#{g_component}' type='linear'></feFuncG>
                    <feFuncB slope='#{b_component}' type='linear'></feFuncB>
                    <feFuncA type='identity'></feFuncA>
                  </feComponentTransfer>
                </filter>
              </defs>
              <image filter='url(#fp1)' height='100%' width='100%' xlink:href='#{image.path}'></image>
            </svg>"
      file = File.new('svg_temp.svg', 'w')
      File.write(file, svg_string)
      system("convert '#{file.path}' '#{image.path}'")
      file.close
      File.delete(file)
    end
  end

  def width
    FastImage.size(image.path)[0]
  end

  def height
    FastImage.size(image.path)[1]
  end
end
