app = angular.module('mechanio.models')

app.factory 'ServiceCost', ['Itemable', (Itemable) ->
  class ServiceCost extends Itemable
    total: ->
      @itemable.cost
]
