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
		src : '/assets/' + resource, 
		type: 'text/javascript'
	    })
	    .appendTo('head');
    };
})(jQuery);
