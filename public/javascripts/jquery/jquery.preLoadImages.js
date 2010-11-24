/**
* PRE LOAD IMAGES PLUGIN
* -----------------------------------------------
* Plugin to handle preloading of images for smoother
* animations etc
*
* Example Use
*	-----------------------------------------------
* $.preLoadImages('/images/site_logo.gif','/images/icons/alert.gif');
*/

(function($) {

	// Set globals
	var cache = [];

	$.preLoadImages = function() {

		for(var i=arguments.length; i--;){
			var cacheImage = document.createElement('img');
			cacheImage.src = arguments[i];
			cache.push(cacheImage);
		}

	};

})(jQuery);