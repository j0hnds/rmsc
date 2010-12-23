// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){
    // Load required resources
    if (! $.log) { $.require('jquery/jquery.log.js'); }
    if (! $.simpleConfirm) { $.require('jquery/jquery.simpleConfirm.js'); }
    if (! $.simpleInsert) { $.require('jquery/jquery.simpleInsert.js'); }

	/*
		Insert asynchronous content
	*/
	$('.insert').live('click',function (event) {

		// Cache link
		var url = this.href;

		if(!$(this).hasClass('disabled')) {

			// Insert content
			$.simpleInsert({
				block_event : event,
				target : '#record_manager',
				source : url,
				use_spinner : false,
				callback : function () {
					// Scroll to top of page
					$('html, body').animate({scrollTop:0}, 'normal');
				}
			});
		} else {
			event.preventDefault();
		}
	});

	// Handle AJAX form posts
	$('.ajaxed').livequery(function(){
		$(this).submit(function(event){
			// Load required resources
			if(!$.simpleAjax){$.require('jquery/jquery.simpleAjax.js');}
			// Submit form
			$.simpleAjax({
				block_event : event,
				url : this.action + '.js',
				dataString : $(this).serialize()
			});
		});
	});

    // Handle search clear
    $('#grid_search_show_all').live('click', function(event){
       $('input#search').val('');
       $(this).submit();
    });



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