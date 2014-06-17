app = angular.module('mechanio')

app.controller 'ContactController', ['$scope', ($scope) ->
  $scope.job = {}
  $scope.location = {}

  $scope.phone_regex = /^04\d{8}$/

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options
    $scope.job.contact_email = $scope.contact.contact_email
    $scope.job.contact_phone = $scope.contact.contact_phone

  $scope.submit = ->
    $scope.data.job = angular.copy($scope.job)
    $scope.data.location = angular.copy($scope.location)
    $scope.data.location.suburb_id = $scope.location.suburb.id

    if $scope.authorized()
      $scope.submitStep()
    else
      $scope.loading = true
      $scope.saveJob($scope.onSave, $scope.onError)

  $scope.onSave = ->
    $scope.loading = false
    $scope.authorize()

  $scope.onError = ->
    $scope.loading = false
    $scope.error = true

  $scope.valid = ->
    $scope['contact_form'].$valid


  # Suburb typeahead

  datasource = new Bloodhound(
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace(d.name)
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/ajax/suburbs?name=%QUERY'
  )
  datasource.initialize()

  $scope.completeOptions = {}
  $scope.completeDatasets = {
    displayKey: 'display_name',
    source: datasource.ttAdapter()
  }

  $scope.$on 'typeahead:closed', (e) ->
    $scope.location.suburb = '' unless typeof $scope.location.suburb == 'object'
]
