RS = {}
RS.Phone = {}
RS.Screen = {}
RS.Phone.Functions = {}
RS.Phone.Animations = {}
RS.Phone.Notifications = {}
RS.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

RS.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
}

OpenedChatData = {
    number: null,
}

RS.Phone.Functions.SetupApplications = function(data) {
    RS.Phone.Data.Applications = data.applications;
    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        
        $(applicationSlot).css({"background-color":app.color});
        if (app.style != undefined && app.style != null && app.style != "") {
            $(applicationSlot).html('<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i><div class="app-unread-alerts">0</div>');
        } else {
            $(applicationSlot).html('<i class="ApplicationIcon '+app.icon+'"></i><div class="app-unread-alerts">0</div>');
        }
        $(applicationSlot).prop('title', app.tooltipText);
        $(applicationSlot).data('app', app.app);

        if (app.tooltipPos !== undefined) {
            $(applicationSlot).data('placement', app.tooltipPos)
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}

RS.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        console.log(app.app+": "+app.Alerts)

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

var HeaderDisabledApps = ["bank", "whatsapp"]

RS.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (RS.Phone.Data.currentApplication == null) {
            RS.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
            RS.Phone.Functions.ToggleApp(PressedApplication, "block");
            
            if (RS.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                RS.Phone.Functions.HeaderTextColor("black", 300);
            }

            RS.Phone.Data.currentApplication = PressedApplication;

            if (PressedApplication == "settings") {
                $("#myPhoneNumber").text(RS.Phone.Data.PlayerData.charinfo.phone)
            } else if (PressedApplication == "twitter") {
                $.post('http://rs-phone_new/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                    RS.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                })
                $.post('http://rs-phone_new/GetHashtags', JSON.stringify({}), function(Hashtags){
                    RS.Phone.Notifications.LoadHashtags(Hashtags)
                })
                if (RS.Phone.Data.IsOpen) {
                    $.post('http://rs-phone_new/GetTweets', JSON.stringify({}), function(Tweets){
                        RS.Phone.Notifications.LoadTweets(Tweets);
                    });
                }
            } else if (PressedApplication == "bank") {
                RS.Phone.Functions.DoBankOpen();
                $.post('http://rs-phone_new/GetBankContacts', JSON.stringify({}), function(contacts){
                    RS.Phone.Functions.LoadContactsWithNumber(contacts);
                });
                $.post('http://rs-phone_new/GetInvoices', JSON.stringify({}), function(invoices){
                    RS.Phone.Functions.LoadBankInvoices(invoices);
                });
            } else if (PressedApplication == "whatsapp") {
                $.post('http://rs-phone_new/GetWhatsappChats', JSON.stringify({}), function(chats){
                    RS.Phone.Functions.LoadWhatsappChats(chats);
                });
            } else if (PressedApplication == "phone") {
                $.post('http://rs-phone_new/GetMissedCalls', JSON.stringify({}), function(recent){
                    RS.Phone.Functions.SetupRecentCalls(recent);
                })
            }
        }
    } else {
        RS.Phone.Notifications.Add("fas fa-exclamation-circle", "Systeem", RS.Phone.Data.Applications[PressedApplication].tooltipText+" is niet beschikbaar!")
    }
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (RS.Phone.Data.currentApplication === null) {
        ();
    } else {
        RS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        RS.Phone.Animations.TopSlideUp('.'+RS.Phone.Data.currentApplication+"-app", 400, -160);
        setTimeout(function(){
            RS.Phone.Functions.ToggleApp(RS.Phone.Data.currentApplication, "none");
        }, 400)
        RS.Phone.Functions.HeaderTextColor("white", 300);

        if (RS.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (RS.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});
    
                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');
    
                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');
    
                    CurrentTab = "accounts";
                }, 400)
            }
        }

        RS.Phone.Data.currentApplication = null;
    }
});

RS.Phone.Functions.Open = function(data) {
    RS.Phone.Animations.BottomSlideUp('.container', 300, 0);
    RS.Phone.Notifications.LoadTweets(data.Tweets);
    RS.Phone.Data.IsOpen = true;
}

RS.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

RS.Phone.Functions.Close = function() {
    RS.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('http://rs-phone_new/Close');
    RS.Phone.Data.IsOpen = false;
}

RS.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

RS.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

RS.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

RS.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

RS.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

RS.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    if (timeout == null && timeout == undefined) {
        timeout = 1500;
    }
    if (RS.Phone.Notifications.Timeout == undefined || RS.Phone.Notifications.Timeout == null) {
        if (color != null || color != undefined) {
            $(".notification-icon").css({"color":color});
            $(".notification-title").css({"color":color});
        } else {
            $(".notification-icon").css({"color":"#e74c3c"});
            $(".notification-title").css({"color":"#e74c3c"});
        }
        RS.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
        $(".notification-icon").html('<i class="'+icon+'"></i>');
        $(".notification-title").html(title);
        $(".notification-text").html(text);
        if (RS.Phone.Notifications.Timeout !== undefined || RS.Phone.Notifications.Timeout !== null) {
            clearTimeout(RS.Phone.Notifications.Timeout);
        }
        RS.Phone.Notifications.Timeout = setTimeout(function(){
            RS.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
            RS.Phone.Notifications.Timeout = null;
        }, timeout);
    } else {
        if (color != null || color != undefined) {
            $(".notification-icon").css({"color":color});
            $(".notification-title").css({"color":color});
        } else {
            $(".notification-icon").css({"color":"#e74c3c"});
            $(".notification-title").css({"color":"#e74c3c"});
        }
        $(".notification-icon").html('<i class="'+icon+'"></i>');
        $(".notification-title").html(title);
        $(".notification-text").html(text);
        if (RS.Phone.Notifications.Timeout !== undefined || RS.Phone.Notifications.Timeout !== null) {
            clearTimeout(RS.Phone.Notifications.Timeout);
        }
        RS.Phone.Notifications.Timeout = setTimeout(function(){
            RS.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
            RS.Phone.Notifications.Timeout = null;
        }, timeout);
    }
}

RS.Phone.Functions.LoadPhoneData = function(data) {
    RS.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    RS.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    RS.Phone.Data.PlayerData = data.PlayerData;
}

RS.Phone.Functions.UpdateTime = function(data) {    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").text(MessageTime);
}

var NotificationTimeout = null;

RS.Screen.Notification = function(title, content, icon, timeout, color) {
    if (color != null && color != undefined) {
        $(".screen-notifications-container").css({"background-color":color});
    }
    $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
    $(".screen-notification-title").text(title);
    $(".screen-notification-content").text(content);
    $(".screen-notifications-container").css({'display':'block'}).animate({
        right: 5+"vh",
    }, 200);

    if (NotificationTimeout != null) {
        clearTimeout(NotificationTimeout);
    }

    NotificationTimeout = setTimeout(function(){
        $(".screen-notifications-container").animate({
            right: -35+"vh",
        }, 200, function(){
            $(".screen-notifications-container").css({'display':'none'});
        });
        NotificationTimeout = null;
    }, timeout);
}

// QB.Screen.Notification("Nieuwe Tweet", "Dit is een test tweet like #YOLO", "fab fa-twitter", 4000);

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                RS.Phone.Functions.Open(event.data);
                RS.Phone.Functions.SetupAppWarnings(event.data.AppData);
                RS.Phone.Functions.SetupCurrentCall(event.data.CallData);
                RS.Phone.Data.IsOpen = true; 
                break;
            case "LoadPhoneApplications":
                RS.Phone.Functions.SetupApplications(event.data);
                console.log('yeey')
                break;
            case "LoadPhoneData":
                RS.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                RS.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                console.log('Test')
                RS.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                RS.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                RS.Phone.Functions.SetupAppWarnings(event.data.AppData);                
                break;
            case "UpdateMentionedTweets":
                RS.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);                
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&euro; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                    RS.Phone.Functions.SetupChatMessages(event.data.chatData);
                } else if (RS.Phone.Data.currentApplication == "whatsapp" && OpenedChatData.number === null) {
                    RS.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                }
                break;
            case "UpdateHashtags":
                RS.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                RS.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                CancelOutgoingCall();
                break;
            case "IncomingCallAlert":
                IncomingCallAlert(event.data.CallData, event.data.Canceled);
                break;
            case "SetupHomeCall":
                RS.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                RS.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);

                if (!RS.Phone.Data.IsOpen) {
                    console.log($(".call-notifications").css("right"))
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("Ingesprek ("+timeString+")");
                    $(".call-notifications-content").html("Aan het bellen met "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    console.log($(".call-notifications").css("right"))
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }

                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In gesprek ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                RS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    RS.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                RS.Phone.Functions.HeaderTextColor("white", 300);
    
                RS.Phone.Data.CallActive = false;
                RS.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                RS.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
        }
    })
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            RS.Phone.Functions.Close();
            break;
    }
});

// RS.Phone.Functions.Open();