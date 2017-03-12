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

// info message animation
$(function(){
    setTimeout(function() {
        for (var i=0; i <= 100; i += 1){
          increase(i);
          decrease(i);
        }

        function increase(width) {
            setTimeout(function() {
                $('.msg-container').width(width + "%");
                if (width == 60) {
                    $('.msg').fadeIn(100);
                    setTimeout(function() {
                        $('.msg').fadeOut(200);
                    }, 2000);
                }
            }, width*width*width*width/300000);
        }

        function decrease(width) {
            setTimeout(function() {
                if (width == 100) {
                    $('.msg-container').addClass('bounce');
                    for (var i = 850; i < 1000; i++) {
                        swimOut(i/10);
                    }
                    $('.msg-container').fadeOut(1000);
                } else {
                    $('.msg-container').width((100-width) + "%");
                    re_width = width - 0.15*width;
                    $('.msg-container').css({'margin-left': re_width + "%"});
                }
            }, 2500 + Math.sqrt(Math.sqrt(width*1000000000)));
        }

        function swimOut(width) {
            setTimeout(function() {
                $('.msg-container').css({'margin-left': width + "%"});
            }, (width-85)*(width-85)*10); 
        }
    }, 100);
});

function flash() {
    // render div with id here
    console.log('TODO: flash message for success update');
    alert('TODO: flash message for success update');
}
