app = angular.module('mechanio.models')

app.factory 'Inspection', ['Task', (Task) ->
  class Inspection extends Task
    heading: ->
      @title

    inspection_cost: ->
      80
]
