const Hub = {
    requestsCount: 0,
    notificationsCount: 0,
    muted: false,
    toggle: function(open) {
        if(open)
            $("main").fadeIn();
        else
            $("main").fadeOut();
    },
    toggleMuted: function() {
        if(Hub.muted) {
            Hub.muted = false;
            $("#ouvir").html("silenciar");
        } else {
            Hub.muted = true;
            $("#ouvir").html("ouvir");
        }
    },
    addTemporaryNotification: function(type, title, description, persistent) {
        let temporaryId = Date.now();
        let persistentClass = "";

        if(persistent)
            persistentClass = " will-be-persistent";

        let elementTemporary = `
        <div class="notify hub-notification${persistentClass}" id="notification-${temporaryId}" hidden>
            <i class="fa-solid fa-bells"></i>
            <div class="text">
                <span><b>${title}</b></span>
                <p>${description}</p>
            </div>
        </div>`;
        
        $("#hub-tray").prepend(elementTemporary);
        $("#notification-" + temporaryId).fadeIn(200, function() {
            setTimeout(function() {
                $("#notification-" + temporaryId).fadeOut(200, function() {
                    $("#notification-" + temporaryId).remove();
                });
            }, 20000);
        });

        Hub.playAudio();
    },
    addNotification: function(type, title, description, persistent) {
        Hub.addTemporaryNotification(type, title, description, persistent);

        if(persistent) {
            let date = Hub.getDate();
            let elementPersistent = `
            <div class="notify-item">
                <small>${title} - ${date}</small>
                <p>${description}</p>
            </div>`;

            $('.notify-bell').fadeIn();
            Hub.updateNotifys();
            
            if(Hub.notificationsCount == 0) {
                if(Hub.requestsCount > 0)
                $("#hub").removeClass("lists-1").addClass("lists-2");
                $("[notification-type='regular']").fadeIn();
            }

            $(".hub-notifications[notification-type='regular']").prepend(elementPersistent);
            Hub.notificationsCount++;
        }
    },
    updateNotifys: function() {
        $('listnotify .notify-item').each(function(i) {
            $('.notify-bell .number').html(i+=1)
        });
    },
    clearNotifications: function() {
        $('listnotify').html('');
        $('.notify-bell').fadeOut();
    },
    addRequest: function(type, title, description, id) {
        Hub.addTemporaryNotification(type, title, description, true);
        
        let date = Hub.getDate();
        let element = `
        <div class="item hub-notification" request-id="${id}">
            <div class="info-item">
                <small>${title} - ${date}</small>
                <p>${description}</p>
            </div>
            <div class="actions-item">
                <button class="hub-notification-option-accept" onclick="Hub.tryAcceptRequest(this)"><i class="fa-solid fa-check"></i></button>
                <button class="hub-notification-option-remove" onclick="Hub.denyRequest(this)"><i class="fa-solid fa-xmark"></i></button>
            </div>
        </div>`;
        
        $("#hub-empty").fadeOut();
        if(Hub.requestsCount == 0) {
            if(Hub.notificationsCount > 0)
                $("#hub").removeClass("lists-1").addClass("lists-2");

            $("[notification-type='request']").fadeIn();
        }

        $(".hub-notifications[notification-type='request']").prepend(element);
        Hub.requestsCount++;
    },
    tryAcceptRequest: function(element) {
        if($(element).parent().parent().hasClass("hub-notification-accepted"))
        return false;

        let requestId = $(element).parent().parent().attr("request-id");
        $.post("http://hub/tryAcceptRequest", JSON.stringify({id: requestId}));
        $(element).parent().parent().remove();
    },
    denyRequest: function(element) {
        $(element).parent().parent().fadeOut(200, function() {
            $(element).parent().parent().remove();
        });

        Hub.requestsCount--;

        if(Hub.requestsCount == 0) {
            $("[notification-type='request']").fadeOut(200, function() {
                $("#hub").removeClass("lists-2").addClass("lists-1");
            });

            if(Hub.notificationsCount == 0)
            $("#hub-empty").fadeIn();
        }
    },
    setAcceptedRequest: function(requestId, playerId) {
        if(playerId == "ok") {
            $(".hub-notification[request-id='" + requestId + "']").addClass("hub-notification-accepted")
            .children(".hub-notification-options").removeClass("options-2").addClass("options-1").children(".hub-notification-option-accept").remove();
        } else {
            $(".hub-notification[request-id='" + requestId + "']").children(".hub-notification-options").children(".hub-notification-option-accept")
            .addClass("hub-notification-option-accepted").removeClass("hub-notification-option-accept").html("Atendido por " + playerId);

            setTimeout(function() {
                $(".hub-notification[request-id='" + requestId + "']")
                .children(".hub-notification-options").children(".hub-notification-option-remove").trigger("click");
            }, 20000);
        }
    },
    playAudio: function() {
        if(!Hub.muted)
            $("#hub-audio")[0].play();
    },
    getDate: function() {
        let date = new Date();
        const [h, m, D, M] = [date.getHours(), date.getMinutes(), date.getDate(), date.getMonth()+1].map(String).map(s=>s.padStart(2,0));
        return `${h}:${m} ${D}/${M}`;
    }
};

function openNotifys() {
    $('.notify-content').is(':visible') ? $('.notify-content').hide('slow') : $('.notify-content').show('slow');
}

window.addEventListener('message', function(event) {
    let received = event.data;

    switch(received.action) {
        case 'open':
            Hub.toggle(true);
            break;
        case 'addNotification':
            Hub.addNotification(received.type, received.title, received.description, received.persistent);
            Hub.updateNotifys();
            break;
        case 'addRequest':
            Hub.addRequest(received.type, received.title, received.description, received.id);
            break;
        case 'setAcceptedRequest':
            Hub.setAcceptedRequest(received.id, received.user_id);
            break;
    }
});

window.onkeyup = function(data) {
    if (data.which == 27) {
        Hub.toggle(false);
        $('.notify-content').hide('slow')
        $.post("http://hub/close", JSON.stringify({}));
    } else if(data.which == 9) {
        Hub.toggleMuted();
    }
};