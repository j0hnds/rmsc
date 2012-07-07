$(function(){
    if(!$.simpleAjax){$.require('jquery/jquery.simpleAjax.js');}
    
    // Handle AJAX form post
    $('#add_record','#edit_record').livequery('submit',function(event){
        $.simpleAjax({
            block_event : event,
            url : this.action,
            dataString : $(this).serialize()
        });
    });
});
