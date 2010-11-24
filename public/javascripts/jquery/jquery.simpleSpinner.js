/**
* SIMPLE SPINNER PLUGIN
* -----------------------------------------------
* Plugin to display a "processing..." spinner while
* task is being performed. Built to work with 
* $.simpleAjax() and $.simpleConfirm() or independently
*
* Example Use
*	-----------------------------------------------
* $('#myLink').click(function(){
* 	$.simpleSpinner({message : "Processing your request..."});
* });
*/

(function($){

	// Load required resources
	if(!$.blockUI){$.require('jquery/jquery.blockUI.js');}
	if(!$.preLoadImages){$.require('jquery/jquery.preLoadImages.js');}

	// Pre load spinner image
	$.preLoadImages('/images/interface/page_spinner.gif');

	$.simpleSpinner = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleSpinner.defaults, options);

		// Error checking
		if(!ABAQIS.errorCheck('$.simpleSpinner()',[{
			check : function(){return typeof settings.message == 'string'},
			log : '"message" type is incorrect'
		}])){return;}

		// Remove any existing block
		$.unblockUI();

		// Start spinner
		$.blockUI({
			message:'<p><img src="/images/interface/page_spinner.gif"/><br/><strong>'+settings.message+'</strong></p>',
			css:{
				borderWidth : '0',
				background : 'transparent',
				color : '#FFF'
			} 
		});

		// Clear messages
		if($('#module_messages').css('display') != 'none'){
			$('#module_messages').fadeOut('fast',function(){
				$(this)
					.css('display','none')
					.empty();
			});
		}

	};

	// Set defaults
	$.simpleSpinner.defaults = {
		message : 'Loading...'
	};

})(jQuery);