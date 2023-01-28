var selectCraft = "selectCraft";

$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch (event.data.action){
			case "showNUI":
				selectCraft = event.data.name;
				$("body").show('slow');
				requestCrafting();
			break;

			case "hideNUI":
				$("body").fadeOut(800);
				$(".ui-tooltip").hide();
			break;

			case "requestCrafting":
				requestCrafting();
			break;
		}
	});

	document.onkeyup = (data) => {
		if (data["key"] === "Escape"){
			$.post("http://crafting/invClose");
		}
	};
});

const updateDrag = () => {
	$(".populated").draggable({
		helper: "clone",
		appendTo: 'main'
	});

	$(".empty").droppable({
		hoverClass: "hoverControl",
		drop: function (event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
			const target = $(this).data("slot");

			if (itemData.key === undefined || target === undefined) return;

			if (tInv === "invLeft"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/populateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				} else if (origin === "invRight"){
					itemData = { key: ui.draggable.data("item-key") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://crafting/functionCraft",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

					if (itemData.key === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/functionDestroy",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			}
		}
	});

	$(".populated").droppable({
		hoverClass: "hoverControl",
		drop: function (event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
			const target = $(this).data("slot");

			if (itemData.key === undefined || target === undefined) return;

			if (tInv === "invLeft"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/updateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				} else if (origin === "invRight"){
					itemData = { key: ui.draggable.data("item-key") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined || itemData.key !== $(this).data("item-key")) return;

					$.post("http://crafting/functionCraft",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

					if (itemData.key === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/functionDestroy",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
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
			const desc = $(this).attr("data-description");
			const name = $(this).attr("data-name-key");
			const recipe = $(this).attr("data-list");
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
                <div class='info'>${recipe}</div>
            </div>
        </div>`,
				position: { my: myLeg, at: "left+220" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
};

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

const requestCrafting = () => {
	$.post("http://crafting/requestCrafting",JSON.stringify({ craft: selectCraft }),(data) => {

		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}/${(data["invMaxpeso"]).toFixed(2)}<small>kg</small>`);
		setProgressWeight(data["invPeso"] / data["invMaxpeso"] * 100, '.progress-weight');

		$(".invLeft").html("");
		$(".invRight").html("");

		const nameList2 = data.inventoryCraft.sort((a,b) => a.name > b.name ? 1 : -1);

		for (let x = 1; x <= data["invMaxpeso"]; x++){
			const slot = x.toString();

			if (data.inventario[slot] !== undefined){
				const v = data.inventario[slot];
				const maxDurability = 86400 * v["days"];
				const newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `
				<div class="item populated" 
				data-item-key="${v.key}" 
				data-name-key="${v.name}" 
				data-amount="${v.amount}" 
				data-slot="${slot}">
					<div class="top">
						<span class="itemAmount">${formatarNumero(v.amount)}</span> <b>x</b> | 
						<span class="itemWeight">${(v.peso * v.amount).toFixed(2)}</span> <b>kg</b>
					</div>
					<img src="http://localhost/baixada/item/${v.index}.png">
					<div class="infoItem">
						<div class="bar" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
						<div class="name-item">${v.name}</div>
					</div>
				</div>
				`;
				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;
				$(".invLeft").append(item);
			}
		}

		for (let x = 1; x <= 50; x++){
			const slot = x.toString();

			if (nameList2[x - 1] !== undefined){
				const v = nameList2[x - 1];
				let list = "";

				for (let i in v.list){
					list = `${list}${v.list[i].amount}x ${v.list[i].name}, `;
				}

				list = list.substring(0,list.length - 2);
				const item = `<div class="item populated" title="" 
				data-item-key="${v.key}" 
				data-name-key="${v.name}" 
				data-list="${list}" 
				data-slot="${slot}" 
				data-description="${v["desc"]}">
					<div class="top">
						<span class="itemAmount">${formatarNumero(v.amount)}</span> <b>x</b> | 
						<span class="itemWeight">${v.peso.toFixed(2)}</span> <b>kg</b>
					</div>
					<img src="http://localhost/baixada/item/${v.index}.png">
					<div class="infoItem">
						<div class="name-item">${v.name}</div>
					</div>
				</div>
				`;
				// <div class="bar" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;
				$(".invRight").append(item);
			}
		}
		updateDrag();
	});
};

const formatarNumero = (n) => {
	var n = n.toString();
	var r = "";
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
		x = x == 2 ? 0 : x + 1;
	}

	return r.split("").reverse().join("");
};

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
