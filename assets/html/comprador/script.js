const box = (type, message)=>{
    let box = document.querySelector(".alert")
    switch(type){
        case "error":
            mta.triggerEvent("victor:infobox:vendedor", "error", message)
            break
        case "success":
            mta.triggerEvent("victor:infobox:vendedor", "success", message)
            break
    }
}
const valor = (valor) =>{ // coloca valor no painel
    let a = parseInt(valor)
    let b = a.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
    let c = document.querySelector("#value-vehicle")
    c.innerHTML = b

}


const interaction = (type)  =>{
    switch(type){
        case "Assinar":
            mta.triggerEvent("victor:comprador:assinar")
            break
        case "Recusar":
            //chama mta pra fechar o painel
            mta.triggerEvent("victor:comprador:close")
            break
    }
}
