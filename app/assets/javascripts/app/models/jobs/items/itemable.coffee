app = angular.module('mechanio.models')

app.factory 'Itemable', () ->
  class Itemable
    constructor: (attrs) ->
      @[key] = value for key, value of attrs

    template: ->
      @itemable_type.underscore()

    delete: ->
      @_destroy = true

    isDeleted: ->
      @_destroy == true
