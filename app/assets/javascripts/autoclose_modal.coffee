jQuery ->
  $('.modal.autoclose').modal('show')
  setTimeout ( ->
    $('.modal.autoclose').modal('hide')
  ), 5000
