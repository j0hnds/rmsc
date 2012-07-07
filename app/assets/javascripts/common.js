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

    /*
        Implement the cancel link on crud forms
     */
    $('a.cancel_form').live('click', function(event){
        $('div#record_manager').empty();
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

    // Handle show selection
    $('#show_id').live('change', function(event){
        // alert('The show id changed');
        $('form#show_select_form').submit();
    });

	/*
		Date picker fields that don't have limitations on the dates being picked.
	*/
	$('.date_picker_unlimited').livequery(function () {

		Date.firstDayOfWeek = 0;
		Date.format = 'yyyy-mm-dd';

		var $picker = $(this),
				showPicker = function () {
					if(!$picker.hasClass('disabled')) {
						$picker.dpDisplay();
					}
				};

		// Add button
		if(!$.browser.msie || ($.browser.msie && $.browser.version >= 8) ){
			var $icon = $('<img>')
						.attr('src','/assets/interface/calendar.gif')
						.click(showPicker),
					$button = $('<div>')
						.addClass('date_picker_calendar')
						.click(showPicker)
						.append($icon);
			$picker.wrap('<div class="date_picker_wrapper"/>').after($button);
		}

		$picker
			.attr('readonly',true)
			.datePicker({
				createButton : false,
				startDate : '1970-01-01',
				clickInput : true
			})
			.bind('click',function () {
				$(this).dpDisplay();
				this.blur();
				return false;
			})
			.trigger('change');
	});

});

