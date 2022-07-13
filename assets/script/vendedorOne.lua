info = {}
diretorio = "http://mta/174_Concessionaria/assets/html/vendedor/index.html"


addEvent("victor:vendedor:open", true)
addEventHandler("victor:vendedor:open", root, function(id_tabela_banco, conta_vendedor, nome_veiculo)
    info = {["IdDB"]=id_tabela_banco, ["Dono"]=conta_vendedor, ["Veiculo"]=nome_veiculo, ["Vendedor"]=localPlayer,}
    largura, altura = guiGetScreenSize()
    browserRaiz = guiCreateBrowser(0,0, largura, altura, true, true, false)
    browser = guiGetBrowser(browserRaiz)
    addEventHandler("onClientBrowserCreated", browserRaiz, function()
        loadBrowserURL(browser, diretorio)
        guiSetInputEnabled (true)
    end)
    addEventHandler("onClientBrowserDocumentReady", root, function(url)
        if url == diretorio then 
            executeBrowserJavascript(browser, "document.querySelector('#vehicle-name').innerHTML = '"..nome_veiculo.."'")
        end
    end)
end)





addEvent("victor:vendedor:fechar", true)
addEventHandler("victor:vendedor:fechar", root, function()
    destroyElement (browserRaiz)
    showCursor (false)
    guiSetInputEnabled (false)
    setTimer(function()
        removeEventHandler("victor:vendedor:fechar", root, function() end)
    end,1000,1)
end)


addEvent("victor:vendedor:confirmpanel", true)
addEventHandler("victor:vendedor:confirmpanel", root, function(idcomprador, value)
    executeBrowserJavascript(browser, "document.querySelector('.container').style.display = 'none'")
    guiSetInputEnabled (false)
    showCursor (false)
    input = {["Valor"]=value,}
    local x, y, z = getElementPosition(localPlayer)
    triggerServerEvent("victor:transferencia:check", root, idcomprador, x,y,z, localPlayer)
    addEvent("victor:vendedor:icognita", true)
    addEventHandler("victor:vendedor:icognita", root, function(autorizado, accountcomprador, datacomprador)
        if autorizado == "distance" then 
            exports.FogtzInfoV2:showInfobox("O Cidadão não está próximo a você!", "error")
            removeEventHandler("victor:vendedor:confirmpanel", root, function() end)
        elseif autorizado == true then 
            local conta_comprador = accountcomprador
            if info["Dono"] == conta_comprador then 
                exports.FogtzInfoV2:showInfobox("Você não pode enviar veiculo a sí mesmo.", "error")
                return false
            end
            triggerServerEvent("victor:transferencia:senderscreen",getResourceRootElement(getThisResource()), datacomprador, info["Veiculo"],input["Valor"], info["Dono"], info["Vendedor"], info["IdDB"], accountcomprador)
            -- datacomprador, info["Veiculo"],input["Valor"], info["Dono"], info["Vendedor"]
        elseif autorizado == false then  
            exports.FogtzInfoV2:showInfobox("Cidadão inexistente, refaça a operação!", "error")
            removeEventHandler("victor:vendedor:confirmpanel", root, function() end)
        end
    end)
end)

addEvent("victor:infobox", true)
addEventHandler("victor:infobox", root, function(type, message)
    if type == "error" then
        exports.FogtzInfoV2:showInfobox(message,"error")
    elseif type == "success" then 
        exports.FogtzInfoV2:showInfobox(message,"success")
    end
end)
