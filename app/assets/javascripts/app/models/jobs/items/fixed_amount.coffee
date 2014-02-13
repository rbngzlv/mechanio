app = angular.module('mechanio.models')

app.factory 'FixedAmount', ['Itemable', (Itemable) ->
  class FixedAmount extends Itemable
    total: ->
      @itemable.cost || 'pending'
]
