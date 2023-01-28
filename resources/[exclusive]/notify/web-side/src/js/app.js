function rNotify(e, t) {
	setTimeout(() => {
		e.classList.add('fadeOut')
	}, t / 2);
	setTimeout(() => {
		e.remove()
	}, t);
}

$(document).ready(function () {
	window.addEventListener("message", function (event) {
		if ( "kill" in event.data ) {
			var headshot = ''
			if (event.data.headshot) {
				// headshot = '<img class="headshot" src="./src/img/headshot.svg"/>'
			}
			if (event.data.roll) {
				// headshot = '<img class="headshot" src="./src/img/roll.svg"/>'
			}
			var html = ''
			if (event.data.killer.user_id != '' && event.data.killer.name != 'Safezone') {
				html = `
				<div class="notifyKill-container" id="killer-${event.data.killer.user_id}">
					<div class="notify-inner">
						<span>${event.data.killer.name} <span class="id">#${event.data.killer.user_id}</span></span>
						<div class="weapon"><img src="./src/img/${event.data.weapon}.png"> ${headshot}</div>
						<span>${event.data.victim.name} <span class="id">#${event.data.victim.user_id}</span></span>
					</div>
				</div>
				`
			} else {
				if (event.data.killer.name == 'Safezone') {
					html = `					
					<div class="notifyKill-container" id="killer-${event.data.killer.user_id}">
						<div class="notify-inner">
							<span>${event.data.victim.name} <span class="id">#${event.data.victim.user_id}</span></span>
							<div class="dicon"><img src="./src/img/safe.png"></div>
						</div>
					</div>
					`
				} else {
					html = `
					<div class="notifyKill-container" id="killer-${event.data.killer.user_id}">
						<div class="notify-inner">
							<span>${event.data.victim.name} <span class="id">#${event.data.victim.user_id}</span></span>
							<div class="dicon"><img src="./src/img/skull.png"></div>
						</div>
					</div>
					`
				}
			}
			$(html).fadeIn(200).appendTo("notify-kills").delay(3000).fadeOut(200)
			setTimeout(() => {
				$(`#killer-${event.data.killer.user_id}`).remove()
			}, 6000)
		}
		var localKey = 0
		if ( "css" in event.data ) {
			localKey++;

			var html = `
				<section id="css-${localKey}">
					<div class="icon">
						<img src="./src/img/${event.data.css ? event.data.css : 'default'}.svg">
					</div>
					<div class="notifyText">
						<p>${event["data"]["mensagem"]}</p>
					</div>
					<div class="progress"><div class="progressValue"></div></div>
				</section>
			`;

			$(html).fadeIn(200).appendTo(`.${event.data.position === undefined ? "normal" : `${event.data.position}`}`).delay(event["data"]["timer"]).fadeOut(200);
			$(`.progressValue`).css('transition', `width ${event["data"]["timer"]}ms`);
			setTimeout(() => {$(`.progressValue`).css('width', '0%');}, 100);

			setTimeout(() => {
				$(`#css-${localKey}`).remove()
			}, event["data"]["timer"])
		}
		
		var newsKey = 0
		if ('news' in event.data) {
			newsKey++;
			const news = `
				<div class="news" id="news-${newsKey}">
					<div class="n-progress">
						<div class="n-progress-value"></div>
					</div>
					<div class="news-content">
						<div class="news-icon">
							<img src="./src/img/news.svg" alt="news-icon">
						</div>
						<div class="news-message">
							<h3>${event.data.news.title}</h3>
							<p>${event.data.news.command}</p>
						</div>
					</div>
				</div>
			`

			$(news).fadeIn(200).appendTo('.news-list').delay(event.data.news.timer).fadeOut(200);
			$(`.n-progress-value`).css('transition', `height ${event.data.news.timer}ms`);
			setTimeout(() => {$(`.n-progress-value`).css('height', '0%');}, 100);

			setTimeout(() => {
				$(`#news-${newsKey}`).remove()
			}, event.data.news.timer+1000)
		}

		if ( "status" in event.data ) {event.data.status == false ? $('voipStatus').fadeOut() : $('voipStatus').fadeIn();}
	});
});


