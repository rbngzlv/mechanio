app = angular.module('mechanio')

app.filter 'cost_or_pending', ->
  (amount) ->
    if parseFloat(amount) > 0 then accounting.formatMoney(amount, '$', 2) else 'pending'
