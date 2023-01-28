let QBClothing = {}

let selectedCam = null;
let clothingCategorys;
let currentMaxValues;
let changingCat;
let currentSex;
let currentColorSelected;

const skinData = {
	pants: { defaultItem: 0, defaultTexture: 0, category: 'legs', cat: 'CALÇA' },
	arms: { defaultItem: 0, defaultTexture: 0, category: 'torso', cat: 'MÃOS' },
	tshirt: { defaultItem: 1, defaultTexture: 0, category: 'torso', cat: 'CAMISA' },
	torso: { defaultItem: 0, defaultTexture: 0, category: 'torso', cat: 'JAQUETA' },
	vest: { defaultItem: 0, defaultTexture: 0, category: 'torso', cat: 'COLETE' },
	backpack: { defaultItem: 0, defaultTexture: 0, category: 'accessory', cat: 'MOCHILA' },
	shoes: { defaultItem: 1, defaultTexture: 0, category: 'legs', cat: 'SAPATOS' },
	mask: { defaultItem: 0, defaultTexture: 0, category: 'head', cat: 'MÁSCARA' },
	hat: { defaultItem: -1, defaultTexture: 0, category: 'head', cat: 'CHAPÉU' },
	glass: { defaultItem: 0, defaultTexture: 0, category: 'head', cat: 'ÓCULOS' },
	ear: { defaultItem: -1, defaultTexture: 0, category: 'head', cat: 'ORELHA' },
	mochila: { defaultItem: -1, defaultTexture: 0, category: 'accessory', cat: 'MOCHILA' },
	watch: { defaultItem: -1, defaultTexture: 0, category: 'accessory', cat: 'RELÓGIO' },
	bracelet: { defaultItem: -1, defaultTexture: 0, category: 'accessory', cat: 'BRACELETE' },
	accessory: { defaultItem: 0, defaultTexture: 0, category: 'accessory', cat: 'ACESSÓRIOS' },
	decals: { defaultItem: 0, defaultTexture: 0, category: 'accessory', cat: 'ADESIVOS' }
}

$(document).on('click', '.set-camera', function (e) {
	e.preventDefault();
	let camValue = parseFloat($(this).data('value'));
	if (selectedCam == null) {
		$(this).addClass("selected-cam");
		$.post('http://skinshop/setupCam', JSON.stringify({
			value: camValue
		}));
		selectedCam = this;
	} else {
		if (selectedCam == this) {
			$(selectedCam).removeClass("selected-cam");
			$.post('http://skinshop/setupCam', JSON.stringify({
				value: 0
			}));
			selectedCam = null;
		} else {
			$(selectedCam).removeClass("selected-cam");
			$(this).addClass("selected-cam");
			$.post('http://skinshop/setupCam', JSON.stringify({
				value: camValue
			}));
			selectedCam = this;
		}
	}
});

$(document).ready(function () {
	document.onkeydown = function (data) {
		switch (data.keyCode) {
			case 27:
				$("body").fadeOut(200, () => {
					QBClothing.Close({ restore: true });
				});
				break;
			case 68:
				$.post('http://skinshop/RotatePlayer', JSON.stringify({ left: true }));
				break;
			case 65:
				$.post('http://skinshop/RotatePlayer', JSON.stringify({ right: true }));
				break;
		}
	};
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case "open":
				currentSex = event.data.currentGender;
				$("body").fadeIn();
				clothingCategorys = event.data.currentClothing;
				$('#firstClick').click();
				QBClothing.SetCurrentValues(clothingCategorys);
				break;
			case "close":
				$("body").hide();
				QBClothing.Close();
				break;
			case "updateMax":
				currentMaxValues = event.data.maxValues
				break;
		}
	})
});

$(document).on('click', "#save", function (e) {
	e.preventDefault();
	QBClothing.Close({ restore: false });
	$.post('http://skinshop/saveClothing');
});

$(document).on('click', "#reset", function (e) {
	e.preventDefault();
	QBClothing.Close({ restore: true });
	$.post('http://skinshop/resetOutfit');
});

QBClothing.Close = function (data) {
	$.post('http://skinshop/close', JSON.stringify(data));
	window.location.reload();
}

QBClothing.SetCurrentValues = function (clothingValues) {
	// console.log('SetCurrentValues: ', JSON.stringify(clothingValues))
	clothingCategorys = clothingValues
	for (var key in clothingValues) {
		let item = clothingValues[key]
		let maxValue = parseInt(currentMaxValues[key].item);

		let clothLabel = $('.shop-item[data-type="' + key + '"] #cloth-label')

		clothLabel.html(item.item + '/' + maxValue)
		clothLabel.data('number', item.item)
		// console.log('SET CLOTH ITEM: ', key, '/', JSON.stringify(item))
	}
}

$(document).on('click', ".category", function () {
	$('.category').removeClass('active');
	$(this).addClass('active');
	$('.invert').html('');
	changingCat = this;

	if ($('color-shop').is(':visible')) { $('color-shop').hide('slow') }
	let category = $(this).data('type2');

	for (var typeCloth in skinData) {
		let skin = skinData[typeCloth]
		if (skin.category == category && currentMaxValues[typeCloth]) {
			let maxValue = parseInt(currentMaxValues[typeCloth].item);

			let max_textures = currentMaxValues[typeCloth].texture
			$('.invert').append(`
				<div class="shop-item" id="clothe${currentMaxValues[typeCloth].id}" data-type="${typeCloth}" data-id="${currentMaxValues[typeCloth].id}">
					<div class="item-title">${skin.cat}</div>
					<div class="inputTextures">
						<div class="arrow" class="btn-left" data-type="${typeCloth}" id="cloth-left"><i class="fa-solid fa-angle-left"></i></div>
						<label id="cloth-label" data-number="0">0/${maxValue}</label>
						<div class="arrow" class="btn-right" data-type="${typeCloth}" id="cloth-right"><i class="fa-solid fa-angle-right"></i></div>
					</div>
					<div class="inputTextures">
						<div class="arrow" class="btn-left" data-type="${typeCloth}" id="color-left"><i class="fa-solid fa-angle-left"></i></div>
						<label id="texture-label" data-number="0">0/${max_textures}</label>
						<div class="arrow" class="btn-right" data-type="${typeCloth}" id="color-right"><i class="fa-solid fa-angle-right"></i></div>
					</div>
				</div>
			`)
		}
	}

	QBClothing.SetCurrentValues(clothingCategorys);
});

$(document).ready(function() {
	var timeOut = 0;
	$(document).on('mousedown touchstart', '#cloth-right', function(e) {
		var elem = this
	  timeOut = setInterval(function(){
		$(elem).click()
	  }, 100);
	}).bind('mouseup mouseleave touchend', function() {
	  clearInterval(timeOut);
	});
	var timeOut = 0;
	$(document).on('mousedown touchstart', '#cloth-left', function(e) {
		var elem = this
	  timeOut = setInterval(function(){
		$(elem).click()
	  }, 100);
	}).bind('mouseup mouseleave touchend', function() {
	  clearInterval(timeOut);
	});
});

$(document).on('click', '#cloth-right', function (e) {
	e.preventDefault();
	let typeCloth = $(this).data('type');
	let clothLabel = $(`#clothe${currentMaxValues[typeCloth].id} #cloth-label`)
	currentClothSelected = clothLabel.data('number');
	let maxValue = parseInt(currentMaxValues[typeCloth].item);

	if (currentClothSelected >= maxValue) {
		currentClothSelected = 0
	} else {
		currentClothSelected += 1
	}

	clothLabel.html(currentClothSelected + '/' + maxValue)
	clothLabel.data('number', currentClothSelected)

	clothingCategorys[typeCloth].item = currentClothSelected
	QBClothing.SetCurrentValues(clothingCategorys);
	$.post('http://skinshop/updateSkin', JSON.stringify({
		clothingType: typeCloth,
		articleNumber: currentClothSelected,
		type: 'item',
	}));
});

$(document).on('click', '#cloth-left', function (e) {
	e.preventDefault();
	let typeCloth = $(this).data('type');
	let clothLabel = $(`#clothe${currentMaxValues[typeCloth].id} #cloth-label`)
	currentClothSelected = clothLabel.data('number');
	let maxValue = parseInt(currentMaxValues[typeCloth].item);

	if (currentClothSelected == 0) {
		currentClothSelected = maxValue
	} else {
		currentClothSelected -= 1
	}

	clothLabel.html(currentClothSelected + '/' + maxValue)
	clothLabel.data('number', currentClothSelected)

	clothingCategorys[typeCloth].item = currentClothSelected
	QBClothing.SetCurrentValues(clothingCategorys);
	$.post('http://skinshop/updateSkin', JSON.stringify({
		clothingType: typeCloth,
		articleNumber: currentClothSelected,
		type: 'item',
	}));
});

$(document).on('click', '#color-right', function (e) {
	e.preventDefault();
	let typeCloth = $(this).data('type');
	let colorLabel = $(`#clothe${currentMaxValues[typeCloth].id} #texture-label`)
	currentColorSelected = colorLabel.data('number');
	let max_textures = currentMaxValues[typeCloth].texture

	if (currentColorSelected >= max_textures) {
		currentColorSelected = 0
	} else {
		currentColorSelected += 1
	}

	colorLabel.html(currentColorSelected + '/' + max_textures)
	colorLabel.data('number', currentColorSelected)

	clothingCategorys[typeCloth].texture = currentColorSelected
	QBClothing.SetCurrentValues(clothingCategorys);
	$.post('http://skinshop/updateSkin', JSON.stringify({
		clothingType: typeCloth,
		articleNumber: currentColorSelected,
		type: 'texture',
	}));
});

$(document).on('click', '#color-left', function (e) {
	e.preventDefault();
	let typeCloth = $(this).data('type');
	let colorLabel = $(`#clothe${currentMaxValues[typeCloth].id} #texture-label`)
	currentColorSelected = colorLabel.data('number');
	let max_textures = currentMaxValues[typeCloth].texture

	if (currentColorSelected == 0) {
		currentColorSelected = max_textures
	} else {
		currentColorSelected -= 1
	}

	colorLabel.html(currentColorSelected + '/' + max_textures)
	colorLabel.data('number', currentColorSelected)

	clothingCategorys[typeCloth].texture = currentColorSelected
	QBClothing.SetCurrentValues(clothingCategorys);
	$.post('http://skinshop/updateSkin', JSON.stringify({
		clothingType: typeCloth,
		articleNumber: currentColorSelected,
		type: 'texture',
	}));
});

$(document).on('click', '.option', function (e) {
	e.preventDefault();
	$('.option').removeClass('active');
	$(this).addClass('active');
	$('.category').hide();
	$('.' + $(this).data('category')).show();
});

$('#rotatePerson').on('input', function (e) {
	$.post('http://creation/cChangeHeading', JSON.stringify({ camRotation: e.target.value }));
});