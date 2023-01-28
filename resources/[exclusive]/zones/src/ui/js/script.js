$(document).ready(function () {
  window.addEventListener("message", function (data) {
    $('#textSpawn').html(event.data.text);
    event.data.show === true ? ($('body').fadeIn(300)) : ($('body').fadeOut(300));
  });
});

document.addEventListener('keydown', function (e) {
  if (e.which == 18) {
    $.post('https://bxd-zones/bxdClose', JSON.stringify({}));
  }
});