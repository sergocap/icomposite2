@init_image_upload = ->
  $(document.body).on 'click', '.js-image_upload_button', ->
    $('.js-image_input').click()

  $(document.body).on 'change', '.js-image_input', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        url = e.target.result
        preview = $('.js-image_preview')
        preview.attr('src', url)

        init_crop(preview) if $('.place.new').length
        init_svg(preview) if $('.place.new').length

      reader.readAsDataURL(file)
    else
      alert 'Выберите картинку'

init_crop = (preview) ->

  preview.css({'width': '', 'height': ''})
  if $('.jcrop-holder').length
    JcropAPI = preview.data('Jcrop');
    JcropAPI.destroy();

  ratioW = preview.data().ratiow
  ratioH = preview.data().ratioh

  $('#place_pre_width').val($(preview).width())
  $('#place_pre_height').val($(preview).height())

  showCoords = (c) ->
    set_crop_preview(c)
    $('#place_crop_x').val(c.x)
    $('#place_crop_y').val(c.y)
    $('#place_crop_width').val(c.w)
    $('#place_crop_height').val(c.h)

  preview.Jcrop
    aspectRatio: ratioW / ratioH
    onChange: showCoords
    onSelect: showCoords
    allowSelect: false
    minSize: [120, 0]
    setSelect: [0, 0, ratioW * 10, ratioH * 10]

  $('.jcrop-holder').children().first().children().first().children().first().css('visibility', 'hidden')

set_crop_preview = (c) ->
  preview_wrapper = $('.svg_preview_wrapper')
  preview_img = $('.filterPlaceSmall')
  cropping_image = $('.js-image_preview')
  k = preview_wrapper.width() / c.w
  w2 = cropping_image.width() * k
  h2 = cropping_image.height() * k
  x2 = c.x * k
  y2 = c.y * k

  preview_img.css
    width: Math.round(w2) + 'px'
    height: Math.round(h2) + 'px'
    marginLeft: '-' + Math.round(x2) + 'px'
    marginTop: '-' + Math.round(y2) + 'px'
  true

init_svg = (preview) ->
  svg_handler = $('.filterPlace')
  svg_handler.attr('height', $('#place_pre_height').val())
  svg_handler.attr('width', $('#place_pre_width').val())
  svg_image = $('.svg_place_image')
  $(svg_image).attr('xlink:href', preview.attr('src'))
  set_rgb hexToRgb("#ffffff")
  $('#place_hex_component').attr('value', '#ffffff')

@init_mini_color = ->
  $('.mini_colors_input').minicolors
    inline: true
    change: (hex) ->
      set_rgb hexToRgb(hex)
      $('#place_hex_component').attr('value', hex)

set_rgb = (rgb) ->
  r = rgb.r
  g = rgb.g
  b = rgb.b
  $('.rectColored').attr('flood-color', "rgb(#{r},#{g},#{b})")
  $('#place_r_component').attr('value', r)
  $('#place_g_component').attr('value', g)
  $('#place_b_component').attr('value', b)

hexToRgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  r: parseInt(result[1], 16)
  g: parseInt(result[2], 16)
  b: parseInt(result[3], 16)
