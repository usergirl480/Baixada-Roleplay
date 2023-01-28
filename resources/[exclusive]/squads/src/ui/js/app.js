let membersData;
let cacheOrgs = []
let currentPlayerId;
let currentTypeLeader;
let currentPlayerRank;

const rankSort = (a, b) => {
  const rank = b.group_rank - a.group_rank;
  if (rank) return rank;
  return b.name - a.name;
}

$(document).ready(function () {
  window.addEventListener("message", function (data) {
    if (event.data.show) {
      $('body').fadeIn(300);
      membersData = event.data.membersList;

      event.data.squadInfos.forEach(function (v, k) {
        let format = String(v.ranks)
        cacheOrgs = format.split(/\s*,\s*/);
        $('main').html(`
        <header>
            <div class="group-info">
              <div class="group-sigle">${String(v.squad).substring(0, 1)}</div>
              <div class="group-name">
                <small>${v.type}</small>
                <span>${v.squad}</span>
              </div>
            </div>
            <div class="group-search">
              <input id="search" onkeyup="searchMembers(this)" type="text" placeholder="pesquisar um membro">
              <i class="far fa-search"></i>
            </div>
        </header>

        <aside class="modalU" style="display: none;">
          <div class="close" onclick="menuClose()"><i class="fal fa-times"></i></div>
          <div class="item-aside active" onclick="changeSection('home',this)">
            <i class="fas fa-home"></i>
            <div class="item-name">
              <span>Início</span>
              <small>tipo: privado</small>
            </div>
          </div>
          <div class="item-aside" onclick="changeSection('profile',this)">
            <i class="fas fa-user"></i>
            <div class="item-name">
              <span>Perfil</span>
              <small>tipo: privado</small>
            </div>
          </div>
          <div class="item-aside">
            <i class="fas fa-layer-group"></i>
            <div class="item-name">
              <span>Loja</span>
              <small>tipo: líder</small>
            </div>
          </div>
        </aside>
    
        <div class="group-actions" style="display:none">
          <small>ações do grupo</small>
          <div class="icons">
            <div class="item addIcon" onclick="addMember()"><i class="fas fa-user-plus"></i></div>
            <div class="item editIcon" onclick="editMember()" style="display: none;margin-left: 10px;"><i class="fas fa-user-edit editIcon"></i></div>
          </div>
        </div>

        <section>
          <span>membros do grupo</span>
          <hr>
          <div class="group-table oldPages" id="home"><div class="table-content"></div></div>
          <div class="profile-content oldPages" id="profile" style="display:none">
            <div class="profile-banner">
              <div class="profile-single">${membersData[0].name.substr(0, 1)}</div>
            </div>
            <div class="profile-info">
              <span id="userName">${membersData[0].name}</span>
              <small>atualmente em <b>${v.squad}</b>.</small>
              <div class="profile-footer">
                <div class="profile-item">
                  <i class="fas fa-analytics"></i>
                  <div class="item-text">
                    <span>Seu Cargo</span>
                    <sub id="userRank">Carregando..</sub>
                  </div>
                </div>
                <div class="profile-item">
                  <i class="fas fa-users"></i>
                  <div class="item-text">
                    <span>Organização</span>
                    <sub>${v.squad}</sub>
                  </div>
                </div>
                <div class="profile-item">
                  <i class="fas fa-crown"></i>
                  <div class="item-text">
                    <span>Lider</span>
                    <sub id="liderName">Carregando..</sub>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <footer>
            <div class="icon"><i class="fal fa-signal-stream"></i></div>
            <div class="text">
              <span>Rádio</span>
              <small>frequência: <b>${v.radio}.00 MHz</b></small>
            </div>
          </footer>
        </section>

        <modal class="modalU" style="display:none">
          <div class="close" onclick="menuClose()"><i class="fal fa-times"></i></div>
          <div class="modal-options" id="addMember" style="display: none;">
            <input type="number" min="1" id="passport" placeholder="passaporte">
            <div class="btns">
            <button onclick="cancelModal()"><i class="fal fa-times"></i></button>
            <button onclick="contractPlayer()"><i class="far fa-check"></i></button>
            </div>
          </div>
          <div class="modal-options" id="typeModal" style="display: none;">
            <div class="option" onclick="editGroup()">
              <i class="fas fa-edit"></i>
              <div class="item-name">
                <span>Editar Cargo</span>
                <small>opção</small>
              </div>
            </div>
            <div class="option" onclick="removeMember()">
              <i class="fas fa-user-times"></i>
              <div class="item-name">
                <span>Remover Membro</span>
                <small>opção</small>
              </div>
            </div>
          </div>
          <div class="modal-options" id="editModal" style="display: none;">
            <div class="option" onclick="updatePlayer(3)" >
              <i class="fas fa-crown"></i>
              <div class="item-name">
                <span>Líder</span>
                <small>cargo</small>
              </div>
            </div>
            <div class="option" onclick="updatePlayer(2)" >
              <i class="fas fa-shield-alt"></i>
              <div class="item-name">
                <span>Gerente</span>
                <small>cargo</small>
              </div>
            </div>
            <div class="option" onclick="updatePlayer(1)" >
              <i class="fas fa-user"></i>
              <div class="item-name">
                <span>Membro</span>
                <small>cargo</small>
              </div>
            </div>
          </div>
          <div class="modal-options" id="checkModal" style="display: none;">
            <small>Tem Certeza ?</small>
            <div class="btns">
              <button onclick="confirmModal()"><i class="far fa-check"></i></button>
              <button onclick="cancelModal()"><i class="fal fa-times"></i></button>
            </div>
          </div>
        </modal>
        `);
        updateMembers();
        currentPlayerRank = $(`.userID${membersData[0].user_id}`).text().toLowerCase();
        currentPlayerRank === 'líder' || currentPlayerRank === 'gerente' ? $('.group-actions').fadeIn() : $('.group-actions').hide();

        $('#userRank').html(currentPlayerRank);
      });
    } else {
      $('body').fadeOut(300);
      window.location.reload();
    }
  });
});

function updateMembers() {
  $('.table-content').html('');
  const rows = membersData.sort(rankSort).map((v) => 
  `
    <div class="tbody exclusive${v.user_id}" onclick="selectMember(this,${v.user_id},${v.group_rank})">
      <div class="info-user">
        <div class="td"><p id="nameSelected">${v.name}</p> <b>#${v.user_id}</b></div>
        <div class="td rankUser">
          <img src="assets/${cacheOrgs[v.group_rank] === undefined ? 'Membro' : cacheOrgs[v.group_rank].normalize('NFD').replace(/[\u0300-\u036f]/g, "")}.png"> 
          <span class="rkn userID${v.user_id}">${cacheOrgs[v.group_rank]}</span>
        </div>
      </div>
      <div class="status-user">
        <div class="td">${v.last_login}</div>
        <div id="inGame"><div class=${v.is_online ? "online" : "offline"}></div> ${v.is_online ? "online" : "offline"}</div>
      </div>
    </div>
  `);
  $('.table-content').append(rows);
  $('#liderName').html($('.tbody:nth-child(1)').find('p').html())
}  

function selectMember(element,id,typeleader) {
  let ranking = $(element).find('.rkn').html().toLowerCase();
  let usernameSelected = $(element).find('#nameSelected').html();
  let username = $('#userName').html();

  if ( currentPlayerRank === 'líder' || currentPlayerRank === 'gerente' && usernameSelected !== username && ranking !== 'líder' ) {
    $('.tbody').removeClass('active');
    $(element).addClass('active');
    $('.editIcon').fadeIn();

    currentTypeLeader = cacheOrgs[typeleader].normalize('NFD').replace(/[\u0300-\u036f]/g, "");
    currentPlayerId = parseInt(id);
  }

}

function addMember() {
  $('.modal-options').hide();
  $('section').css('filter', 'blur(5px)');
  $('section').css('pointer-events', 'none');

  $('footer').hide();
  $('modal').fadeIn();
  $('#addMember').show();
}

function editMember() {
  $('.modal-options').hide();
  $('section').css('filter', 'blur(5px)');
  $('section').css('pointer-events', 'none');

  $('footer').hide();
  $('modal').fadeIn();
  $('#typeModal').show();
}

function cancelModal() {
  $('.modal-options').hide();
  $('modal').hide();
  $('footer').fadeIn();

  $('section').css('filter', 'blur(0px)');
  $('section').css('pointer-events', 'all');
  updateMembers();
}

function editGroup() {
  $('.modal-options').hide();
  $('#editModal').fadeIn();
}

function removeMember() {
  $('.modal-options').hide();
  $('#checkModal').fadeIn();
}

function confirmModal() {
  demotePlayerEvent();
}

function closeMenu() {
  currentPlayerId = null;
  currentTypeLeader = null;
  window.location.reload();
  $.post(`https://squads/closeMenu`, JSON.stringify({}));
}

function menuOpen() {
  $('aside').show();
  $('section').css('filter', 'blur(5px)');
  $('section').css('pointer-events', 'none');
}

function menuClose() {
  $('.modalU').hide();
  $('footer').fadeIn();
  $('section').css('filter', 'blur(0px)');
  $('section').css('pointer-events', 'all');
}

function changeSection(page,element) {
  $('.item-aside').removeClass('active');
  $('.oldPages').hide();
  $('#'+page).fadeIn();
  $(element).addClass('active');
  menuClose();
}

function demotePlayerEvent() {
  cancelModal();
  $('.exclusive'+currentPlayerId).css('background-color', 'rgba(250, 80, 80, 0.482)');
  $('.exclusive'+currentPlayerId).animate({left: "-8000px",}, 100, function() {$('.exclusive'+currentPlayerId).remove()});
  $.post(`https://squads/demotePlayer`, JSON.stringify({ user_id: currentPlayerId }));
}

function contractPlayer() { 
  cancelModal();
  closeMenu();
  $.post(`https://squads/contractPlayer`, JSON.stringify({ user_id: parseInt($('#passport').val()) }));
}

function updatePlayer(rank) { 
  cancelModal();
  $.post(`https://squads/updatePlayer`, JSON.stringify({ user_id: currentPlayerId, newRank: rank, type_leader: currentTypeLeader }));
  closeMenu();
}

function searchMembers(element) {
  var value = $(element).val().toLowerCase();
  $(".table-content .tbody").filter(function() {
    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
  });
}

document.addEventListener('keydown', function (e) {
  if (e.which == 27) {
    closeMenu()
  }
});

$('.close').on('click', function () {
  closeMenu()
});