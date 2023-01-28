$(document).ready(function () {
	const buttons = []
	const submenus = []

	$('#goback').hide()

	document.onkeyup = function (data) {
		if (data["which"] == 27) {
			buttons["length"] = 0;
			submenus["length"] = 0;

			$.post("http://dynamic/close");
			// $("button").remove();
			$(".list").empty();
			$("#title").html("");
			$('.background').fadeOut(200)
			$('#goback').hide()
		} else if (data["which"] == 8) {
			// $("button").remove();
			$(".list").empty();

			for (i = 0; i < buttons["length"]; ++i) {
				var div = buttons[i];
				var match = div.match("normalbutton");
				if (match) {
					$(".list").prepend(div);
				}
			}

			$(".list").append(submenus);
			$('.background').fadeIn(200)
		}
	}

	window.addEventListener("message", function (event) {
		var item = event["data"];

		if (item["addbutton"] == true) {
			if (item.id == false || null) {
				var b = (`<button id="normalbutton" data-trigger="` + item["trigger"] + `" data-parm="` + item["par"] + `" data-server="` + item["server"] + `" class="btn"><div class="title">` + item["title"] + `</div><div class="description" >` + item["description"] + `</div></button>`);
				buttons.push(b);
				return
			} else {
				var b = (`<button id="` + item["id"] + `"data-trigger="` + item["trigger"] + `" data-parm="` + item["par"] + `" data-server="` + item["server"] + `" class="a btn"><div class="title">` + item["title"] + `</div><div class="description" >` + item["description"] + `</div></button>`);
				buttons.push(b);
			}
		} else if (item["addmenu"] == true) {
			var aa = (`<button data-menu="` + item["menuid"] + `"class="b btn"><div class="title">` + item["title"] + `</div><div class="description" >` + item["description"] + `</div><i class="fas fa-chevron-right"></i></button>`)
			$(".list").append(aa);
			$('.background').fadeIn(200)
			submenus.push(aa);
		}

		if (item["close"] == true) {
			buttons["length"] = 0;
			submenus["length"] = 0;
			// $("button").remove();
			$(".list").empty();
			$("#title").html("");
			$('.background').fadeOut(200)
			$('#goback').hide()
		}
	});

	function goback() {
		// var gobackbutton = (``);
		// $(".list").append(gobackbutton)
		$('#goback').show()
		$('.background').fadeIn(200)
	}

	$("body").on("click", ".a", function () {
		$.post("http://dynamic/clicked", JSON.stringify({ trigger: $(this).attr("data-trigger"), param: $(this).attr("data-parm"), server: $(this).attr("data-server") }));
	});

	$("body").on("click", "#normalbutton", function () {
		$.post("http://dynamic/clicked", JSON.stringify({ trigger: $(this).attr("data-trigger"), param: $(this).attr("data-parm"), server: $(this).attr("data-server") }));
	});

	$("body").on("click", ".b", function () {
		goback();

		$(".b").remove();
		$(".a").remove();
		$("#normalbutton").remove();

		var menuid = $(this).attr("data-menu");
		for (i = 0; i < buttons["length"]; ++i) {
			var div = buttons[i];
			var match = div.match(`id="` + menuid + `"`);
			if (match) {
				$(".list").append(div);
			}
		}
	});

	$("body").on("click", "[id=goback]", function () {
		$(".b").remove();
		$(".a").remove();
		// $("button").remove();
		$(".list").append(submenus)
		$('#goback').hide()
		$('.background').fadeIn(200)

		for (i = 0; i < buttons["length"]; ++i) {
			var div = buttons[i];
			var match = div.match("normalbutton");
			if (match) {
				$(".list").append(div);
			}
		}
	});
});