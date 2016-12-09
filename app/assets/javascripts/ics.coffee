@init_image_upload_net = ->
  $('.image_upload_button_net').on 'click', ->
    $('.js-image_upload_net').click()

  canvas = $('.js-canvas_net')
  context = canvas[0].getContext('2d')
  preview = $('.image_upload_preview_net')

  $('.set_place_size').on 'click', ->
    draw_net(context)

  $('.js-image_upload_net').on 'change', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        url = e.target.result
        preview.css('display', 'inline-block')
        preview.attr('src', url)
        canvas.attr('width', preview.width())
        canvas.attr('height', preview.height())
        canvas[0].style.backgroundImage = 'url(' + url + ')'
        draw_net(context)
        preview.css('display', 'none')
      reader.readAsDataURL(file)
    else
      alert 'Выберите картинку'

draw_net = (context) ->
  place_width = parseInt($('#ic_place_width')[0].value)
  place_height = parseInt($('#ic_place_height')[0].value)
  image_width = context.canvas.width
  image_height = context.canvas.height
  context.clearRect(0, 0, image_width, image_height);
  for i in [0..image_height] by place_height
    set_line(context, 0, i, image_width, i)
  for i in [0..image_width] by place_width
    set_line(context, i, 0, i, image_height)

set_line = (context, x1, y1, x2, y2) ->
  context.beginPath()
  context.moveTo(x1, y1)
  context.lineTo(x2, y2)
  context.stroke()

@init_table = ->
  $(window).on 'resize', ->
    adaptive_table()
  adaptive_table()

adaptive_table = () ->
  ic = $('.ic.main')
  table = $('.js-table')
  table_width = table.width()
  table_height_old = table.height()
  rel = ic.width() / table_width
  table_height_new = table_height_old * rel
  table.css('transform', 'scale(' + rel + ',' + rel + ')')
  table.css('margin-left', (ic.width() - table_width)/2.0 + 'px')
  table.css('margin-top', (table_height_new - table_height_old)/2.0 + 'px')
  ic.height(table_height_new + 'px')
  table.css('visibility', 'visible')
