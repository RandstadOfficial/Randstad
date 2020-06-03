RS.Phone.Settings = {};
RS.Phone.Settings.Background = "background-1";
RS.Phone.Settings.OpenedTab = null;
RS.Phone.Settings.Backgrounds = {
    'background-1': {
        label: "Standaard"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab !== "myPhone") {
        RS.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        RS.Phone.Settings.OpenedTab = PressedTab;
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = RS.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        RS.Phone.Notifications.Add("fas fa-paint-brush", "Instellingen", RS.Phone.Settings.Backgrounds[RS.Phone.Settings.Background].label+" is ingesteld!")
        RS.Phone.Animations.TopSlideUp(".settings-"+RS.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+RS.Phone.Settings.Background+".png')"})
    } else {
        RS.Phone.Notifications.Add("fas fa-paint-brush", "Instellingen", "Eigen achtergrond ingesteld!")
        RS.Phone.Animations.TopSlideUp(".settings-"+RS.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+RS.Phone.Settings.Background+"')"});
    }

    $.post('http://rs-phone_new/SetBackground', JSON.stringify({
        background: RS.Phone.Settings.Background,
    }))
});

RS.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        RS.Phone.Settings.Background = MetaData.background;
    } else {
        RS.Phone.Settings.Background = "background-1";
    }

    var hasCustomBackground = RS.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+RS.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+RS.Phone.Settings.Background+"')"});
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    RS.Phone.Animations.TopSlideUp(".settings-"+RS.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

RS.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(RS.Phone.Settings.Backgrounds, function(i, background){
        if (RS.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            RS.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            RS.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    RS.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    RS.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    RS.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});