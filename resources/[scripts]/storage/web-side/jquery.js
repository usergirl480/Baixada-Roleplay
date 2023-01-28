var selectShop = "selectShop";
var selectType = "Buy";
/* --------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showNUI":
				selectShop = event.data.name;
				selectType = event.data.type;
				$("body").show('slow');
				requestStorage();
			break;

			case "hideNUI":
				$("body").fadeOut(800);
				$(".ui-tooltip").hide();
			break;

			case "requestStorage":
				requestStorage();
			break;
		}
	});

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://storage/close");
		}
	}
});
/* --------------------------------------------------- */
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

			let amount = $(".amount").val();
			if (shiftPressed) amount = ui.draggable.data('amount');

			if (tInv === "invLeft"){
				if (origin === "invLeft"){
					$.post("http://storage/populateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}))

					$(".amount").val("");
				} else if (origin === "invRight"){
					$.post("http://storage/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft" && selectType === "Sell"){
					$.post("http://storage/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			}
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

			let amount = $(".amount").val();
			if (shiftPressed) amount = ui.draggable.data('amount');


			if (tInv === "invLeft" ){
				if (origin === "invLeft"){
					$.post("http://storage/updateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				} else if (origin === "invRight"){
					$.post("http://storage/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft" && selectType === "Sell"){
					$.post("http://storage/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			}
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
            <p>${desc !== "undefined" ? desc : "Atualmente temos <b>"+economy+"</b> em estoque."}</p>
            <div class='info-item'>
                <div class='info'>${serial !== "undefined" ? " <r>"+serial+"</r>":" <r>"+type+"</r>"}</div>
                <div class='info'>${max !== "undefined" ? max:"S/L"}</div>
                <div class='info'>${weight}kg</div>
            </div>
        </div>`,
				position: { my: myLeg, at: "left+220" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
}
/* --------------------------------------------------- */
const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
/* --------------------------------------------------- */
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

const requestStorage = () => {
	$.post("http://storage/requestStorage",JSON.stringify({ shop: selectShop }),(data) => {
		
		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}/${(data["invMaxpeso"]).toFixed(2)}<small>kg</small>`);
		setProgressWeight(data["invPeso"] / data["invMaxpeso"] * 100, '.progress-weight');

		$(".invLeft").html("");
		$(".invRight").html("");

		for (let x = 1; x <= data["invMaxpeso"]; x++){
			const slot = x.toString();

			if (data.inventoryUser[slot] !== undefined){
				const v = data["inventoryUser"][slot];
				const maxDurability = 86400 * v["days"];
				const newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `
				<div class="item populated" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-peso="${v["peso"]}" data-amount="${v["amount"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<span class="itemAmount">${formatarNumero(v.amount)}</span> <b>x</b> | 
						<span class="itemWeight">${(v.peso * v.amount).toFixed(2)}</span><b>kg</b>
					</div>
					<img src="http://localhost/baixada/item/${v.index}.png">
					<div class="infoItem">
						<div class="bar" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
						<div class="name-item">${v["name"]}</div>
					</div>
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invLeft").append(item);
			}
		}

		const nameList2 = data.inventoryShop.sort((a,b) => (a.name > b.name) ? 1: -1);

		for (let x = 1; x <= data["shopSlots"]; x++){
			const slot = x.toString();

			if (nameList2[x-1] !== undefined){
				const v = nameList2[x - 1];

				const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-price="${v["price"]}" data-peso="${v["peso"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<span class="itemWeight itemPrice">$${formatarNumero(v["price"])}</span>
					</div>
					<img src="http://localhost/baixada/item/${v.index}.png">
					<div class="infoItem">
						<div class="bar"></div>
						<div class="name-item">${v["name"]}</div>
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

function somenteNumeros(e){
	var charCode = e.charCode ? e.charCode : e.keyCode;
	if (charCode != 8 && charCode != 9){
		var max = 9;
		var num = $(".amount").val();

		if ((charCode < 48 || charCode > 57)||(num.length >= max)){
			return false;
		}
	}
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