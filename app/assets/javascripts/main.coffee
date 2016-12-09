$ ->
  init_image_upload()
  init_image_upload_net() if $('.js-image_upload_net').length
  init_table() if $('.js-table').length
  init_ajax_place_new() if $('.ajax-place_new').length
  true
