ComponentController = ($scope, $filter, $http, $routeParams, $controller) ->
  $scope.$watch 'selectedVersion', ->
    if $scope.selectedVersion?
      $http.get("/components/#{$scope.componentName}/#{$scope.selectedVersion}").then (response) ->
        $scope.javascripts = (path for path in response.data when path.type is 'javascript')
        $scope.stylesheets = (path for path in response.data when path.type is 'stylesheet')
        $scope.jsManifest = (path for path in $scope.javascripts when path.main is true).length > 0
        $scope.cssManifest = (path for path in $scope.stylesheets when path.main is true).length > 0

  $scope.componentName = $routeParams.componentName
  $scope.selectedVersion = $routeParams.version

  $http.get("/components.json").then (response) ->
    $scope.gem = $filter('filter')(response.data, { name: $scope.componentName }, true)[0]
    $controller('SearchResultController', { $scope: $scope })
    $scope.selectedVersion ||= $scope.gem.latestVersion

  $scope.onClipboardCopy = (event) ->
    event.clearSelection()
    angular.element(event.trigger).addClass('tooltipped')
    true

angular.module('rails-assets').controller 'ComponentController',  [
  '$scope',
  '$filter',
  '$http',
  '$routeParams',
  '$controller',
  ComponentController
]
