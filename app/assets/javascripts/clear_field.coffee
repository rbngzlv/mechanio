jQuery ->
  $('.clear-field').click ->
    $(this).siblings('input').val('')
