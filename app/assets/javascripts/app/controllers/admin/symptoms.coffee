app = angular.module('mechanio')

app.controller 'SymptomsController', ['$scope', ($scope) ->

  $scope.symptoms = []

  $scope.isParent = (symptom) ->
    symptom.parent_ids.length == 0

  $scope.childrenCount = (parent) ->
    children = (symptom for symptom in $scope.symptoms when parent.id in symptom.parent_ids)
    children.length

  $scope.childrenOf = (parent) ->
    (symptom) ->
      parent.id in symptom.parent_ids
]
