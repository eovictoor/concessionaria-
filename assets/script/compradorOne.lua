diretorio2 = "http://mta/174_Concessionaria/assets/html/comprador/index.html"
valor = 0
contaVendedor = 0
memoriaVendedor = 0
addEvent("victor:infobox:vendedor", true)
addEventHandler("victor:infobox:vendedor", root, function(type, message)
    if type == "error" then
        exports.FogtzInfoV2:showInfobox(message,"error")
    elseif type == "success" then 
        exports.FogtzInfoV2:showInfobox(message,"success")
    end
end)

function compradorInit(nome_veiculo, valor_veiculo, conta_vendedor, memoria_vendedor, idBanco)
    idBancoDb = idBanco
    valor = valor_veiculo
    contaVendedor = conta_vendedor
    memoriaVendedor = memoria_vendedor
    largura, altura = guiGetScreenSize()
    raizBrowser = guiCreateBrowser(0,0, largura, altura, true, true, false)
    browser2 = guiGetBrowser(raizBrowser)
    addEventHandler("onClientBrowserCreated", browser2, function()
        loadBrowserURL(browser2, diretorio2)
    end)
    addEventHandler("onClientBrowserDocumentReady", root, function(url)
        if url == diretorio2 then 
            showCursor(true)
            guiSetInputEnabled(true)
            executeBrowserJavascript(browser2, "document.getElementById('saler-name').innerHTML = '"..getPlayerName(memoria_vendedor).."'")
            executeBrowserJavascript(browser2, "document.querySelector('#name-vehicle').innerHTML = '"..nome_veiculo.."'")
            executeBrowserJavascript(browser2, "valor('"..valor_veiculo.."')")
        end

    end)
end

addEvent("victor:comprador:open", true)
addEventHandler("victor:comprador:open", root, compradorInit)





addEvent("victor:comprador:assinar", true)
addEventHandler("victor:comprador:assinar", root, function()
    moneyLocal = getPlayerMoney()
    moneyRetirar = tonumber(valor) 
    if moneyLocal < moneyRetirar then 
        destroyElement(raizBrowser)
        showCursor(false)
        guiSetInputEnabled(false)
        setTimer(function()
            exports.FogtzInfoV2:showInfobox("Dinheiro insuficiente!", "error")
        end,1000,1)
    elseif moneyRetirar < moneyLocal then 
        destroyElement(raizBrowser)
        showCursor(false)
        guiSetInputEnabled(false)
        moneyDar = tonumber(valor)
        triggerServerEvent("victor:cash:take", root, localPlayer, moneyRetirar, memoriaVendedor, moneyDar, idBancoDb)
        exports.FogtzInfoV2:showInfobox("Trasferência realizada!", "success")
    end
end)



addEvent("victor:comprador:close", true)
addEventHandler("victor:comprador:close", root, function()
    destroyElement(raizBrowser)
    showCursor(false)
    guiSetInputEnabled(false)
end)

