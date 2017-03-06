// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require angular
//= require moment
//= require bootstrap-datetimepicker
//= require turbolinks
//= require_tree .

angular.module('webx', [])
.controller('MainCtrl', [
    '$scope',
    function($scope){

        // GENERAL MAPPER OBJECT - FREE USE FOR NG-MODEL MAPPING
        $scope.mapper = {
            'names': {},
            'types': {}
        };

        // GENERAL STATE MAPPER OBJECT - FREE USE FOR ENTITIES STATES
        $scope.state = {}


        $scope.save = function(id) {
            $scope.state[id] = 'saving';
        }

        $scope.dirty = function(id) {
            $scope.state[id] = 'changed';
        }

        $(document).ready( function($) {
            $(document).ajaxSuccess( function(_, __, ___ , data) {
                $scope.state[data.id.toString()] = 'saved';
                $scope.$digest();
            });
        });

        $scope.setDateTime = function () { 
            $('#datetimepicker').datetimepicker().on('dp.change', function (data) {
                $scope.datetime_changed = true;
            });
        }
    }
]);

function flash() {
    // render div with id here
    console.log('TODO: flash message for success update');
    alert('TODO: flash message for success update');
}
