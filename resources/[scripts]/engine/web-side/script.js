window.addEventListener('message', ({data}) => {
    if (data.show == true) {
        $('body').fadeIn(500)
    } else if (data.show == false) {
        $('body').fadeOut(500)
    }

    if (data.tank !== undefined) {
        document.querySelector('#tank').textContent = data.tank 
        document.querySelector('#price').textContent = data.price
        document.querySelector('#lts').textContent = data.lts 
    }
})

window.addEventListener('keyup', ({keyCode}) => {
    if (keyCode == '27') {
        this.JQ('body').fadeOut(500)

        let options = {
            method: 'POST',
            body: JSON.stringify({})
        }

        fetch('http://gas/closeSystem', options)
    } 
})