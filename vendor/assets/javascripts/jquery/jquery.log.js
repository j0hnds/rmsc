/**
* LOG PLUGIN
* -----------------------------------------------
* Plugin writes messages to the console log
*
* Example Use
*	-----------------------------------------------
* $.log("My debug message!");
*/

(function($){

	$.log = function(msg){
		if(typeof msg == 'string' && window.console && !$.browser.msie && ABAQIS.debug) {
			console.log(msg);
		}
	};

})(jQuery);