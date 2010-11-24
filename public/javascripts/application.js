// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){
    // Load required resources
    if (! $.log) { $.require('jquery/jquery.log.js'); }
    if (! $.simpleConfirm) { $.require('jquery/jquery.simpleConfirm.js'); }
});

/* PLUGINS */

(function($) {

    /*
      REQUIRE PLUGIN
      ------------------------------
      if(!$.fn.skipLogic){$.require('jquery.skipLogic.js');}
     */
    $.require = function(resource) {
	$('<script/>')
	    .attr({
		src : '/javascripts/' + resource, 
		type: 'text/javascript'
	    })
	    .appendTo('head');
    };
})(jQuery);