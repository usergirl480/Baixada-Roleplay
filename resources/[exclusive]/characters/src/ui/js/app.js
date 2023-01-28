let maxText = null;
let noList = null;
let count = 0;
let userCreateCharacter = false;
let userLogged = {};

$(document).ready(() => {
  window.addEventListener("message", (event) => {
    switch (event.data.action) {
      case "openSystem":
        app.open();
        app.generateDisplay();
      break;

      case "updateLocates": 
        app.updateSpawn(event.data.params);
      break;

      case "openSystem2":
        app.createCharacter2();
        app.generateDisplay();
      break;
    }
  });
});

const app = {
  open: (spawnList) => {
    $('body').show();
    $('#play').show();
  },
  close: () => {
    $('body').hide();
    window.location.reload();
  },
  createCharacter2: () => { 
    // window.location.reload();
    $('body').show();
    $('#play').show();
    $('.input-content input').val('');
    $('.characterItem:nth-child(1)').click();
  },
  updateSpawn: (spawnList) => { 
    $('btns-append').html('');
    if ( spawnList == "{}" || userCreateCharacter) {
      noList = true
      return;
    } 
    spawnList.forEach((k,v) => {
      $('btns-append').append(`
        <button class="input-item" data-id="${v+1}" onclick="app.spawnCharacter(this)">
          <div class="input">
            <span>${k[0]}</span>
          </div>
        </button>
      `);
    });
  },
  generateDisplay: () => {
    $.post("http://characters/generateDisplay",JSON.stringify({}),(data) => {
      let characters = data.params;

      $('#clock').html(data.timePlayed);

      maxText = data.max_chars
      data.chars <= 0 ? ( $('.play-game').hide(), $('.backBtn').hide() ) : ( $('.play-game').show(), $('.backBtn').show() );
      data.chars >= data.max_chars ? $('.create-item').prop('disabled', true) : $('.create-item').prop('disabled', false);
      
      $('.charactersContent').html('');
      characters.forEach(function(k,v) {
        // $('#coins').html(k.coins);

        if (k.allow_locates) {
          noList = true
        } 

        if (k.idLogged) {
          userLogged[k.userId] = true
        }
        
        $(".charactersContent").append(`
          <button class="player-item characterItem" onclick="app.characterSelect(this)">
            <i class="fa-solid fa-user"></i>
            <div class="info-player">
              <p>usuário</p>
              <span>${k.name} <b>#${k.userId}</b></span>
              <p>${k.surname}</p>
            </div>
          </button>
        `);
      });
      $('.characterItem:nth-child(1)').click();

      if (characters.length == 0) {
        app.createCharacter()
        $('#cancel-button').attr('disabled', 'disabled')
      }
	  });
  },
  createCharacter: () => {
    $('.sexOption').on('click', function() {
      $(".sexOption").removeClass('active');
      $(this).addClass('active');
    });
    $('.whereOption').on('click', function() {
      $(".whereOption").removeClass('active');
      $(this).addClass('active');
      $('#whereText').html($(this).html());
    });

    let options = {method: 'POST',body: JSON.stringify({})}
    fetch('http://characters/deletePed', options)
    $('main').hide();
    $('#form').fadeIn();
  },
  selectedSex: (sex) => {
    let options = {
      method: 'POST',
      body: JSON.stringify({ sex: sex })
    }
    fetch('http://characters/createSimplePed', options) // Quando o sexo do personagem é selecionado
  },
  characterSelect: (e) => {
    if ( maxText < 4 ) { 
      $(`.characterItem:nth-child(n+${maxText+1})`).prop('disabled', true);
      $(`.characterItem:nth-child(n+${maxText+1})`).html(`
          <i class="fa-solid fa-user"></i>
          <div class="info-player">
            <p>Bloqueado</p>
            <span>Renove seu VIP</span>
          </div>
      `);
    } 

    $('.characterItem').find('.check').remove();
    $('.characterItem').removeClass('active');
    $('.characterItem').prop('disabled', false);
    $(e).append('<i class="fa-light fa-circle-check check"></i>');
    $(e).prop('disabled', true);
    $(e).addClass('active');
    
    let userId = $(e).find('b').html().substring(1);
    let options = {
      method: 'POST',
      body: JSON.stringify({ id: parseInt(userId) })
    }
    fetch('http://characters/characterSelected', options) // Quando o personagem é selecionado
  },
  confirmForm: () => {
    let inputsValues = $('.input-content input').val();
    
    if (inputsValues == '') return;
    if (!$('.sexOption').hasClass('active')) return;
    if ($('#name').val() == "" || $('#lastname').val() == "" || $('#surname').val() == "") return;

    let formResult = {
      name: $('#name').val(),
      name2: $('#lastname').val(),
      surname: $('#surname').val(),
      gender: $('.sexs .active').attr('data-id'),
      where: $('.option-select .active').attr('data-id'),
    }
    userCreateCharacter = true
    let options = {
      method: 'POST',
      body: JSON.stringify({ result: formResult })
    }
    
    fetch('http://characters/createCharacter', options).then(resp => resp.json().then(data => {
      if (data.sucess)  {
        $("body").hide();
      }
    }))
  },
  cancelForm: () => {
    $('main').hide();
    $('#play').show();
    $('.input input').val('');
    $(".sexOption").removeClass('active');
    $(".whereOption").removeClass('active');
    $("#whereText").html('Como nos achou?');
    $('.characterItem:nth-child(1)').click();
  },
  playGame: () => {
    $('main').hide();
    $('#spawn').fadeIn();
    if (noList) {
      app.spawnCharacter();
    }
  },
  spawnCharacter: (ev) => {
    let choice = $(ev).attr('data-id');
    let userId = $('.charactersContent .active').find('b').html().substring(1);
    if (!userLogged[userId]) {
      let options = {
        method: 'POST',
        body: JSON.stringify({ userId: parseInt(userId), choice: choice == undefined ? 999 : parseInt(choice) })
      }
      $("body").hide();
      fetch('http://characters/spawnCharacter', options)
    }
  },
};

// $('input').keyup(function() {
//   if ($(this).val() == '') {
//     $(this).parent().find('.check').fadeOut();
//   } else {
//     $(this).parent().find('.check').fadeIn();
//   }
// });