app = angular.module('mechanio')

app.directive 'ngFocus', [ ->
  FOCUS_CLASS = "ng-focused"
  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, element, attrs, ctrl) ->
      ctrl.$focused = false
      element.bind 'focus', (evt) ->
        element.addClass FOCUS_CLASS
        scope.$apply -> ctrl.$focused = true
      element.bind 'blur', (evt) ->
        element.removeClass FOCUS_CLASS
        scope.$apply -> ctrl.$focused = false
  }
]