  jQuery ->
    datasource = new Bloodhound
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace(d.name)
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/ajax/suburbs?name=%QUERY'

    datasource.initialize()

    $('.suburb-typeahead').typeahead({}, {
      displayKey: 'display_name',
      source: datasource.ttAdapter()
    })
