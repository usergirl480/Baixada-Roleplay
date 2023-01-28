$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				requestChest();
				$("body").show('slow');
			break;

			case "hideMenu":
				$("body").fadeOut(800);
				$(".ui-tooltip").hide();
			break;

			case "requestChest":
				requestChest();
			break;

			case "updateWeight":
				$("#weightTextLeft").html(`${(event["data"]["invPeso"]).toFixed(2)}/${(event["data"]["invMaxpeso"]).toFixed(2)}<small>kg</small>`);
				$("#weightTextRight").html(`${(event["data"]["chestPeso"]).toFixed(2)}/${(event["data"]["chestMaxpeso"]).toFixed(2)}<small>kg</small>`);
				setProgressWeight(event["data"]["invPeso"] / event["data"]["invMaxpeso"] * 100, '.progress-weight');
				setProgressWeight(event["data"]["chestPeso"] / event["data"]["chestMaxpeso"] * 100, '.progress-weight2');
			break;
		}
	});

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://homes/invClose");
		}
	};

	$('body').mousedown(e => {
		if(e.button == 1) return false;
	});
});

const updateDrag = () => {
	$(".populated").draggable({
		helper: "clone",
		appendTo: 'main'
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;
			
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			$('.populated, .empty').off("draggable droppable");

			let clone1 = ui.draggable.clone();
			let slot2 = $(this).data("slot"); 

			if(amount == itemAmount) {
				let clone2 = $(this).clone();
				let slot1 = ui.draggable.data("slot");

				$(this).replaceWith(clone1);
				ui.draggable.replaceWith(clone2);
				
				$(clone1).data("slot", slot2);
				$(clone2).data("slot", slot1);
			} else {
				let newAmountOldItem = itemAmount - amount;
				let weight = parseFloat(ui.draggable.data("peso"));
				let newWeightClone1 = (amount*weight).toFixed(2);
				let newWeightOldItem = (newAmountOldItem*weight).toFixed(2);

				ui.draggable.data("amount",newAmountOldItem);

				clone1.data("amount",amount);

				$(this).replaceWith(clone1);
				$(clone1).data("slot",slot2);

				ui.draggable.children(".top").children(".itemAmount").html(formatarNumero(ui.draggable.data("amount")));
				ui.draggable.children(".top").children(".itemWeight").html(newWeightOldItem);
				
				$(clone1).children(".top").children(".itemAmount").html(formatarNumero(clone1.data("amount")));
				$(clone1).children(".top").children(".itemWeight").html(newWeightClone1);
			}

			updateDrag();

			if (origin === "invLeft" && tInv === "invLeft"){
				$.post("http://inventory/updateSlot",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invRight" && tInv === "invLeft"){
				$.post("http://homes/takeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invLeft" && tInv === "invRight"){
				$.post("http://homes/storeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invRight" && tInv === "invRight"){
				$.post("http://homes/updateChest",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			}

			$(".amount").val("");
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			$('.populated, .empty, .use').off("draggable droppable");

			if(ui.draggable.data('item-key') == $(this).data('item-key')){
				let newSlotAmount = amount + parseInt($(this).data('amount'));
				let newSlotWeight = ui.draggable.data("peso") * newSlotAmount;

				$(this).data('amount',newSlotAmount);
				$(this).children(".top").children(".itemAmount").html(formatarNumero(newSlotAmount));
				$(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

				if(amount == itemAmount) {
					ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
				} else {
					let newMovedAmount = itemAmount - amount;
					let newMovedWeight = parseFloat(ui.draggable.data("peso")) * newMovedAmount;

					ui.draggable.data('amount',newMovedAmount);
					ui.draggable.children(".top").children(".itemAmount").html(formatarNumero(newMovedAmount));
					ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
				}
			} else {
				if (origin === "invRight" && tInv === "invLeft") return;

				let clone1 = ui.draggable.clone();
				let clone2 = $(this).clone();

				let slot1 = ui.draggable.data("slot");
				let slot2 = $(this).data("slot");

				ui.draggable.replaceWith(clone2);
				$(this).replaceWith(clone1);

				$(clone1).data("slot",slot2);
				$(clone2).data("slot",slot1);
			}

			updateDrag();

			if (origin === "invLeft" && tInv === "invLeft") {
				$.post("http://inventory/updateSlot",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invRight" && tInv === "invLeft"){
				$.post("http://homes/takeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invLeft" && tInv === "invRight"){
				$.post("http://homes/storeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invRight" && tInv === "invRight"){
				$.post("http://homes/updateChest",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			}

			$(".amount").val("");
		}
	});

	$(".populated").tooltip({
		create: function(event,ui){
			var serial = $(this).attr("data-serial");
			var economy = $(this).attr("data-economy");
			var desc = $(this).attr("data-description");
			var amounts = $(this).attr("data-amount");
			var name = $(this).attr("data-name-key");
			var weight = $(this).attr("data-peso");
			var type = $(this).attr("data-type");
			var max = $(this).attr("data-max");
			var myLeg = "center top-20";

			if (desc !== "undefined"){
				myLeg = "center top-20";
			}

			$(this).tooltip({
				content: `
        <div class='tooltip'>
            <div class='tooltip-title'>
                <div class='mark'>descrição</div>
                <li>${name}</li>
            </div>
            <p>${desc !== "undefined" ? desc : "Item sem descrição, mas poderá ser adicionado posteriormente."}</p>
            <div class='info-item'>
                <div class='info'>${serial !== "undefined" ? " <r>"+serial+"</r>":" <r>"+type+"</r>"}</div>
                <div class='info'>${max !== "undefined" ? max:"S/L"}</div>
                <div class='info'>${(weight * amounts).toFixed(2)}kg</div>
            </div>
        </div>`,
				position: { my: myLeg, at: "left+220" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
}

const colorPicker = (percent) => {
	var colorPercent = "#848CEB";
	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";
	if (percent >= 51 && percent <= 75)
		colorPercent = "#848CEB";
	if (percent >= 26 && percent <= 50)
		colorPercent = "#848CEB";
	if (percent <= 25)
		colorPercent = "#fc5858";
	return colorPercent;
}

const requestChest = () => {
	$.post("http://homes/requestChest",JSON.stringify({}),(data) => {

		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}/${(data["invMaxpeso"]).toFixed(2)}<small>kg</small>`);
		$("#weightTextRight").html(`${(data["chestPeso"]).toFixed(2)}/${(data["chestMaxpeso"]).toFixed(2)}<small>kg</small>`);
		setProgressWeight(data["invPeso"] / data["invMaxpeso"] * 100, '.progress-weight');
		setProgressWeight(data["chestPeso"] / data["chestMaxpeso"] * 100, '.progress-weight2');

		$(".invLeft").html("");
		$(".invRight").html("");

		for (let x = 1; x <= data["invMaxpeso"]; x++){
			const slot = x.toString();

			if (data.myInventory[slot] !== undefined){
				const v = data.myInventory[slot];
				const maxDurability = 86400 * v["days"];
				const newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" data-amount="${v.amount}" data-peso="${v.peso}" data-item-key="${v.key}" data-name-key="${v.name}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<span class="itemAmount">${formatarNumero(v.amount)}</span> <b>x</b> | 
						<span class="itemWeight">${(v.peso * v.amount).toFixed(2)}</span> <b>kg</b>
					</div>
					<img src="http://localhost/baixada/item/${v.index}.png">
					<div class="infoItem">
						<div class="bar" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
						<div class="name-item">${v.name}</div>
					</div>
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invLeft").append(item);
			}
		}

		for (let x = 1; x <= 100; x++){
			const slot = x.toString();

			if (data.myChest[slot] !== undefined){
				const v = data.myChest[slot];
				const maxDurability = 86400 * v["days"];
				const newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" data-amount="${v.amount}" data-peso="${v.peso}" data-item-key="${v.key}" data-name-key="${v.name}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<span class="itemAmount">${formatarNumero(v.amount)}</span> <b>x</b> | 
						<span class="itemWeight">${(v.peso * v.amount).toFixed(2)}</span> <b>kg</b>
					</div>
					<img src="http://localhost/baixada/item/${v.index}.png">
					<div class="infoItem">
						<div class="bar" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
						<div class="name-item">${v.name}</div>
					</div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}
		updateDrag();
	});
}

const formatarNumero = n => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

function setProgressWeight(percent, element){
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var percent = percent * 100 / 175;
  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;
  const offset = circumference - ((-percent*73)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;
}
