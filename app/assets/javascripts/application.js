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
                if( data && data.id ) {
                    $scope.state[data.id.toString()] = 'saved';
                }
                $scope.$digest();
            });
        });

        $scope.setDateTime = function () { 
            $('#datetimepicker').datetimepicker().on('dp.change', function (data) {
                $scope.datetime_changed = true;
            });
        }

        $scope.deleteInterval = function(id) {
            $('#remove_trigger_' + id).css({'display': 'none'});
            $('#remove_' + id).css({'display': 'block'});
        }

    }
]);

// info message animation
function messageAnimation(full) {
    var container = $('.msg-container');
    setTimeout(function() {
        for (var i=0; i <= 100; i += 1){
          increase(i);
          decrease(i);
        }

        function increase(width) {
            setTimeout(function() {
                container.width(width + "%");
                if (width == 60) {
                    $('.msg').fadeIn(100);
                    if(full) {
                        setTimeout(function() {
                            $('.msg').fadeOut(200);
                        }, 2000);
                    }
                }
            }, width*width*width*width/300000);
        }

        function decrease(width) {
            if(full) {
                setTimeout(function() {
                    if (width == 100) {
                        container.addClass('bounce');
                        for (var i = 850; i < 1000; i++) {
                            swimOut(i/10);
                        }
                        container.fadeOut(1000);
                    } else {
                        container.width((100-width) + "%");
                        re_width = width - 0.15*width;
                        container.css({'margin-left': re_width + "%"});
                    }
                }, 2500 + Math.sqrt(Math.sqrt(width*1000000000)));
            }
        }

        function swimOut(width) {
            setTimeout(function() {
                container.css({'margin-left': width + "%"});
            }, (width-85)*(width-85)*10);
        }
    }, 100);
}
$(function(){
    messageAnimation(true);
});

function flash(msg) {
    $('.flash-msg').html(
        '<div class="msg-container">' +
        '<div class="notice msg" id="flash_notice">' +
        msg +
        '</div></div>'
    );
    messageAnimation(true);
}

function flash_error(msg) {
    $('.flash-msg').html(
        '<div class="msg-container error">' +
        '<div class="notice msg" id="flash_notice">' +
        msg +
        '</div></div>'
    );
    messageAnimation();
}


function showMore(link) {

    var truncatedContent = $(link).parent();
    var fullContent = truncatedContent.next();

    truncatedContent.hide();
    fullContent.show();

}

function showLess(link) {

    var fullContent = $(link).parent();
    var truncatedContent = fullContent.prev();

    truncatedContent.show();
    fullContent.hide();

}

$(document).ready(function() {
  $('.has-tooltip').tooltip();
});
