var selectedCam =  null;

const TattooStore = {
	currentCategory: null,	
	selectedTattoos: {},
	categories: {
		"head": { "title": "Cabeça", "available": [] },
		"torso": { "title": "Torso", "available": [] },
		"leftarm": { "title": "Braço Esquerdo", "available": [] },
		"rightarm": { "title": "Braço Direito", "available": [] },
		"leftleg": { "title": "Perna Esquerda", "available": [] },
		"rightleg": { "title": "Perna Direita", "available": [] },
		"hair": { "title": "Micropigmentação", "available": [] }
	},
	changeCategory: function(category){
		$(".option").removeClass("active");
		TattooStore.currentCategory = category;
		$(".option[category-name='"+category+"']").addClass("active");
		$("#category-name").html(TattooStore.categories[category]["title"]);
		$("#items").html("");

		$('.items-head').html(TattooStore.categories[category]["title"])

		$.each(TattooStore.categories[category]["available"],function(index,tattoo){
			let selected =  "";
			let label = index + 1;

			if(TattooStore.selectedTattoos[tattoo.name])
				selected = " active-item";

			$("#items").append(`
				<div class="shop-item${selected}" 
				tattoo-code="${tattoo.name}" 
				tattoo-category="${category}" 
				tattoo-index="${index}">
				<div class="number">${label}</div>
			`);
		});
		TattooStore.loadVariableListeners();
	},
	selectTattoo: function(category,index){
		let item = $(".shop-item[tattoo-category='"+category+"'][tattoo-index='"+index+"']");
		if(item.hasClass("active-item")){
			item.removeClass("active-item");
			delete TattooStore.selectedTattoos[item.attr("tattoo-code")];
		} else {
			TattooStore.selectedTattoos[item.attr("tattoo-code")] = {};
			item.addClass("active-item");
		}

		TattooStore.callServer("changeTattoo",{ type: category, id: index });
	},
	resetTattoos: function(clear){
		$(".shop-item").removeClass("active-item");
		TattooStore.selectedTattoos = {};
		TattooStore.callServer("limpaTattoo",{});
	},
	loadStaticListeners: function(){
		$(".option").on("click",function(){
			TattooStore.changeCategory($(this).attr("category-name"));
		});

		$("#save").on("click",function(){
			$("body").fadeOut();
			TattooStore.callServer("close",{payment: true});
			window.location.reload();
		});

		$("#close").on("click",function(){
			$(".shop-item").removeClass("active-item");
			TattooStore.selectedTattoos = {};
			$("body").fadeOut();
			selectedCam = null;
			TattooStore.callServer("close",{payment: false});
		});

		$("#reset").on("click",function(){
			TattooStore.resetTattoos();
		});

		$(".set-camera").on("click", function(e) {
			e.preventDefault();
			var camValue = parseFloat($(this).data('value'));
			if (selectedCam == null) {
				$(this).addClass("selected-cam");
				$.post('http://tattoos/setupCam', JSON.stringify({
					value: camValue
				}));
				selectedCam = this;
			} else {
				if (selectedCam == this) {
					$(selectedCam).removeClass("selected-cam");
					$.post('http://tattoos/setupCam', JSON.stringify({
						value: 0
					}));
					selectedCam = null;
				} else {
					$(selectedCam).removeClass("selected-cam");
					$(this).addClass("selected-cam");
					$.post('http://tattoos/setupCam', JSON.stringify({
						value: camValue
					}));
					selectedCam = this;
				}
			}
		});

		document.onkeydown = function(data) {
			switch(data.keyCode) {
				case 27:
					$("body").fadeOut();
					selectedCam = null;
					window.location.reload();
					TattooStore.callServer("close",{payment:false});
				break;
				case 68:
					TattooStore.callServer("rotate","left");
				break;
				case 65:
					TattooStore.callServer("rotate","right");
				break;
				case 88:
					TattooStore.callServer("handsup",{});
				break;
			}
		};
	},
	loadVariableListeners: function(){
		$(".shop-item").on("click",function(){
			TattooStore.selectTattoo($(this).attr("tattoo-category"),$(this).attr("tattoo-index"));
		});
	},
	callServer: function(endpoint,data){
		$.post("http://tattoos/"+endpoint,JSON.stringify(data));
	},
	load: function(tattoos,selectedTattoos){
		TattooStore.categories = {
			"head": { "title": "Cabeça", "available": [] },
			"torso": { "title": "Torso", "available": [] },
			"leftarm": { "title": "Braço Esquerdo", "available": [] },
			"rightarm": { "title": "Braço Direito", "available": [] },
			"leftleg": { "title": "Perna Esquerda", "available": [] },
			"rightleg": { "title": "Perna Direita", "available": [] },
			"hair": { "title": "Micropigmentação", "available": [] }
		};
		$("body").fadeIn();
		TattooStore.selectedTattoos = selectedTattoos;
		$.each(tattoos,function(category,element){
			$.each(element.tattoo,function(index,tattoo){
				TattooStore.categories[category]["available"].push(tattoo);
			});
		});
		TattooStore.changeCategory("head");
		TattooStore.loadStaticListeners();
	}
};

window.addEventListener("message",function(event){
	TattooStore.load(event.data.shop,event.data.tattoo);
});