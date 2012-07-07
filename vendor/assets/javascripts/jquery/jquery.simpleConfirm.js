/**
* SIMPLE CONFIRM PLUGIN
* -----------------------------------------------
* Plugin to show modal confirmation dialog independent
* of an element or event. Built to work with $.simpleSpinner()
* or independently
*
* Example Use
*	-----------------------------------------------
* $('#myLink').click(function(event){
*		var $href = this.href;
* 	$.simpleConfirm({
*			block_event : event,
*			message : 'Are you sure you want to do this?',
*			proceed_callback : function(){
*				window.location = $href;
*			}
*		});
* });
*/

(function($){

	// Load required resources
	if(!$.blockUI){$.require('jquery/jquery.blockUI.js');}
	if(!$.simpleButton){$.require('jquery/jquery.simpleButton.js');}
	if(!$.simpleSpinner){$.require('jquery/jquery.simpleSpinner.js');}

	$.simpleConfirm = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleConfirm.defaults, options);

		// Error checking
/*
		if(!ABAQIS.errorCheck('$.simpleConfirm()',[{
			check : function(){return settings.block_event == false || typeof settings.block_event == 'object'},
			log : '"block_event" type is incorrect'
		},{
			check : function(){return typeof settings.message == 'string'},
			log : '"message" type is incorrect'
		},{
			check : function(){return typeof settings.proceed_button == 'string'},
			log : '"proceed_button" type is incorrect'
		},{
			check : function(){return typeof settings.cancel_button == 'string'},
			log : '"cancel_button" type is incorrect'
		},{
			check : function(){return typeof settings.proceed_callback == 'function'},
			log : '"proceed_callback" type is incorrect'
		},{
			check : function(){return typeof settings.cancel_callback == 'function'},
			log : '"cancel_callback" type is incorrect'
		},{
			check : function(){return typeof settings.use_spinner == 'boolean'},
			log : '"use_spinner" type is incorrect'
		},{
			check : function(){return typeof settings.spinner_message == 'string'},
			log : '"spinner_message" type is incorrect'
		}])){return;}
*/

		// Block default event
		if(settings.block_event){
			settings.block_event.preventDefault();
		}

		// Create modal
		var modal_message = $('<div/>').append('<p>'+settings.message+'</p>');

		// Set up callback
		var callback = function(){
			if(settings.use_spinner){
				$.simpleSpinner({message : settings.spinner_message});
			}
			settings.proceed_callback()
		};

		// Create proceed button
		if(settings.proceed_button){
			modal_message.append(
				$.simpleButton({value:settings.proceed_button,callback:callback})
			);
		}

		// Create cancel button
		if(settings.cancel_button){
			modal_message.append(
				$.simpleButton({value:settings.cancel_button,callback:settings.cancel_callback})
			);
		}

		// Remove modal window
		$.unblockUI();

		// Show modal window
		$.blockUI({
			message : modal_message,
			css : {
				padding : '20px',
				textAlign : 'left',
				borderColor : '#CCC',
				'-webkit-border-radius' : '5px', 
				'-moz-border-radius' : '5px',
				cursor : 'default'
			}
		});

	};

	// Set defaults
	$.simpleConfirm.defaults = {
		block_event : false,
		message : 'Are you sure?',
		proceed_button : 'Yes, proceed',
		cancel_button : 'Cancel',
		proceed_callback : function(){},
		cancel_callback : function(){},

		// Spinner defaults
		use_spinner : false,
		spinner_message : 'Processing...'
	};

})(jQuery);
