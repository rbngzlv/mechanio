app = angular.module('mechanio.models')

app.factory 'Labour', ['Itemable', (Itemable) ->
  class Labour extends Itemable
    constructor: (attrs, hourly_rate) ->
      super
      @itemable.duration_hours   ||= 0
      @itemable.duration_minutes ||= 0
      @itemable.hourly_rate      ||= hourly_rate

    total: ->
      @duration() * @itemable.hourly_rate / 60 || 'pending'

    duration: ->
      hours = +@itemable.duration_hours || 0
      minutes = +@itemable.duration_minutes || 0
      hours * 60 + minutes
]
