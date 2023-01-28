const repNames = {
    hacking: "hacker",
    thief: "ladrão",
    runner: "corredor",
    fugitive: "fugitivo",
    hunting: "caçador",
    drugs: "drogas",
    taxi: "taxista",
    trucker: "caminhoneiro",
}

const reputation = {
    toggle: function (open, infos, squad) {
        if (open) {
            $("main").fadeIn(1000);

            const sorted = Object.entries(infos).sort((a, b) => b[1] - a[1])

            for (let [k, v] of sorted) {
                $('.rep-notifications').append(`
                    <div class="item">
                        <small>reputação: ${v / 100}% (${v})</small>
                        <strong>${repNames[k]}</strong>
                        <div class="bar"><div class="fill" style="width: ${v / 100}%;"></div></div>
                    </div>
                `)
            }

            if (squad !== undefined && squad.reputation !== undefined) {
                $('footer').html(`
                    <div class="icon">${String(squad.squadName).substring(0, 1)}</div>
                    <div class="info-fac">
                        <small>organização</small>
                        <sub>${squad.squadName}</sub>
                        <div class="bar"><div class="fill" style="width: ${squad.reputation / 10}%;"></div></div>
                    </div>
                    <div class="currentRep">
                        <small>reputação</small>
                        <span>${squad.reputation / 10}% (${squad.reputation})</span>
                    </div>
                `)
            } else {
                $('footer').html(`
                    <i class="fa-solid fa-square-exclamation"></i>
                    <p>
                        <b>informações</b>
                        <span>role para <opacity>ver mais</opacity></span>
                    </p>
                `)
            }
        } else {
            fetch('http://reputation/closeReputation')
            $("main").fadeOut(1000);
            window.location.reload();
        }
    },
}

window.addEventListener('message', function (event) {
    let received = event.data;
    switch (received.action) {
        case 'open':
            reputation.toggle(true, received.rep, received.squad);
            break;

        case 'close':
            reputation.toggle(false);
            break;
    }
});

window.onkeyup = function (data) {
    if (data.which == 27) {
        reputation.toggle(false);
    }
};