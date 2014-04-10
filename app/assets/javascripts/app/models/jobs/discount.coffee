app = angular.module('mechanio.models')

app.factory 'Discount', () ->
  class Discount

    constructor: (attrs) ->
      @[key] = value for key, value of attrs

    discount_amount: (amount) ->
      if @discount_type == 'percent'
        amount * @discount_value / 100
      else
        @discount_value
