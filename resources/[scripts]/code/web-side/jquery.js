/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["code"] == true){
			$("#divCode").css("display","flex");
		}

		if (event["data"]["code"] == false){
			$("#divCode").css("display","none");
		}

		if (event["data"]["radar"] == true){
			$("#divRadar").css("display","flex");
		}

		if (event["data"]["radar"] == false){
			$("#divRadar").css("display","none");
		}

		if ( event["data"]["radar"] == "top" ){
			$("#topRadar").html(`
				<div class="item">Placa: <span>${event["data"]["plate"]}</span></div>
				<div class="item">Modelo: <span>${event["data"]["model"]}</span></div>
				<div class="item">Velocidade: <span>${parseInt(event["data"]["speed"])}</span></div>
			`);
		}

		if (event["data"]["radar"] == "bot"){
			$("#botRadar").html(`
				<div class="item">Placa: <span>${event["data"]["plate"]}</span></div>
				<div class="item">Modelo: <span>${event["data"]["model"]}</span></div>
				<div class="item">Velocidade: <span>${parseInt(event["data"]["speed"])}</span></div>
			`);
		}
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://code/closeSystem");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
const clickCode = (data) => {
	$.post("http://code/sendCode",JSON.stringify({ code: data }));
};