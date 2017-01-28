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
        $('.jBox-content').css('display', 'block') if $(preview).height() > 400
        $('.jBox-content').css('display', 'table-cell') if $(preview).height() <= 400
        $('.jBox-content').css('vertical-align', 'middle') if $(preview).height() <= 400

      reader.readAsDataURL(file)
    else
      alert 'Выберите картинку'

jcrop_handler = null
init_crop = (preview) ->

  preview.css({'height': '', 'width': '' })
  if $('.jcrop-holder').length
    JcropAPI = preview.data('Jcrop');
    JcropAPI.destroy();

  ratioW = preview.data().ratiow
  ratioH = preview.data().ratioh

  $('#place_pre_width').val(preview.width())
  $('#place_pre_height').val(preview.height())

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
    minSize: [100, 0]
    setSelect: [0, 0, ratioW * 10, ratioH * 10]

  $('.jcrop-holder').children().first().children().first().children().first().css('visibility', 'hidden')

set_crop_preview = (c) ->
  preview_wrapper = $('.svg_preview_wrapper')
  preview_img = $('.filterPlaceSmall')
  cropping_image = $('.js-image_wrapper')
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
  set_rgb hexToRgb("333333")

@init_mini_color = ->
  $('.mini_colors_input').minicolors
    inline: true
    change: (hex) ->
      set_rgb hexToRgb(hex)

set_rgb = (rgb) ->
  $('.filter_r').attr('slope', rgb.r*5/255)
  $('.filter_g').attr('slope', rgb.g*5/255)
  $('.filter_b').attr('slope', rgb.b*5/255)
  $('#place_r_component').attr('value', rgb.r*5/255)
  $('#place_g_component').attr('value', rgb.g*5/255)
  $('#place_b_component').attr('value', rgb.b*5/255)

hexToRgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  r: parseInt(result[1], 16)
  g: parseInt(result[2], 16)
  b: parseInt(result[3], 16)
