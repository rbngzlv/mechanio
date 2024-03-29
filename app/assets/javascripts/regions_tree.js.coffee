$ = jQuery

$.fn.extend
  tree: ->
    this.children('ul').attr('role', 'tree').find('ul').attr('role', 'group')
    this.find('li:has(ul)').subtree()
    this.find(':checked').parents('li').show()

    this.on 'click', ':checkbox', (e) ->
      $('#regions-progress', '#regions-error').hide()
      mechanic_id = $('#mechanic_id').val()
      checked = this.checked
      el = $(this).parent()
      $.ajax
        url: "/admins/mechanics/#{mechanic_id}/regions",
        type: 'PUT',
        data: { region_id: el.data('region-id'), toggle: checked },
        success: (html) ->
          $('#regions-progress').show().delay(1000).fadeOut()
        error: (xhr, error, e) ->
          $('#regions-error').show()

      for cb in el.parent().find('li :checkbox')
        cb.checked = checked

  subtree: ->
    this.addClass('parent_li').attr('role', 'treeitem').on 'click', 'i', (e) ->
      el = $(this).parent()
      children = el.parent('li.parent_li').find(' > ul > li')
      if children.is(':visible')
        children.hide()
        $(this).addClass('icon-plus-sign').removeClass('icon-minus-sign')
      else
        children.show()
        $(this).addClass('icon-minus-sign').removeClass('icon-plus-sign')

      if el.siblings('ul').length == 0
        el.load_subtree()

      e.stopPropagation()

  load_subtree: ->
    el = this
    mechanic_id = $('#mechanic_id').val()
    $.get("/admins/mechanics/#{mechanic_id}/regions/subtree", region_id: el.data('region-id'))
      .success (html) ->
        el.after(html).parent('li').subtree() unless html == ''
    

jQuery ->
  $('.tree').tree()
