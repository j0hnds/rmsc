/**
* SIMPLE AJAX PLUGIN
* -----------------------------------------------
* Plugin to handle AJAX requests independent of an
* element or event. Built to work with $.simpleSpinner()
* and $.simpleConfirm() or independently
*
* Example Use
*	-----------------------------------------------
* $('#myForm').submit(function(event){
* 	$.simpleAjax({
*			block_event : event,
*			url : this.action,
*			dataString : $(this).serialize()
*		});
* });
*/

(function($){

	/* Load required resources */
	if(!$.blockUI){$.require('jquery.blockUI.js');}
	if(!$.simpleConfirm){$.require('jquery/jquery.simpleConfirm.js');}
	if(!$.simpleSpinner){$.require('jquery/jquery.simpleSpinner.js');}

	$.simpleAjax = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleAjax.defaults, options),
				validMethods = {post:1, get:1},
				validTypes = {script:1, html:1, json:1, text:1, xml:1};

		// Error checking
        /*
		if(!ABAQIS.errorCheck('$.simpleAjax()',[{
			check : function(){return settings.block_event == false || typeof settings.block_event == 'object'},
			log : '"block_event" type is incorrect'
		},{
			check : function(){return typeof settings.method == 'string' && validMethods[settings.method]},
			log : '"method" type is incorrect'
		},{
			check : function(){return settings.url == false || typeof settings.url == 'string'},
			log : '"url" type is incorrect'
		},{
			check : function(){return typeof settings.type == 'string' && validTypes[settings.type]},
			log : '"type" type is incorrect'
		},{
			check : function(){return settings.dataString == false || typeof settings.dataString == 'string'},
			log : '"dataString" type is incorrect'
		},{
			check : function(){return settings.target == false || typeof settings.target == 'string'},
			log : '"target" type is incorrect'
		},{
			check : function(){return typeof settings.callback == 'function'},
			log : '"callback" type is incorrect'
		},{
			check : function(){return typeof settings.use_spinner == 'boolean'},
			log : '"boolean" type is incorrect'
		},{
			check : function(){return typeof settings.spinner_message == 'string'},
			log : '"spinner_message" type is incorrect'
		},{
			check : function(){return typeof settings.confirm_action == 'boolean'},
			log : '"confirm_action" type is incorrect'
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

		// Submit data method
		var submitData = function(){
			if(settings.use_spinner){
				$.simpleSpinner({message : settings.spinner_message});
			}
			$.ajax({
				type : settings.method,
				url : settings.url,
				dataType : settings.type,
				data : settings.dataString,
				success : function(data){
					if(data == 'invalid session'){
						window.location = '/login';
						return;
					} else {
						if(settings.target){
							$(settings.target).html(data);
						}
						settings.callback();
						$.unblockUI();
					}
				}
			});
		};

		// Submit data
		if(settings.confirm_action){ // <= With confirmation
			$.simpleConfirm({
				message : settings.confirm_message,
				proceed_button : settings.confirm_proceed_button,
				cancel_button : settings.confirm_cancel_button,
				proceed_callback : submitData,
				cancel_callback : settings.confirm_cancel_callback
			});
		} else { // <= Without confirmation
			submitData();
		}

	};

	// Set defaults
	$.simpleAjax.defaults = {
		block_event : false,
		method : 'post',
		url : false,
		type : 'script',
		dataString : false,
		target : false,
		callback : function(){},

		// Spinner defaults
		use_spinner : true,
		spinner_message : 'Processing...',
		
		// Confirmation defaults
		confirm_action : false,
		confirm_message : 'Are you sure?',
		confirm_proceed_button : 'Yes, proceed!',
		confirm_cancel_button : 'Cancel',
		confirm_cancel_callback : function(){}
	};

})(jQuery);
