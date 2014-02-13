app = angular.module('mechanio.models')

app.factory 'Repair', ['Task', (Task) ->
  class Repair extends Task
    heading: ->
      @title || 'Repair'
]
