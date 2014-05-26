jQuery ->
  $('.js-update-avatar').each (i, upload) ->
    field = $(upload).data('field')
    $(upload).click -> $(field).click()
    $(field).on 'change', -> this.form.submit()
