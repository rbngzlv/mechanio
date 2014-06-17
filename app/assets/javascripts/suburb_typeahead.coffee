  jQuery ->
    datasource = new Bloodhound
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace(d.name)
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/ajax/suburbs?name=%QUERY'

    datasource.initialize()

    previous_datum = null
    selected_datum = null

    $('.suburb-typeahead').typeahead({},
      displayKey: 'display_name',
      source: datasource.ttAdapter()

    ).on('typeahead:selected typeahead:autocompleted', (e, datum) ->
      selected_datum = datum

    ).on('typeahead:opened', (e) ->
      previous_datum = selected_datum if selected_datum
      selected_datum = null

    ).on('typeahead:closed', (e) ->
      if $(e.target).typeahead('val') == ''
        selected_datum = null
        previous_datum = null

      if selected_datum == null
        value = if previous_datum then previous_datum.display_name else ''
        $(e.target).typeahead('val', value)
    )
