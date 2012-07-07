$(function(){

    $('.room_edit').editInPlace({
       url: "registrations/room",
       show_buttons: true
    });

    $('.lines_edit').editInPlace({
       url: "registrations/lines",
       field_type: "textarea",
       show_buttons: true
    });

    $('.associates_edit').editInPlace({
       url: "registrations/associates",
       field_type: "textarea",
       show_buttons: true
    });
});