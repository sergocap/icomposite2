# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@init_ajax_place_new = ->
  $('.ajax-place_new').on 'ajax:success', (e, data) ->
    myModal = new jBox('Modal', onClose: destroy_jBox, content: data)
    myModal.open()
    init_mini_color()
    $('.jBox-wrapper.jBox-Modal').center()

destroy_jBox = () ->
  $('.jBox-wrapper.jBox-Modal.jBox-Default').remove()
