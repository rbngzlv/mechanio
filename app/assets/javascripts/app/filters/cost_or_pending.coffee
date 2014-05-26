app = angular.module('mechanio')

app.filter 'formatted_cost', ->
  (amount) ->
    return 'pending' if amount == 'pending' || parseFloat(amount) == NaN
    return 'included' if amount == 0
    accounting.formatMoney(amount, '$', 2)
