$ = jQuery

$.fn.extend
  tree: ->
    this.children('ul').attr('role', 'tree').find('ul').attr('role', 'group')
    this.find('li:has(ul)').subtree()

  subtree: ->
    this.addClass('parent_li').attr('role', 'treeitem').find(' > span').attr('title', 'Collapse this branch').on 'click', (e) ->
      children = $(this).parent('li.parent_li').find(' > ul > li')
      if children.is(':visible')
        children.hide()
        $(this).attr('title', 'Expand this branch').find(' > i').addClass('icon-plus-sign').removeClass('icon-minus-sign')
      else
        children.show()
        $(this).attr('title', 'Collapse this branch').find(' > i').addClass('icon-minus-sign').removeClass('icon-plus-sign')
      e.stopPropagation()

jQuery ->
  $('.tree').tree()
