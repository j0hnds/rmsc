/**
* SIMPLE INSERT PLUGIN
* -----------------------------------------------
* Plugin to insert content on the page via AJAX. Built
* to work with $.simpleSpinner() and $.simpleConfirm()
* or independently
*
* Example Use
*	-----------------------------------------------
* $('#myLink').click(function(event){
* 	$.simpleInsert({
*			block_event : event,
*			target : '#myDiv',
*			source : this.href,
*			callback : function(){alert('Loaded!');}
*		});
* });
*/

(function($){

	// Load required resources
	if(!$.blockUI){$.require('jquery/jquery.blockUI.js');}
	if(!$.simpleConfirm){$.require('jquery/jquery.simpleConfirm.js');}
	if(!$.simpleSpinner){$.require('jquery/jquery.simpleSpinner.js');}

	$.simpleInsert = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleInsert.defaults, options);

		// Error checking
        /*
		if(!ABAQIS.errorCheck('$.simpleInsert()',[{
			check : function(){return settings.block_event == false || typeof settings.block_event == 'object'},
			log : '"block_event" type is incorrect'
		},{
			check : function(){return settings.target == false || typeof settings.target == 'string'},
			log : '"target" type is incorrect'
		},{
			check : function(){return settings.source == false || typeof settings.source == 'string'},
			log : '"messages" type is incorrect'
		},{
			check : function(){return typeof settings.callback == 'function'},
			log : '"callback" type is incorrect'
		},{
			check : function(){return typeof settings.use_spinner == 'boolean'},
			log : '"use_spinner" type is incorrect'
		},{
			check : function(){return typeof settings.spinner_message == 'string'},
			log : '"spinner_message" type is incorrect'
		},{
			check : function(){return typeof settings.confirm_insert == 'boolean'},
			log : '"confirm_insert" type is incorrect'
		},{
			check : function(){return typeof settings.confirm_message == 'string'},
			log : '"confirm_message" type is incorrect'
		},{
			check : function(){return typeof settings.confirm_proceed_button == 'string'},
			log : '"confirm_proceed_button" type is incorrect'
		},{
			check : function(){return typeof settings.confirm_cancel_button == 'string'},
			log : '"confirm_cancel_button" type is incorrect'
		},{
			check : function(){return typeof settings.confirm_cancel_callback == 'function'},
			log : '"confirm_cancel_callback" type is incorrect'
		}])){return;}
		*/

		// Block default event
		if(settings.block_event){
			settings.block_event.preventDefault();
		}

		// Content loader
		var loadContent = function(){
			if(settings.use_spinner){
				$.simpleSpinner({message : settings.spinner_message});
			}
			$(settings.target)
				.css('display','none')
				.load(settings.source,function(response,status,xhr){
					if(response == 'invalid session'){
						window.location = '/login';
						return;
					} else {
						$(this).fadeIn('fast');
						$.unblockUI();
						settings.callback();
						$("input[type='text']:first:visible:enabled", this).focus();
					}
				});
		};

		// Load content
		if(settings.confirm_insert){
			$.simpleConfirm({
				message : settings.confirm_message,
				proceed_button : settings.confirm_proceed_button,
				cancel_button : settings.confirm_cancel_button,
				proceed_callback : loadContent,
				cancel_callback : settings.confirm_cancel_callback
			});
		} else {
			loadContent();
		}

	};

	// Set defaults
	$.simpleInsert.defaults = {
		block_event : false,
		target : false,
		source : false,
		callback : function(){},

		// Spinner defaults
		use_spinner : false,
		spinner_message : 'Loading...',
		
		// Confirmation defaults
		confirm_insert : false,
		confirm_message : 'Are you sure?',
		confirm_proceed_button : 'Yes, proceed!',
		confirm_cancel_button : 'Cancel',
		confirm_cancel_callback : function(){}
	};

})(jQuery);