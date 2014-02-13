app = angular.module('mechanio')

app.filter 'cost_or_pending', ->
  (amount) ->
    return 'pending' if amount == 'pending' || parseFloat(amount) == NaN
    return 'free' if amount == 0
    accounting.formatMoney(amount, '$', 2)
