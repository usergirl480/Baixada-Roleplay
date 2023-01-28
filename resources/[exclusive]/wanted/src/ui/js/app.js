$(document).ready(function () {
  var isRunning = false;
  var timer = 0;
  var bar = new ldBar(".ldBar");
  $("body").fadeOut(200);

  window.addEventListener("message", function (event) {
    let point = event.data;
    if (point.timer) {
      timer = point.timer;
      $("body").fadeIn();

      function l() {
        let minutes = parseInt(timer / 60, 10);
        let seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        document.getElementById("timer").innerHTML = minutes + ":" + seconds;
        
        timer--;
        bar.set(timer, true);       

        isRunning = true;

        if (timer > 0) {
          setTimeout(l, 1000);
        } else {
          $("body").fadeOut(200);
          isRunning = false;
          timer = 0;
        }
      }

      if (isRunning === false) {
        l();
      }
    }
  });
});
