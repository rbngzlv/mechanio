jQuery ->
  $('.locked-form').each (i, form) ->
    dirty = (input for input in $(form).find('textarea, input:text') when $(input).val() != '')
    errors = $(form).find('.has-error')
    inputs = $(form).find(':input')

    inputs.prop('disabled', true) if dirty.length > 0 && errors.length == 0 && !$(form).hasClass('unlocked')

    $(form).find('.unlock-form').click ->
      inputs.prop('disabled', false)
      return false
