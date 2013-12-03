jQuery ->
  $('.tree span').click ->
    el = $(this)
    if el.siblings('ul').length == 0
      $.get('/ajax/regions', id: el.data('region-id'))
        .success (html) ->
          unless html == ''
            el.after(html)
            $(el.parent('li')).subtree()
