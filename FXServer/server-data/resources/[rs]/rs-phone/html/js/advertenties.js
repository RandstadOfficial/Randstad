// ....................../´¯/) 
// ....................,/¯../ 
// .................../..../ 
// ............./´¯/'...'/´¯¯`·¸ 
// ........../'/.../..../......./¨¯\ 
// ........('(...´...´.... ¯~/'...') 
// .........\.................'...../ 
// ..........''...\.......... _.·´ 
// ............\..............( 
// ..............\.............\...
// waaRoM KopIEeR jE qbuS

// Functions
RS.Phone.Functions.LoadAdverts = (adverts) => {
    $(".advertentie-lijst").html("");

    if (adverts.length < 0) 
        return

    $.each(adverts, function(i, add){
        var addvertHtml = '<div class="advertentie"><span class="advertentie-owner">'+add.name+'</span><span class="advertentie-nummer">'+add.number+'</span><p class="advertentie-bericht">'+add.message+'</p></div>';
        $(".advertentie-lijst").append(addvertHtml);
    });
}


// On Click check
// Goto new advert
$(document).on('click', '.advertentie-add-btn', (e) => {
    e.preventDefault();

    $('.advertenties').animate({
        top: 62+"vh"
    });
    $(".nieuw-advertentie").animate({
        top: 0+"vh"
    });

});

// Go back to adverts
$(document).on('click', '.nieuw-advertentie-back-btn', (e) => {
    e.preventDefault();

    $(".advertenties").animate({
        top: 0+"vh"
    });
    $(".nieuw-advertentie").animate({
        top: -62+"vh"
    });
});

// Submit advert
$(document).on('click', '.nieuw-advertentie-btn', function(e){
    e.preventDefault();

    var advertentieBericht = $("#nieuw-advertentie-bericht").val();

    if (advertentieBericht == "") {
        RS.Phone.Notifications.Add("fas fa-ad", "Advertentie", "Je kan geen lege AD plaatsen!", "#FFF", 2000);
        return
    }

    $(".advertenties").animate({
        top: 0+"vh"
    });
    $(".nieuw-advertentie").animate({
        top: -62+"vh"
    });
    $.post('http://rs-phone/PostAdvert', JSON.stringify({
        message: advertentieBericht,
    }));

    $("#nieuw-advertentie-bericht").val('');
});

