class Ic < ActiveRecord::Base
  require 'zlib'
  include Zlib
  has_many :places, dependent: :destroy
  has_many :original_places, dependent: :destroy

  has_attached_file :image, default_url: '/images/missing.png', :styles => { :small => "100x100^" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def add_to_project(place)
    ic_img = Magick::Image.read(image.path)[0]
    pl_img = Magick::Image.read(place.image.path)[0]
    pl_img.resize!(place_width, place_height, Magick::LanczosFilter, 1.0)
    ic_img.composite!(pl_img, place_width * place.x, place_height * place.y, Magick::OverCompositeOp)
    ic_img.write(image.path)
    image.reprocess!
    html_reprocess(place)
  end

  def html_reprocess(place)
    html = get_html
    doc = Nokogiri::HTML(html)
    link = doc.css("table tr:nth-child(#{place.y + 1}) td:nth-child(#{place.x + 1}) a")[0]
    link['class'] = 'ajax-place_show'
    href = link['href']
    new_href = href[0, href.index('new')] + place.id.to_s
    link['href'] = new_href
    update_html(doc.to_html)
  end

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
    update_html(html_string)
  end

  def get_html
    Inflate.inflate(read_attribute(:html))
  end

  private
  def update_html(html)
    zip_html = Deflate.deflate(html)
    update_attribute(:html, zip_html.force_encoding('UTF-8'))
  end

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
