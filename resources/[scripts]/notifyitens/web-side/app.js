$(document).ready(function(){
	window.addEventListener("message",function(event){
		var html = `
		<div class="item" id="${event.data.mode}">
			<div class="item-mode">${event.data.mode}</div>
			<img src="http://localhost/baixada/item/${event.data.item}.png">
			<div class="info-item">
				<div class="nameItem">${event.data.name}</div>
				<div class="itemRecive">${event.data.mode === 'recebeu' ? `+${event.data.amount}` : `-${event.data.amount}`}</div>
			</div>
		</div>`;

		$(html).fadeIn(800).appendTo("#notifyitens").delay(3000).fadeOut(500);
	})
});