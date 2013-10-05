angular.module('filters', []).filter 'currency', ->
  (number, currencyCode) ->
    accounting.formatMoney(number, '$', 2)
