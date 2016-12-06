$ ->
  init_image_upload() if $('.js-image_upload').length
  init_image_upload_net() if $('.js-image_upload_net').length
  true
