@init_image_upload = ->
  $('.image_upload_button').on 'click', ->
    $('.js-image_upload').click()

  preview = $('.image_upload_preview')
  $('.js-image_upload').on 'change', (e) ->
    file = $(this).prop('files')[0]
    if file.type.split('/')[0] == 'image'
      reader = new FileReader()
      reader.onload = (e) ->
        url = e.target.result
        preview.attr('src', url)
      reader.readAsDataURL(file)
    else
      alert 'Выберите картинку'

