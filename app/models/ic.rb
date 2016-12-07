class Ic < ActiveRecord::Base
  has_many :places

  has_attached_file :image, default_url: '/images/missing.png', :styles => { :small => "100x100^" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def count_places_x
    (width / place_width).to_i
  end

  def count_places_y
    (height / place_height).to_i
  end

  def create_html
    crop_image
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    html_string = view.render(
      partial: 'ics/empty_table',
      layout: false,
      locals: { :ic => self })
    update_attribute(:html, html_string)
  end

  private
  def crop_image
    img = Magick::Image.read(image.path)[0]
    h = (img.rows/place_height).to_i * place_height
    w =  (img.columns/place_width).to_i * place_width
    img = img.crop(0, 0, w, h, true)
    file = Tempfile.new([File.basename(image.path), '.jpg'])
    img.write(file.path)
    update_attribute(:image, file)
    update_attributes(:width => w, :height => h)
    image.reprocess!
    file.close
    file.unlink
  end
end
