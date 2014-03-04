jQuery ->
  $('.tab-pane:has(.form-group .help-block)').each (i, tab) ->
    link = $("a[href=##{tab.id}]")
    link.tab('show') if i == 0
    link.closest('li').addClass('error')
