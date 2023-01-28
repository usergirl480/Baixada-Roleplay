$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["show"] == true){
			var key = event["data"]["key"] !== undefined ? `<div id="key"><div>${event["data"]["key"]}</div></div>`:""
			$("#displayNotify").html(key + `<span>${event["data"]["legend"]} com <b>${event["data"]["title"]}</b></span>`);
			$("body").fadeIn(250);
		}
		if (event["data"]["show"] == false){
			$("body").fadeOut(250);
		}
	});
});