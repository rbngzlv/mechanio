jQuery ->
  $('.rating.editable').on 'click', 'span', (e) ->
    $(this).siblings().removeClass('active')
    $(this).toggleClass('active')
    $(this).siblings('input').val $(this).data('value')

    if $('.rating.editable .active').size() == 5
      $('.feedback-submit').removeProp('disabled')