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
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
}

RS.Phone.Data.MaxSlots = 16;

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob && RS.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}

// Handle phone home buttn
$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (RS.Phone.Data.currentApplication === null) {
        RS.Phone.Functions.ClosePhone();
    } else {
        RS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        RS.Phone.Animations.TopSlideUp('.'+RS.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            RS.Phone.Functions.ToggleApp(RS.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
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
                    OpenedChatPicture = null;
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
        } else if (RS.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"}); 
            }, 400)
        }

        RS.Phone.Data.currentApplication = null;
    }
});

// Open and Close functions
RS.Phone.Functions.OpenPhone = function(data) {
    RS.Phone.Animations.BottomSlideUp('.container', 300, 0);
    // RS.Phone.Notifications.LoadTweets(data.Tweets);
    RS.Phone.Data.IsOpen = true;
}

RS.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

RS.Phone.Functions.ClosePhone = function() {
    RS.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('http://rs-phone/Close');
    RS.Phone.Data.IsOpen = false;
}

RS.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

RS.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

// Handle app selection
$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length > 0) {
        if (CanOpenApp) {
            if (RS.Phone.Data.currentApplication == null) {
                RS.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                RS.Phone.Functions.ToggleApp(PressedApplication, "block");
                
                if (RS.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    RS.Phone.Functions.HeaderTextColor("black", 300);
                }
    
                RS.Phone.Data.currentApplication = PressedApplication;

                if (PressedApplication == "settings") { // Settings
                    $("#myPhoneNumber").text(RS.Phone.Data.PlayerData.charinfo.phone);
                    // $("#mySerialNumber").text("RS-" + RS.Phone.Data.PlayerData.metadata["phonedata"].SerialNumber);
                } else if (PressedApplication == "bank") { // Bank
                    RS.Phone.Functions.DoBankOpen();
                    $.post('http://rs-phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        RS.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('http://rs-phone/GetInvoices', JSON.stringify({}), function(invoices){
                        RS.Phone.Functions.LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "phone") { // Phone
                    $.post('http://rs-phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        RS.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('http://rs-phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        RS.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('http://rs-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") { // Mail
                    $.post('http://rs-phone/GetMails', JSON.stringify({}), function(mails){
                        RS.Phone.Functions.SetupMails(mails);
                    });
                    $.post('http://rs-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "whatsapp") {
                    $.post('http://rs-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        RS.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "advertentie") {
                    $.post('http://rs-phone/LoadAdverts', JSON.stringify({}), function(adverts){
                        RS.Phone.Functions.LoadAdverts(adverts);
                    });
                } else if (PressedApplication == "twitter") {
                    $.post('http://rs-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        RS.Phone.Functions.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('http://rs-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        RS.Phone.Functions.LoadHashtags(Hashtags)
                    })
                    if (RS.Phone.Data.IsOpen) {
                        $.post('http://rs-phone/GetTweets', JSON.stringify({}), function(Tweets){
                            RS.Phone.Functions.LoadTweets(Tweets);
                        });
                    }
                } else if (PressedApplication == "garage") {
                    $.post('http://rs-phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('http://rs-phone/GetCryptoData', JSON.stringify({
                        crypto: "bitcoin",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('http://rs-phone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "houses") {
                    $.post('http://rs-phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('http://rs-phone/GetPlayerKeys', JSON.stringify({}), function(Keys){
                        $(".house-app-mykeys-container").html("");
                        if (Keys.length > 0) {
                            $.each(Keys, function(i, key){
                                var elem = '<div class="mykeys-key" id="keyid-'+i+'"> <span class="mykeys-key-label">' + key.HouseData.adress + '</span> <span class="mykeys-key-sub">Klik om GPS in te stellen</span> </div>';

                                $(".house-app-mykeys-container").append(elem);
                                $("#keyid-"+i).data('KeyData', key);
                            });
                        }
                    });
                }
            }
        }
    }
});


// Handle SendNUI
$(document).ready(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                //console.log("event triggered :)");
                RS.Phone.Functions.OpenPhone(event.data);
                RS.Phone.Functions.SetupAppWarnings(event.data.AppData);
                RS.Phone.Functions.SetupCurrentCall(event.data.CallData);
                RS.Phone.Data.IsOpen = true;
                RS.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            case "LoadPhoneData":
                // console.log("load phone triggered");
                RS.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                RS.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                RS.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                RS.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                RS.Phone.Functions.SetupAppWarnings(event.data.AppData);                
                break;
            case "UpdateMentionedTweets":
                RS.Phone.Functions.LoadMentionedTweets(event.data.Tweets);                
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&euro; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (RS.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        //console.log('Chat reloaded 0')
                        RS.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                        //console.log('Chats reloaded 1')
                        RS.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                RS.Phone.Functions.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                RS.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('http://rs-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('http://rs-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
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
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("Ingesprek ("+timeString+")");
                    $(".call-notifications-content").html("Aan het bellen met "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
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
            case "UpdateMails":
                RS.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (RS.Phone.Data.currentApplication == "advertentie") {
                    RS.Phone.Functions.LoadAdverts(event.data.Adverts);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateApplications":
                RS.Phone.Data.PlayerJob = event.data.JobData;
                RS.Phone.Functions.SetupApplications(event.data);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('http://rs-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "RefreshAlerts":
                RS.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;    
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            RS.Phone.Functions.ClosePhone();
            break;
    }
});

RS.Screen.Notification = function(title, content, icon, timeout, color) {
    var NotificationTimeout;
    $.post('http://rs-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
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
    });
}

RS.Phone.Functions.SetupApplications = function(data) {
    RS.Phone.Data.Applications = data.applications;

    var i;
    for (i = 1; i <= RS.Phone.Data.MaxSlots; i++) {
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+i+'"]');
        $(applicationSlot).html("");
        $(applicationSlot).css({
            "background-color":"transparent"
        });
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');
        $(applicationSlot).removeData('placement')
    }

    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, RS.Phone.Data.PlayerJob.name)

        if ((!app.job || app.job === RS.Phone.Data.PlayerJob.name) && !blockedapp) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="police-icon">';
            }
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
            $(applicationSlot).prop('title', app.tooltipText);
            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos)
            }
        }
    });

    $('.twitter-avatar-img').attr("src", RS.Phone.Data.MetaData.profilepicture);

    $('[data-toggle="tooltip"]').tooltip();
}


// Functions
RS.Phone.Functions.LoadPhoneData = function(data) {
    RS.Phone.Data.PlayerData = data.PlayerData;
    RS.Phone.Data.PlayerJob = data.PlayerJob;
    RS.Phone.Data.MetaData = data.PhoneData.MetaData;
    RS.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    RS.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    //console.log(data.PhoneData.Contacts);
    RS.Phone.Functions.SetupApplications(data);
    //console.log("Phone succesfully loaded!");
}

RS.Phone.Functions.UpdateTime = function(data) {    
    var NewDate = new Date();
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

    $("#phone-time").html(MessageTime + " <span style='font-size: 1.1vh;'>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
}

RS.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-navbar").animate({color: newColor}, Timeout);
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
    $.post('http://rs-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (RS.Phone.Notifications.Timeout == undefined || RS.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                RS.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                if (icon !== "politie") {
                    $(".notification-icon").html('<i class="'+icon+'"></i>');
                } else {
                    $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
                }
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
    });
}