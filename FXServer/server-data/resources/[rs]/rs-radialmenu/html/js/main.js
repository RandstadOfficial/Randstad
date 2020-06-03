'use strict';

var RSRadialMenu = null;

$(document).ready(function(){

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.radial) {
                createMenu(eventData.items)
                RSRadialMenu.open();
            } else {
                RSRadialMenu.close();
            }
        }

        if (eventData.action == "setPlayers") {
            createMenu(eventData.items)
        }
    });
});

function createMenu(items) {
    RSRadialMenu = new RadialMenu({
        parent      : document.body,
        size        : 375,
        menuItems   : items,
        onClick     : function(item) {
            if (item.shouldClose) {
                RSRadialMenu.close();
            }
            
            if (item.event !== null) {
                if (item.data !== null) {
                    $.post('http://rs-radialmenu/selectItem', JSON.stringify({
                        itemData: item,
                        data: item.data
                    }))
                } else {
                    $.post('http://rs-radialmenu/selectItem', JSON.stringify({
                        itemData: item
                    }))
                }
            }
        }
    });
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            RSRadialMenu.close();
            break;
    }
});