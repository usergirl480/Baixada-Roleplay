const imagesUrl = "http://localhost/baixada/item/";

class MainRoutes {
    constructor() {
        this.items = []
    }
    load(items) {
        let arr = []
        for (let i in items) {
            items[i].index = i
            arr.push(items[i])
        }
        this.items = arr
        this.renderItemsPage()
    }
    renderItemsPage() {
        let container = document.querySelector('.items-container')
        container.innerHTML = ''

        for (let i in this.items) {
            container.innerHTML += `
            <div class="title">item</div>
            <div class="content" onclick="Main.selectRoute(event)" data-code="${this.items[i].index}">
                <div class="item-info">
                    <img src="${imagesUrl + (this.items[i].index)}.png">
                    <span>${this.items[i].name}</span>
                </div>
                <label><i class="fa-solid fa-street-view"></i></label>
            </div>
            `
        }
    }
    selectRoute(event) {
        if (document.querySelector('.activeItem')) {
            document.querySelector('.activeItem').classList.remove('activeItem')
        }
        let element = event.currentTarget
        element.classList.add('activeItem')
    }
    startRoute() {
        let activeItem = document.querySelector('.activeItem')
        if (!activeItem) return
        this.callServer("selectRoute", {code: activeItem.dataset.code});
    }
    callServer(endpoint, data, callback) {
        $.post("http://routes/" + endpoint, JSON.stringify(data), callback);
    }
    exit() {
        $("body").fadeOut();
        this.callServer("exit", {});
    }
};

var Main = new MainRoutes()
document.onkeyup = function(data) {
    if (data.which == 27) {
        Main.callServer("exit", {});
    }
};

window.addEventListener("message", function(event) {
    var action = event.data.action;
    switch(action) {
        case "open":
            $("body").fadeIn();
            Main.load(event.data.items);
        break;
        case "exit":
            $("body").fadeOut();
        break;
    }
});