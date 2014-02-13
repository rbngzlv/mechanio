app = angular.module('mechanio.models')

app.factory 'Part', ['Itemable', (Itemable) ->
  class Part extends Itemable
    total: ->
      @itemable.quantity * @itemable.unit_cost || 'pending'
]
