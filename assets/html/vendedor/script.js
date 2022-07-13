function checkColor(){
    let pagina = document.querySelector("#content-value")
    if(pagina.value.length > 6){
        pagina.style.border = "1px solid red"
    }else if(pagina.value.length == 6 || pagina.value.length < 6){
        pagina.style.border = "1px solid green"
    }
}




function formatarMoeda(page) {
    if(page.value.length > 7){
        return false
    }
    setTimeout(()=>{
        let a = parseInt(page.value)
        let b = a.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        let c = document.querySelector("#vehicle-value")
        c.innerHTML = b
        
    }
    ,0100)
  }

let idVender = document.getElementById("content-passaporte")
let valorVender = document.querySelector("#content-value").value


const interaction = (type)  =>{
    switch(type){
        case "Vender":
            let idVender = document.querySelector("#content-passaporte")
            let valorVender = document.querySelector("#content-value").value
            if(idVender.value.length < 1 || idVender.value.length > 4){
                document.querySelector("#content-passaporte").style.color = "1px solid red"
                mta.triggerEvent("victor:infobox", "error", "Verifique o passaporte!")
                return false
            }else if(valorVender.length > 6){
                document.querySelector("#content-value").style.color = "1px solid red"
                mta.triggerEvent("victor:infobox", "error", "Valor acima de 6 digitos!")
                return false
            }else{
                mta.triggerEvent("victor:vendedor:confirmpanel", idVender.value, document.querySelector("#content-value").value)
                mta.triggerEvent("victor:infobox", "success", "Trasferência enviada")
                idVender.value = ""
                document.querySelector("#content-value").value = ""
                document.querySelector("#content-value").style.border = "0"
            }



            break
        case "Desistir":
            //chama mta pra fechar o painel
            mta.triggerEvent("victor:vendedor:fechar")
            break
    }
}


document.addEventListener('keypress', (e)=>{
    let tecla = e.key
    if(tecla == "Backspace"){
        let pagina = document.querySelector("#content-value")
        if(pagina.value.length > 6){
            pagina.style.border = "1px solid red"
        }else if(pagina.value.length == 6 || pagina.value.length < 6){
            pagina.style.border = "1px solid green"
        }
    }
})