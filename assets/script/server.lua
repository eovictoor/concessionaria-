--[[
 ________  ________  ________  ___    ___ ________  ___  ________  ___  ___  _________        ________      ___    ___     
|\   ____\|\   __  \|\   __  \|\  \  /  /|\   __  \|\  \|\   ____\|\  \|\  \|\___   ___\     |\   __  \    |\  \  /  /|    
\ \  \___|\ \  \|\  \ \  \|\  \ \  \/  / | \  \|\  \ \  \ \  \___|\ \  \\\  \|___ \  \_|     \ \  \|\ /_   \ \  \/  / /    
 \ \  \    \ \  \\\  \ \   ____\ \    / / \ \   _  _\ \  \ \  \  __\ \   __  \   \ \  \       \ \   __  \   \ \    / /     
  \ \  \____\ \  \\\  \ \  \___|\/  /  /   \ \  \\  \\ \  \ \  \|\  \ \  \ \  \   \ \  \       \ \  \|\  \   \/  /  /      
   \ \_______\ \_______\ \__\ __/  / /      \ \__\\ _\\ \__\ \_______\ \__\ \__\   \ \__\       \ \_______\__/  / /        
    \|_______|\|_______|\|__||\___/ /        \|__|\|__|\|__|\|_______|\|__|\|__|    \|__|        \|_______|\___/ /         
                             \|___|/                                                                      \|___|/                                                                                                    
 _____ ______   ___  ________  _________  ___  ________          ________  _________  ________  ________  _______          
|\   _ \  _   \|\  \|\   ____\|\___   ___\\  \|\   ____\        |\   ____\|\___   ___\\   __  \|\   __  \|\  ___ \         
\ \  \\\__\ \  \ \  \ \  \___|\|___ \  \_\ \  \ \  \___|        \ \  \___|\|___ \  \_\ \  \|\  \ \  \|\  \ \   __/|        
 \ \  \\|__| \  \ \  \ \_____  \   \ \  \ \ \  \ \  \            \ \_____  \   \ \  \ \ \  \\\  \ \   _  _\ \  \_|/__      
  \ \  \    \ \  \ \  \|____|\  \   \ \  \ \ \  \ \  \____        \|____|\  \   \ \  \ \ \  \\\  \ \  \\  \\ \  \_|\ \     
   \ \__\    \ \__\ \__\____\_\  \   \ \__\ \ \__\ \_______\        ____\_\  \   \ \__\ \ \_______\ \__\\ _\\ \_______\    
    \|__|     \|__|\|__|\_________\   \|__|  \|__|\|_______|       |\_________\   \|__|  \|_______|\|__|\|__|\|_______|    
]]

------------/CONFIG SQLITE\------------
addEventHandler ("onResourceStart", resourceRoot,
function ()
    db = dbConnect ("sqlite", "assets/database/veiculos.db")
    dbExec (db, "CREATE TABLE IF NOT EXISTS Veiculos (Conta, ID, Nome, Modelo, Estado, Cor, Tunagem, Seguro, IPVA, Placa, Valor, Vida, Gasolina)")
    if db then
        for i, v in ipairs (getElementsByType ("player")) do
            bindKey (v, config.botoes.trancardes, "down", onPlayerLockVehicle)
        end
        local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Estado = ?", "Spawnado"), -1)
        if #result ~= 0 then
            dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Estado = ?", "Guardado", "Spawnado")
        end
        outputDebugString ("dbConnect[Concessionaria] : Success.", 4, 0, 255, 0)
    else
        outputDebugString ("dbConnect[Concessionaria] : Fail.", 4, 255, 0, 0)
    end
end)
------------/CONFIG SQLITE\------------
function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if not acc or isGuestAccount(acc) then
        return false
    end
    return getAccountPlayer(acc)
end
------------/CONFIG UTIL\------------
local concessionaria = { }
local garagem = { }
local desmanche = { }
local detran = { }
local apreensao = { }

local vehicle = { }

local timer_desmanche = { }

local blip_loc = { }
local tempo_loc = { }

local timer_doc = { }

local teclas = {"a", "b", "c", "d", "e", "f", "g", "h", "i" , "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

function message (player, message, type)
    triggerClientEvent(player, config.gerais.infobox, player, message, type)
end

function createEventHandler (event, ...)
    addEvent (event, true)
    addEventHandler (event, ...)
end

function NovoID ()
    local result = dbPoll (dbQuery (db, "SELECT ID FROM Veiculos ORDER BY ID ASC"), -1)
    newID = false
    for i, v in ipairs (result) do
        if v["ID"] ~= i then
            newID = i
            break
        end
    end
    if newID then
        return newID
    else
        return #result + 1
    end
end

function generatePlate (len)
    if type(len) == "number" and len >= 1 then
        String = ""
        n = 0 
        while true do
            n = n + 1
            local random = math.random(1, #teclas)
            if #String == 4 then
                String = String.."-"
            end
            String = String..""..string.upper(teclas[random])..""
            if n == len then
                break
            end
        end
    end
    return String
end

function getFreePlate ()
    Placa = false
    local veiculos = dbPoll(dbQuery(db, "SELECT * FROM Veiculos"), -1)
    while true do
        local plate = generatePlate (7)
        local result = dbPoll(dbQuery(db, "SELECT * FROM Veiculos WHERE Placa = ?", plate), -1)
        if #result == 0 then
            Placa = plate
            break
        end
    end
    return Placa
end

function getPlayerACLGroup (player)
    for i, v in ipairs (config.gerais.acls) do
        if aclGetGroup (v) then
            local accName = getAccountName (getPlayerAccount (player))
            if isObjectInACLGroup ("user." ..accName, aclGetGroup (v)) then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end

function getPlayerFromID (id)
    p = false
    for i, v in ipairs (getElementsByType ("player")) do
        if getElementData (v, config.gerais.elementid) == id then
            p = v
            break
        end
    end
    return p
end

function getAllPlayerVehicles (player)
    local accName = getAccountName (getPlayerAccount (player))
    local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ?", accName), -1) -- dbPoll aceita resposta
    return #result
end

function getNearestVehicle(player, distance)
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	return nearestVeh
end

function convertNumber ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end
------------/CONFIG UTIL\------------

------------/CONFIG CONCESSIONARIAS\------------
for i = 1, #config.concessionarias do
    concessionaria[i] = createMarker (config.concessionarias[i].x, config.concessionarias[i].y, config.concessionarias[i].z - 1, "cylinder", 1.2, config.concessionarias[i].cor[1], config.concessionarias[i].cor[2], config.concessionarias[i].cor[3], config.concessionarias[i].cor[4])
    createBlipAttachedTo (concessionaria[i], config.concessionarias[i].blip)
    addEventHandler ("onMarkerHit", concessionaria[i], function (element)
        if getElementType (element) == "player" then
            if isGuestAccount (getPlayerAccount (element)) then return end
            if not isPedInVehicle (element) then
                triggerClientEvent (element, "MST.onPlayerCheckVehicles", element, {config.concessionarias[i].x, config.concessionarias[i].y, config.concessionarias[i].z})
            end
        end
    end)
end
------------/CONFIG CONCESSIONARIAS\------------

------------/CONFIG GARAGENS\------------
for i = 1, #config.garagens do
    garagem[i] = createMarker (config.garagens[i].x, config.garagens[i].y, config.garagens[i].z - 1, "cylinder", 1.2, config.garagens[i].cor[1], config.garagens[i].cor[2], config.garagens[i].cor[3], config.garagens[i].cor[4])
    createBlipAttachedTo (garagem[i], config.garagens[i].blip)
    addEventHandler ("onMarkerHit", garagem[i], function (element)
        if getElementType (element) == "player" then
            if isGuestAccount (getPlayerAccount (element)) then return end
            if not isPedInVehicle (element) then
                local accName = getAccountName (getPlayerAccount (element))
                local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ?", accName), -1)
                triggerClientEvent (element, "MST.onPlayerCheckGarage", element, result, {config.garagens[i].spawn})
            end
        end
    end)
end
------------/CONFIG GARAGENS\------------

------------/CONFIG DESMANCHES\------------
for i = 1, #config.desmanches do    
    desmanche[i] = createMarker (config.desmanches[i].x, config.desmanches[i].y, config.desmanches[i].z - 1, "cylinder", 2.0, config.desmanches[i].cor[1], config.desmanches[i].cor[2], config.desmanches[i].cor[3], config.desmanches[i].cor[4])
    createBlipAttachedTo (desmanche[i], config.desmanches[i].blip)
    setElementData (desmanche[i], "MST.onZoneDesmanche", true)
    function onPlayerDesmancheVehicle (player)
        local veh = getPedOccupiedVehicle (player)
        if not isElementWithinMarker (player, desmanche[i]) then return end
        if not getElementData (desmanche[i], "MST.onZonaOccupied") then
            if not timer_desmanche[player] then
                if veh then
                    local data = getElementData (veh, "MST.onVehicleID")
                    if data then
                        local value = getElementData (veh, "MST.onVehicleData")
                        if value then
                            local accName = getAccountName (getPlayerAccount (player))
                            if accName ~= value[1].Conta then
                                local valor = value[1].Valor * config.valores.desmanchar / 100
                                setElementData (desmanche[i], "MST.onZonaOccupied", true)
                                setElementFrozen (veh, true)
                                message (player, "Você está desmanchando o Veículo "..value[1].Nome..", aguarde "..config.tempos.desmanchar.." segundo(s).", "info")
                                unbindKey (player, config.botoes.desmanchar, "down", onPlayerDesmancheVehicle)
                                timer_desmanche[player] = setTimer (function ()
                                    setElementData (desmanche[i], "MST.onZonaOccupied", false)
                                    if value[1].Seguro == "Sim" then
                                        dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Roubado", value[1].Conta, value[1].ID)
                                    else
                                        dbExec (db, "DELETE FROM Veiculos WHERE Conta = ? AND ID = ?", value[1].Conta, value[1].ID)
                                    end
                                    if blip_loc[veh] then
                                        destroyElement (blip_loc[veh])
                                        blip_loc[veh] = nil
                                        tempo_loc[veh] = nil
                                    end
                                    destroyElement (veh)
                                    message (player, "Você desmanchou o Veículo "..value[1].Nome.." e recebeu R$"..convertNumber(valor)..",00.", "success")
                                    givePlayerMoney (player, valor)
                                    timer_desmanche[player] = nil
                                end, config.tempos.desmanchar * 1000, 1)
                            else
                                message (player, "Você não pode desmanchar o seu próprio veículo.", "error")
                            end
                        end
                    else
                        setElementData (desmanche[i], "MST.onZonaOccupied", true)
                        setElementFrozen (veh, true)
                        message (player, "Você está desmanchando um veículo Desconhecido, aguarde "..config.tempos.desmanchar.." segundo(s).", "info")
                        unbindKey (player, config.botoes.desmanchar, "down", onPlayerDesmancheVehicle)
                        timer_desmanche[player] = setTimer (function ()
                            setElementData (desmanche[i], "MST.onZonaOccupied", false)
                            destroyElement (veh)
                            message (player, "Você desmanchou o veículo Desconhecido e recebeu R$"..convertNumber(config.valores.valorD)..",00.", "success")
                            givePlayerMoney (player, config.valores.valorD)
                            timer_desmanche[player] = nil
                        end, config.tempos.desmanchar * 1000, 1)
                    end
                else
                    message (player, "Você não está em um Veículo para poder desmanchar.", "error")
                end
            else
                message (player, "Você já está Desmanchando um Veículo, aguarde.", "error")
            end
        else
            message (player, "Essa zona já está ocupada.", "error")
        end
    end
    addEventHandler ("onMarkerHit", desmanche[i], function (element)
        if getElementType (element) == "player" then
            if isGuestAccount (getPlayerAccount (element)) then return end
            if isPedInVehicle (element) then
                local accName = getAccountName (getPlayerAccount (element))
                if aclGetGroup (config.desmanches[i].Acl) then
                    if isObjectInACLGroup ("user." ..accName, aclGetGroup (config.desmanches[i].Acl)) then
                        message (element, "Pressione [ "..string.upper(config.botoes.desmanchar).." ] para desmanchar esse Veículo.", "info")
                        bindKey (element, config.botoes.desmanchar, "down", onPlayerDesmancheVehicle)
                    else
                        message (element, "Você não tem permissão para desmanchar Veículos.", "error")
                        unbindKey (element, config.botoes.desmanchar, "down", onPlayerDesmancheVehicle)
                    end
                else
                    outputDebugString ("Crie a ACL "..config.desmanches[i].Acl.." no seu Painel P.", 4, 255, 0, 0)
                    message (element, "Ocorreu um erro ao executar o desmanche.", "error")
                end
            end
        end
    end)
    addEventHandler ("onMarkerLeave", desmanche[i], function (element)
        if getElementType (element) == "player" then
            unbindKey (element, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
        end
    end)
    addEventHandler ("onPlayerQuit", getRootElement(), function ()
        local veh = getPedOccupiedVehicle (source)
        if getElementData (desmanche[i], "MST.onZonaOccupied") and timer_desmanche[source] then
            if veh then
                local data = getElementData (veh, "MST.onVehicleData")
                if data then
                    dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Guardado", data[1].Conta, data[1].ID)
                end
                destroyElement (veh)
            end
            setElementData (desmanche[i], "MST.onZonaOccupied", false)
            timer_desmanche[source] = nil
        end
    end)
end
------------/CONFIG DESMANCHES\------------
local function sendVenda(element)
    triggerClientEvent(element, "MST.onVictorVenda", element)
end
addCommandHandler("vender", sendVenda)
------------/CONFIG DETRANS\------------
for i = 1, #config.detrans do
    detran[i] = createMarker (config.detrans[i].x, config.detrans[i].y, config.detrans[i].z - 1, "cylinder", 1.2, config.detrans[i].cor[1], config.detrans[i].cor[2], config.detrans[i].cor[3], config.detrans[i].cor[4])
    createBlipAttachedTo (desmanche[i], config.detrans[i].blip)
    addEventHandler ("onMarkerHit", detran[i], function (element)
        if getElementType (element) == "player" then
            if isGuestAccount (getPlayerAccount (element)) then return end
            if not isPedInVehicle (element) then
                local accName = getAccountName (getPlayerAccount (element))
                local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ?", accName), -1)
                triggerClientEvent (element, "MST.onPlayerCheckDetran", element, result)
            end
        end
    end)
end
------------/CONFIG DETRANS\------------

------------/CONFIG APREENSAO\------------
for i = 1, #config.apreensoes do
    apreensao[i] = createMarker (config.apreensoes[i].x, config.apreensoes[i].y, config.apreensoes[i].z -1, "cylinder", 2.0, config.apreensoes[i].cor[1], config.apreensoes[i].cor[2], config.apreensoes[i].cor[3], config.apreensoes[i].cor[4])
    createBlipAttachedTo (apreensao[i], config.apreensoes[i].blip)
    setElementData (apreensao[i], "MST.onZoneApreensao", true)
    function onPlayerApreenderVehicle (player)
        local veh = getPedOccupiedVehicle (player)
        local accName = getAccountName (getPlayerAccount (player))
        if isElementWithinMarker (player, apreensao[i]) then
            if veh then
                local data = getElementData (veh, "MST.onVehicleID")
                if data then
                    local value = getElementData (veh, "MST.onVehicleData")
                    if value then
                        if accName ~= value[1].Conta then
                            local valor = value[1].Valor * config.valores.apreender / 100
                            if blip_loc[veh] then
                                destroyElement (blip_loc[veh])
                                blip_loc[veh] = nil
                                tempo_loc[veh] = nil
                            end
                            if isElement (veh) then
                                destroyElement (veh)
                            end
                            dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Apreendido", value[1].Conta, data or value[1].ID)
                            message (player, "Você apreendeu o veículo "..value[1].Nome..".", "success")
                            givePlayerMoney (player, valor)
                            unbindKey (player, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
                        else
                            message (player, "Você não pode apreender o seu próprio veículo.", "error")
                            unbindKey (player, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
                        end
                    else
                        message (player, "Ocorreu um erro ao Desmanchar esse veículo.", "error")
                        unbindKey (player, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
                    end
                else
                    message (player, "Esse veículo não pode ser apreendido.", "error")
                    unbindKey (player, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
                end
            else
                message (player, "Você não está em um Veículo para poder apreender.", "error")
            end
        end
    end
    addEventHandler ("onMarkerHit", apreensao[i], function (element)
        if getElementType (element) == "player" then
            if isGuestAccount (getPlayerAccount (element)) then return end
            if isPedInVehicle (element) then
                local accName = getAccountName (getPlayerAccount (element))
                if aclGetGroup (config.apreensoes[i].Acl) then
                    if isObjectInACLGroup ("user." ..accName, aclGetGroup (config.apreensoes[i].Acl)) then
                        message (element, "Pressione [ "..string.upper(config.botoes.apreender).." ] para apreender esse Veículo.", "info")
                        bindKey (element, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
                    else
                        message (element, "Você não tem permissão para apreender Veículos.", "error")
                        unbindKey (element, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
                    end
                else
                    outputDebugString ("Crie a ACL "..config.apreensoes[i].Acl.." no seu Painel P.", 4, 255, 0, 0)
                    message (element, "Ocorreu um erro ao executar a apreensão.", "error")
                end
            end
        end
    end)
    addEventHandler ("onMarkerLeave", desmanche[i], function (element)
        if getElementType (element) == "player" then
            unbindKey (element, config.botoes.desmanchar, "down", onPlayerApreenderVehicle)
        end
    end)
end
------------/CONFIG APREENSAO\------------
estoqueConfere = nil
------------/CONFIG BUY VEHICLE\------------
addEvent("victor:estoque", true)
addEventHandler("victor:estoque", root, function(idModel)
    local confEstoque = dbPoll (dbQuery (db, "SELECT Estoque FROM Estoque WHERE idVeiculo = ?", idModel), -1)
    triggerClientEvent(source, "victor:receivEstoque", source, confEstoque[1]["Estoque"])
    removeEventHandler("victor:estoque", root, function(idModel) end)
end)






createEventHandler ("MST.onPlayerBuyVehicle", getRootElement (),
function (player, selecionado, cor_1, cor_2, cor_3, cor_4)
    if selecionado then
        local accName = getAccountName (getPlayerAccount (player))
        local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ? AND Modelo = ?", accName, selecionado.model), -1)
        if #result == 0 then
            message(player, "Verificando se há estoque disponivel...", "warning")
            local confEstoque = dbPoll (dbQuery (db, "SELECT Estoque FROM Estoque WHERE idVeiculo = ?", selecionado.model), -1)
            estoqueConfere = confEstoque[1]["Estoque"]
            if estoqueConfere >= 1 then 
                setTimer(function()
                    local conta = tonumber(estoqueConfere) - 1
                    if conta == nil then conta = 0 end
                    dbExec(db, "UPDATE Estoque SET Estoque = ? WHERE idVeiculo = ?", conta, selecionado.model)
                    if getAllPlayerVehicles (player) >= config.gerais.veiculosmax then
                        message (player, "Você já possui veículos máximos em sua Garagem.", "error")
                        return
                    end
                    local money = getPlayerMoney (player)
                    if money >= selecionado.price then
                        message (player, "Parabéns, logo logo seu veiculo será entregue em sua garagem!", "success")
                        local id = NovoID ()
                        local cor = cor_1..", "..cor_2..", "..cor_3..", "..cor_4
                        local t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                        local tunning = t_1..", "..t_2..", "..t_3..", "..t_4..", "..t_5..", "..t_6..", "..t_7..", "..t_8..", "..t_9..", "..t_10..", "..t_11..", "..t_12..", "..t_13..", "..t_14..", "..t_15
                        dbExec (db, "INSERT INTO Veiculos VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", accName, id, selecionado.name, selecionado.model, "Guardado", cor, tunning, "Não", 0, "SemPlaca", selecionado.price, 1000, 100)
                        takePlayerMoney (player, selecionado.price)
                        triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                        setTimer(function()
                            message (player, "Seu veiculo "..selecionado.name.." foi entregue!", "success")
                        end, 10*1000, 1)
                    else
                        message (player, "Você não possui dinheiro suficiente.", "error")
                        cancelEvent()
                    end
                end,3000,1)
            elseif tonumber(estoqueConfere) == 0 then 
                setTimer(function()
                    message (player, "O veiculo está esgotado!", "error")
                end, 3000, 1)
            end
        else
            message (player, "Você já possui esse veículo.", "error")
        end
    else
        message (player, "Selecione algum veículo da lista.", "error")
    end
end)
------------/CONFIG BUY VEHICLE\------------




------------/CONFIG GARAGE FUNCTIONS\------------
createEventHandler ("MST.onPlayerExecuteGarageFuncs", getRootElement(),
function (player, type, selecionado, x, y, z, rx, ry, rz)
    local accName, acc = getAccountName (getPlayerAccount (player)), getPlayerAccount (player)
    if type == "Retirar" then
        local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ? AND Modelo = ?", accName, selecionado.Modelo), -1)
        if #result ~= 0 then
            local state = selecionado.Estado
            if state == "Roubado" then
                message (player, "O seu Veículo foi roubado, vá até o Detran para recupera-lo.", "info")
                triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
            elseif state == "Apreendido" then
                message (player, "O seu Veículo foi apreendido, vá até o Detran para retira-lo.", "info")
                triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
            elseif state == "Guardado" then
                local ipva = selecionado.IPVA
                if tonumber(ipva) > 0 then
                    message (player, "Você está com o IPVA atrasado, vá até o Detran para paga-lo.", "info")
                end
                local vida = selecionado.Vida
                local placa = selecionado.Placa
                local gasolina = selecionado.Gasolina
                local cor = split(selecionado.Cor, ", ")
                local tunning = split (selecionado.Tunagem, ", ")
                local id = selecionado.ID
                if not vehicle[acc] then
                    vehicle[acc] = { }
                end
                if not vehicle[acc][selecionado.ID] then
                    vehicle[acc][selecionado.ID] = { }
                end
                dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND Modelo = ?", "Spawnado", accName, selecionado.Modelo)
                vehicle[acc][selecionado.ID] = createVehicle (selecionado.Modelo, x, y, z)
                setElementRotation (vehicle[acc][selecionado.ID], rx, ry, rz)
                setVehicleLocked (vehicle[acc][selecionado.ID], true)
                setElementData (vehicle[acc][selecionado.ID], "MST.onVehicleID", id)
                setElementData (vehicle[acc][selecionado.ID], "MST.onVehicleOwner", getElementData (player, config.gerais.elementid))
                setElementData (vehicle[acc][selecionado.ID], "MST.onVehicleData", result)
                for i, v in ipairs(tunning) do
                    addVehicleUpgrade(vehicle[acc][selecionado.ID], v)
                end
                setVehicleColor (vehicle[acc][selecionado.ID], unpack(cor))
                setElementHealth (vehicle[acc][selecionado.ID], vida)
                setElementData (vehicle[acc][selecionado.ID], config.gerais.elementfuel, gasolina)
                setVehiclePlateText (vehicle[acc][selecionado.ID], placa)
                message (player, "Você spawnou o seu Veículo "..selecionado.Nome..".", "success")
                triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                addEventHandler ("onVehicleExplode", vehicle[acc][selecionado.ID], function ()
                    dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Apreendido", selecionado.Conta, selecionado.ID)
                    destroyElement (source)
                end)
                triggerEvent ("MST.onScriptInsertKilo", player, vehicle[acc][selecionado.ID])
            else
                message (player, "Esse veículo já está Spawnado.", "error")
            end
        else
            message (player, "Ocorreu um erro ao Retirar o seu Veículo da Garagem.", "warning")
        end
    elseif type == "Guardar" then
        if vehicle[acc] then 
            if isElement (vehicle[acc][selecionado.ID]) then
                local x, y, z = getElementPosition (player)
                local vx, vy, vz = getElementPosition (vehicle[acc][selecionado.ID])
                if getDistanceBetweenPoints3D (x, y, z, vx, vy, vz) <= config.gerais.distancia then
                    local cor_vehicle = {getVehicleColor(vehicle[acc][selecionado.ID], true)}
                    local cor = table.concat (cor_vehicle, ", ")
                    local t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15, t_16 = getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 0), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 1), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 2), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 3), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 4), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 5), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 6), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 7), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 8), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 9), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 10), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 11), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 12), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 13), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 14), getVehicleUpgradeOnSlot (vehicle[acc][selecionado.ID], 15)
                    local tunning = t_1..", "..t_2..", "..t_3..", "..t_4..", "..t_5..", "..t_6..", "..t_7..", "..t_8..", "..t_9..", "..t_10..", "..t_11..", "..t_12..", "..t_13..", "..t_14..", "..t_15..", "..t_16
                    local vida = getElementHealth (vehicle[acc][selecionado.ID])
                    local fuel = getElementData (vehicle[acc][selecionado.ID], config.gerais.elementfuel) or 0
                    local placa = getVehiclePlateText (vehicle[acc][selecionado.ID])
                    dbExec (db, "UPDATE Veiculos SET Cor = ?, Tunagem = ?, Vida = ?, Placa = ?, Estado = ?, Gasolina = ? WHERE Conta = ? AND ID = ?", cor, tunning, vida, placa, "Guardado", fuel, accName, getElementData(vehicle[acc][selecionado.ID], "MST.onVehicleID"))
                    message (player, "Você guardou o seu Veículo "..selecionado.Nome..".", "success")
                    triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                    if blip_loc[vehicle[acc][selecionado.ID]] then
                        destroyElement (blip_loc[vehicle[acc][selecionado.ID]])
                        blip_loc[vehicle[acc][selecionado.ID]] = nil
                        tempo_loc[vehicle[acc][selecionado.ID]] = nil
                    end
                    destroyElement (vehicle[acc][selecionado.ID])
                    vehicle[acc][selecionado.ID] = nil
                else
                    message (player, "Você tem que estar mais perto do veículo.", "error")
                end 
            end
        else
            message (player, "Ocorreu um erro ao Guardar o seu Veículo na Garagem.", "warning")
        end
    end
end)
------------/CONFIG GARAGE FUNCTIONS\------------

------------/CONFIG DETRAN FUNCTIONS\------------

createEventHandler ("MST.onPlayerExecuteDetranFuns", getRootElement(), function (player, type, selected)
    if selected then
        local accName, acc = getAccountName (getPlayerAccount (player)), getPlayerAccount (player)
        local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ?", accName), -1)
        if #result ~= 0 then
            if type == "Localizar" then
                if vehicle[acc] then
                    if isElement (vehicle[acc][selected.ID]) then
                        local seguro = selected.Seguro
                        if seguro == "Sim" then
                            local money = getPlayerMoney (player)
                            if money >= config.valores.localizar then
                                if not blip_loc[vehicle[acc][selected.ID]] then
                                    blip_loc[vehicle[acc][selected.ID]] = createBlipAttachedTo (vehicle[acc][selected.ID], 41)
                                    setElementVisibleTo (blip_loc[vehicle[acc][selected.ID]], root, false)
                                    setElementVisibleTo (blip_loc[vehicle[acc][selected.ID]], player, true)
                                    message (player, "O seu veículo "..selected.Nome.." está sendo Localizado.", "success")
                                    takePlayerMoney (player, config.valores.localizar)
                                    triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                                    tempo_loc[vehicle[acc][selected.ID]] = setTimer (function ()
                                        if blip_loc[vehicle[acc][selected.ID]] then
                                            destroyElement (blip_loc[vehicle[acc][selected.ID]])
                                            blip_loc[vehicle[acc][selected.ID]] = nil
                                            tempo_loc[vehicle[acc][selected.ID]] = nil
                                            message (player, "O seu veículo "..selected.Nome.." deixou de ser Localizado.", "info")
                                        end
                                    end, config.tempos.localizar * 1000, 1)
                                else
                                    message (player, "O seu veículo já está sendo localizado.", "error")
                                end
                            else
                                message (player, "Você não possui dinheiro suficiente.", "error")
                            end
                        else
                            message (player, "Você não possui seguro neste Veículo.", "error")
                        end
                    else
                        message (player, "Esse veículo não está na cidade.", "error")
                    end
                else
                    message (player, "Esse veículo não está na cidade.", "error")
                end
            elseif type == "Transferir" then 
                a = {a = 1}
                local result = dbPoll(dbQuery (db, "SELECT IPVA, Nome, Modelo, Conta, ID FROM Veiculos WHERE ID = ?", selected.ID), -1)
                if result then 
                    local ipva = result[1]["IPVA"]
                    local idModel = result[1]["Modelo"]
                    contaVendedor = result[1]["Conta"]
                    local idBancoDeDados = result[1]["ID"]
                    local nomeVeiculo = result[1]["Nome"]
                    if tonumber(ipva) == 0 then 
                        triggerClientEvent(player,"victor:vendedor:open",player, idBancoDeDados, contaVendedor, nomeVeiculo)
                    else 
                        message (player, "Coloque seu documento em dia!", "error")
                        showCursor(player, false)
                    end
                end
                        

                -- triggerClientEvent(player,"openPanelGuiTransferVehicle",player, selected.ID)

            elseif type == "Retirar" then
                local seguro = selected.Seguro
                if selected.Estado == "Apreendido" then
                    if seguro == "Sim" then
                        local money = getPlayerMoney (player)
                        if money >= selected.Valor * config.detran.valor_apreender_s / 100 then
                            dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Guardado", accName, selected.ID)
                            message (player, "Você retirou o seu veículo "..selected.Nome.." do Detran.", "success")
                            takePlayerMoney (player, selected.Valor * config.detran.valor_apreender_s / 100)
                            triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                        else
                            message (player, "Você não possui dinheiro suficiente.", "error")
                        end
                    else
                        local money = getPlayerMoney (player)
                        if money >= selected.Valor * config.detran.valor_apreender / 100 then
                            dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Guardado", accName, selected.ID)
                            message (player, "Você retirou o seu veículo "..selected.Nome.." do Detran.", "success")
                            takePlayerMoney (player, selected.Valor * config.detran.valor_apreender / 100)
                            triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                        else
                            message (player, "Você não possui dinheiro suficiente.", "error")
                        end
                    end
                elseif selected.Estado == "Roubado" then
                    local money = getPlayerMoney (player)
                    if money >= selected.Valor * config.detran.valor_desmanche / 100 then
                        dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Guardado", accName, selected.ID)
                        message (player, "Você recuperou o seu veículo "..selected.Nome.." do Desmanche.", "success")
                        takePlayerMoney (player, selected.Valor * config.detran.valor_desmanche / 100)
                        triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                    else
                        message (player, "Você não possui dinheiro suficiente.", "error")
                    end
                end
            elseif type == "Emplacar" then
                if selected.Estado == "Guardado" then
                    local money = getPlayerMoney (player)
                    if money >= config.detran.valor_emplacar then
                        if selected.Placa == "SemPlaca" then
                            message (player, "Você emplacou o seu Veículo "..selected.Nome..".", "success")
                            dbExec (db, "UPDATE Veiculos SET Placa = ? WHERE Conta = ? AND ID = ?", getFreePlate(), accName, selected.ID)
                            takePlayerMoney (player, config.detran.valor_emplacar)
                            triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                        else
                            message (player, "Esse veículo já está emplacado.", "error")
                        end
                    else
                        message (player, "Você não possui dinheiro suficiente.", "error")
                    end
                else
                    message (player, "O Veículo precisa estar dentro da Garagem.", "error")
                end
            elseif type == "Pagar" then
                local money = getPlayerMoney (player)
                if selected.Estado == "Guardado" then
                    if tonumber(selected.IPVA) > 0 then
                        if money >= tonumber(selected.IPVA) then
                            dbExec (db, "UPDATE Veiculos SET IPVA = ? WHERE Conta = ? AND ID = ?", 0, accName, selected.ID)
                            message (player, "Você pagou o IPVA do seu Veículo "..selected.Nome..".", "success")
                            takePlayerMoney (player, tonumber(selected.IPVA))
                            triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                        else
                            message (player, "Você não possui dinheiro suficiente.", "error")
                        end
                    else
                        message (player, "O Veículo não está com IPVA atrasado.", "error")
                    end
                else
                    message (player, "O Veículo precisa estar dentro da Garagem.", "error")
                end
            elseif type == "Seguro" then
                local money = getPlayerMoney (player)
                if selected.Estado == "Guardado" then
                    if money >= selected.Valor * config.detran.valor_seguro / 100 then
                        if selected.Seguro == "Sim" then message (player, "Você já possui seguro neste veículo.", "error") return end
                        dbExec (db, "UPDATE Veiculos SET Seguro = ? WHERE Conta = ? AND ID = ?", "Sim", accName, selected.ID)
                        message (player, "Você contratou o Seguro do seu Veículo "..selected.Nome..".", "success")
                        takePlayerMoney (player, selected.Valor * config.detran.valor_seguro / 100)
                        triggerClientEvent (player, "MST.onPlayerCloseEvents", player)
                    else
                        message (player, "Você não possui dinheiro suficiente.", "error")
                    end
                else
                    message (player, "O Veículo precisa estar dentro da Garagem.", "error")
                end
            end
        else
            message (player, "Ocorreu um erro ao executar as funções do Detran.", "error")
        end
    else
        message (player, "Selecione algum de seus Veículo.", "error")
    end
end)
------------/CONFIG DETRAN FUNCTIONS\------------

veiculoLista = {[471]="Honda Sportrax",[521]="Skull Road",[565]="Brasilia",[541]="BMW M3",[562]="Truffade Nero",
[517]="Chevette 76",[462]="Ford Taurus",[579]="Cadilac",[554]="Mustang",[415]="McLaren MP4",[603]="Golf MK6",
[602]="Golf GTI 2017",[580]="Cruze",[401]="Volks Scirocco",[470]="Jeep Grand",[426]="Santana",[436]="Zentorno",
[542]="Opala 1979",[507]="Accord"}
addEvent("givePropostaVendaVeiculo", true )
addEventHandler("givePropostaVendaVeiculo", getRootElement(), function(de,para,carro,valor, contaVendedor, idTabelaBanco )
    setTimer(function()
        idBancoTabela = idTabelaBanco
        alvo = getPlayerFromID(para)
        vendedorAccount = contaVendedor
        contaComprador = getAccountName(getAccountByID(para))
        if alvo then 
            if contaComprador == contaVendedor then 
                message (de, "Você não pode ofertar para si mesmo!", "error")
            else 
                triggerClientEvent(alvo, "receivPropostaVeiculoVenda", alvo, carro, valor, jogador, idBancoTabela)
            end
            removeEventHandler("givePropostaVendaVeiculo", getRootElement(), function(de,para,carro,valor)end)
        end
    end,1000,1)
end)
addEvent("confirmCompraOrNo", true)
addEventHandler("confirmCompraOrNo", getRootElement(), function(confirma, idTabelaBancoSqlite, valorRetirar, valorAdotar)
    if confirma then
        local malucoVendedor = getPlayerFromAccountName(contaVendedor)
        local malucoComprador = getPlayerFromAccountName (contaComprador)
        local filtroDb = idTabelaBancoSqlite
        givePlayerMoney(malucoVendedor, valorAdotar) -- de e o vendedor
        givePlayerMoney(alvo, tonumber(valorRetirar))
        dbExec (db, "UPDATE Veiculos SET Conta = ? WHERE Conta = ? AND ID = ?", contaComprador, vendedorAccount, idBancoTabela)
        message (malucoVendedor, "Venda realizada!", "success")
    elseif confirma == false then 
        message (malucoVendedor, "A sua oferta foi recusada ou o comprador não tem dinheiro suficiente.", "warning")
    end
end)
------------/CONFIG BUTTON FUNCTIONS\------------
function onPlayerLockVehicle (player)
    local veh = getPedOccupiedVehicle (player)
    if veh then
        local data = getElementData (veh, "MST.onVehicleID")
        if data then
            if getElementData (veh, "MST.onVehicleOwner") == getElementData (player, config.gerais.elementid) then
                if isVehicleLocked (veh) then
                    setVehicleLocked (veh, false)
                    message (player, "Você destrancou o seu veículo.", "success")
                else
                    setVehicleLocked (veh, true)
                    message (player, "Você trancou o seu veículo.", "success")
                end
            else
                message (player, "Você só pode trancar/destrancar seus veículos.", "error")
            end
        else
            message (player, "Você não pode trancar/destrancar esse veículo.", "error")
        end
    else
        local vehicle = getNearestVehicle (player, config.gerais.distancia)
        if vehicle then
            local data = getElementData (vehicle, "MST.onVehicleID")
            if data then
                if getElementData (vehicle, "MST.onVehicleOwner") == getElementData (player, config.gerais.elementid) then
                    if isVehicleLocked (vehicle) then
                        setVehicleLocked (vehicle, false)
                        message (player, "Você destrancou o seu veículo.", "success")
                    else
                        setVehicleLocked (vehicle, true)
                        message (player, "Você trancou o seu veículo.", "success")
                    end
                else
                    message (player, "Você só pode trancar/destrancar seus veículos.", "error")
                end
            else
                message (player, "Você não pode trancar/destrancar esse veículo.", "error")
            end
        else
            message (player, "Você não está perto de nenhum veículo.", "error")
        end
    end
end

addEventHandler ("onVehicleStartEnter", getRootElement (), function (player)
    if isVehicleLocked (source) then
        message (player, "Esse veículo está trancado.", "error")
    end
end)

addEventHandler ("onPlayerLogin", getRootElement(),
function ()
    bindKey (source, config.botoes.trancardes, "down", onPlayerLockVehicle)
end)
------------/CONFIG BUTTON FUNCTIONS\------------

------------/CONFIG COMMANDS\------------

addCommandHandler ("vehadm", function (player, cmd, id) -- esquece
    if getPlayerACLGroup (player) then
        if id then
            local id = tonumber (id)
            if id then
                local alvo = getPlayerFromID (id)
                if alvo then
                    local veh = getPedOccupiedVehicle (alvo)
                    if veh then
                        local data = getElementData (veh, "MST.onVehicleID")
                        local alvoAcc = getAccountName (getPlayerAccount (alvo))
                        if data then
                            dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Guardado", alvoAcc, data)
                            message (alvo, "O Administrador "..getPlayerName(player).."#FFFFFF guardou o seu Veículo.", "info")
                            destroyElement (veh)
                        else
                            message (player, "Você destriuiu o veículo do Jogador "..getPlayerName(alvo).."#FFFFFF.", "success")
                            message (alvo, "O Administrador "..getPlayerName(player).."#FFFFFF destriuiu o seu Veículo.", "info")
                            destroyElement (veh)
                        end
                    else
                        message (player, "O Jogador não está em um veículo.", "error")
                    end
                else
                    message (player, "O Jogador não está na cidade.", "error")
                end
            else
                message (player, "Tente o ID somente com Números.", "error")
            end
        else
            message (player, "Tente /"..config.commands.destruirveh.." ID Player.", "error")
        end
    else
        message (player, "Você não tem permissão para utilizar esse comando.", "error")
    end
end)

addCommandHandler (config.commands.giveveh, function (player, cmd, id, veiculo)
    if getPlayerACLGroup (player) then
        if id and veiculo then
            local id = tonumber (id)
            local veiculo = tonumber (veiculo)
            if id and veiculo then
                local alvo = getPlayerFromID (id)
                if alvo then
                    if config.veiculos[veiculo] then
                        local accName = getAccountName (getPlayerAccount (alvo))
                        local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ? AND Modelo = ?", accName, config.veiculos[veiculo].model), -1)
                        if #result == 0 then
                            local vehicle = NovoID ()
                            local cor_1, cor_2, cor_3, cor_4 = math.random (0, 255), math.random (0, 255), math.random (0, 255), math.random (0, 255)
                            local cor = cor_1..", "..cor_2..", "..cor_3..", "..cor_4
                            local t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                            local tunning = t_1..", "..t_2..", "..t_3..", "..t_4..", "..t_5..", "..t_6..", "..t_7..", "..t_8..", "..t_9..", "..t_10..", "..t_11..", "..t_12..", "..t_13..", "..t_14..", "..t_15
                            dbExec (db, "INSERT INTO Veiculos VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", accName, vehicle, config.veiculos[veiculo].name, config.veiculos[veiculo].model, "Guardado", cor, tunning, "Não", 0, "SemPlaca", config.veiculos[veiculo].price, 1000, 100)
                            message (player, "Você givou o veículo "..config.veiculos[veiculo].name.." para o Jogador "..getPlayerName(alvo).."#FFFFFF.", "success")
                            message (alvo, "O Administrador "..getPlayerName(player).."#FFFFFF givou o veículo "..config.veiculos[veiculo].name..".", "info")
                        else
                            message (player, "O Jogador já possui esse veículo na garagem.", "error")
                        end
                    else
                        message (player, "Esse veículo não existe.", "error")
                    end
                else
                    message (player, "O Jogador não está na cidade.", "error")
                end
            else
                message (player, "Tente o ID somente com Números.", "error")
            end
        else
            message (player, "Tente /"..config.commands.giveveh.." ID Player ID do Veículo na Tabela.", "error")
        end
    else
        message (player, "Você não tem permissão para utilizar esse comando.", "error")
    end
end)
addEvent("removerVeiculoJogadorVenda", true)
addEventHandler ("removerVeiculoJogadorVenda", getRootElement(), function (id, veiculo)
    if 1+1 == 2 then
        if id and veiculo then
            local id = tonumber (id)
            local veiculo = tonumber (veiculo)
            if id and veiculo then
                local alvo = getPlayerFromID (id)
                if alvo then
                    local accName = getAccountName (getPlayerAccount (alvo))
                    local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos WHERE Conta = ? AND Modelo = ?", accName, veiculo), -1)
                    if #result ~= 0 then
                        message (player, "Você retirou o veículo "..result[1].Nome.." do Jogador "..getPlayerName(alvo).."#FFFFFF.", "success")
                        message (alvo, "O Administrador "..getPlayerName(player).."#FFFFFF retirou o veículo "..result[1].Nome..".", "info")
                        dbExec (db, "DELETE FROM Veiculos WHERE Conta = ? AND Modelo = ?", accName, veiculo)
                    else
                        message (player, "O Jogador não possui esse veículo na garagem.", "error")
                    end
                else
                    message (player, "O Jogador não está na cidade.", "error")
                end
            else
                message (player, "Tente o ID somente com Números.", "error")
            end
        else
            message (player, "Tente ID Player ID do Veículo.", "error")
        end
    else
        message (player, "Você não tem permissão para utilizar esse comando.", "error")
    end
end)

addCommandHandler (config.commands.docveh, function (player, cmd)
    local accName = getAccountName (getPlayerAccount (player))
    if aclGetGroup (config.doc.acl) then
        if isObjectInACLGroup ("user." ..accName, aclGetGroup (config.doc.acl)) then
            local veh = getPedOccupiedVehicle (player)
            if veh then
                local data = getElementData (veh, "MST.onVehicleData")
                if data then
                    message (player, "Você está consultando o documento do veículo.", "info")
                    timer_doc[player] = setTimer (function (player, data)
                        outputChatBox ("#00FF7FDados do Veículo", player, 255, 255, 255, true)
                        local acc = getAccount (data[1].Conta)
                        if acc then
                            local owner = getAccountPlayer (acc)
                            if owner then
                                outputChatBox ("#00FF7FDono do Veículo #FFFFFF: "..getPlayerName (owner).."#FFFFFF.", player, 255, 255, 255, true)
                            else
                                outputChatBox ("#00FF7FDono do Veículo #FFFFFF: não está na Cidade.", player, 255, 255, 255, true)
                            end
                        else
                            outputChatBox ("#00FF7FDono do Veículo #FFFFFF: não registrado.", player, 255, 255, 255, true)
                        end
                        outputChatBox ("#00FF7FChassi do Veículo #FFFFFF: "..data[1].Modelo..".", player, 255, 255, 255, true)
                        outputChatBox ("#00FF7FNome do Veículo #FFFFFF: "..data[1].Nome..".", player, 255, 255, 255, true)
                        outputChatBox ("#00FF7FEstado do Seguro do Veículo #FFFFFF: "..data[1].Seguro..".", player, 255, 255, 255, true)
                        if tonumber (data[1].IPVA) > 0 then
                            outputChatBox ("#00FF7FIPVA do Veículo #FFFFFF: R$"..convertNumber(data[1].IPVA)..",00.", player, 255, 255, 255, true)
                        else
                            outputChatBox ("#00FF7FIPVA do Veículo #FFFFFF: está em Dia.", player, 255, 255, 255, true)
                        end
                        outputChatBox ("#00FF7FPlaca do Veículo #FFFFFF: "..data[1].Placa..".", player, 255, 255, 255, true)
                        timer_doc[player] = nil
                    end, 1500, 1, player, data)
                else
                    message (player, "O veículo não tem documento.", "error")
                end
            else
                message (player, "Você não está em um veículo.", "error")
            end
        else
            message (player, "Você não tem permissão para utilizar esse comando.", "error")
        end
    else
        outputDebugString ("Crie a ACL "..config.doc.acl.." no seu Painel P.", 4, 255, 0, 0)
        message (player, "Ocorreu um erro no script.", "error")
    end
end)
------------/CONFIG COMMANDS\------------

------------/CONFIG IPVA\------------
setTimer (function ()
    for i, player in ipairs (getElementsByType ("player")) do
        outputChatBox("#FFAE00✘#ffffffINFO#FFAE00✘➺ #ffffffOs impostos de veiculos foram cobrados", player, 255, 0, 0, true)
    end
    local result = dbPoll (dbQuery (db, "SELECT * FROM Veiculos") , -1)
    for i, v in ipairs (result) do
        local IPVA = tonumber(v["IPVA"])
        local taxa_ipva = tonumber (v["Valor"]) * config.ipva.porcentagem / 100
        local valor_total = IPVA + taxa_ipva
        if valor_total >= tonumber (v["Valor"]) then
            dbExec (db, "UPDATE Veiculos SET Estado = ? WHERE Conta = ? AND ID = ?", "Apreendido", v["Conta"], v["ID"])
        else
            dbExec (db, "UPDATE Veiculos SET IPVA = ? WHERE Conta = ? AND ID = ?", valor_total, v["Conta"], v["ID"])
        end
    end
end, config.ipva.tempo * 60000, 0)
------------/CONFIG IPVA\------------


addEvent("victor:html:changer", true)
addEventHandler("victor:html:changer", root, function(type, idPlayer, idVeiculo, adm, nickVehicle)
    if getPlayerFromID(tonumber(idPlayer)) then 
        if type == "add" then
            local fetchAdm = dbPoll(dbQuery(db,"SELECT idVeiculo FROM Estoque WHERE idVeiculo = ?",idVeiculo), -1)
            if #fetchAdm ~= 0 then 
                local id = NovoID ()
                dbExec(db, "INSERT INTO Veiculos VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", getAccountName(getPlayerAccount(getPlayerFromID(tonumber(idPlayer)))),id,nickVehicle, idVeiculo, "Guardado", "85, 37, 149, 146","0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0","Não","0","SemPlaca","0","1000","100")
                message(adm, "Veiculo adicionado!", "success")
            else 
                message(adm, "ID do veiculo não encontrado!", "error")
            end
        end 
        if type == "remove" then 
            local fetchAdm = dbPoll(dbQuery(db,"SELECT idVeiculo FROM Estoque WHERE idVeiculo = ?",idVeiculo), -1)
            if #fetchAdm ~= 0 then 
                dbExec(db, "DELETE FROM Veiculos WHERE Conta = ? AND Modelo = ?",getAccountName(getPlayerAccount(getPlayerFromID(tonumber(idPlayer)))), idVeiculo)
            else 
                message(adm, "ID do veiculo não encontrado!", "error")
            end
            
        end
    else 
        message(adm, "Player não encontrado!", "error")
    end
end)

addEvent("victor:html:changer:estoque", true)
addEventHandler("victor:html:changer:estoque", root, function(adm, type, idVeiculo, quantia)
    t = os.date ("*t")
    data = t.day.."/"..t.month.."/"..t.year.." "..t.hour..":"..t.min
    if type == "set" then 
        local fetchAdm = dbPoll(dbQuery(db,"SELECT idVeiculo,Estoque FROM Estoque WHERE idVeiculo = ?",idVeiculo), -1)
        if #fetchAdm ~= 0 then 
            dbExec(db, "UPDATE Estoque SET Estoque = ? WHERE idVeiculo = ?",quantia, idVeiculo)
            message(adm, "ID "..idVeiculo.." alterado para "..quantia.." estoque disponiveis!", "success")
            exports.eovictorkrlPainelTpAdm:sendDiscordMessage("☠ [PAINEL-ADMIN] Veiculo do ID "..idVeiculo.." Foi alterado o estoque de "..fetchAdm[1]["Estoque"].." para "..quantia.." [SET]\n"..data)
        else
            message(adm, "ID do veiculo não encontrado!", "error")
        end
    end
    if type == "somar" then 
        local fetchAdm = dbPoll(dbQuery(db,"SELECT idVeiculo, Estoque FROM Estoque WHERE idVeiculo = ?",idVeiculo), -1)
        local calc = tonumber(quantia) + tonumber(fetchAdm[1]["Estoque"])
        if #fetchAdm ~= 0 then 
            dbExec(db, "UPDATE Estoque SET Estoque = ? WHERE idVeiculo = ?",tostring(calc), idVeiculo)
            message(adm, "ID "..idVeiculo.." alterado para "..calc.." estoque disponiveis!", "success")
            exports.eovictorkrlPainelTpAdm:sendDiscordMessage("☠ [PAINEL-ADMIN] Veiculo do ID "..idVeiculo.." Foi alterado o estoque de "..fetchAdm[1]["Estoque"].." para "..calc.." [SOMAR]\n"..data)
        else 
            message(adm, "ID do veiculo não encontrado!", "error")
        end
    end

end)

addEvent("victor:transferencia:check", true)
addEventHandler("victor:transferencia:check", root, function(id, xv, yv, zv, a)
    local data = getPlayerFromID(tonumber(id))
    if data then 
        local x, y, z = getElementPosition(data)
        local distancia = getDistanceBetweenPoints3D(xv, yv, zv, x, y, z)
        if distancia <= 10 then 
            local nomeJogador = getPlayerName(getPlayerFromAccountName(getAccountName(getPlayerAccount(data))))
            local data2 = getAccountName(getPlayerAccount(data))
            setTimer(function()
                triggerClientEvent(a, "victor:vendedor:icognita", a, true, data2, data)
                setTimer(function()
                    removeEventHandler("victor:transferencia:check", root, function() end)
                end, 1000,1)
            end,2000, 1)
        else 
            triggerClientEvent(root, "victor:vendedor:icognita", root, 'distancia', data2, data)
            setTimer(function()
                removeEventHandler("victor:transferencia:check", root, function() end)
            end, 1000,1)
        end
    else 
        triggerClientEvent(root, "victor:vendedor:icognita", root, false)
        setTimer(function()
            removeEventHandler("victor:transferencia:check", root, function() end)
        end, 1000,1)
    end

end)


addEvent("victor:transferencia:senderscreen", true)
addEventHandler("victor:transferencia:senderscreen", root, function(a, b, c, d, e, f, g)
    if d == g then 
        return
    end
    triggerClientEvent(a, "victor:comprador:open", a, b, c, d, e, f)
end)

addEvent("victor:cash:take", true)
addEventHandler("victor:cash:take", root, function(comprador, money_retirar_comprador, vendedor, money_dar_vendedor, idtabela)
    takePlayerMoney(comprador, money_retirar_comprador)
    givePlayerMoney(vendedor, money_dar_vendedor)
    local contaComprador = getAccountName(getPlayerAccount(comprador))
    dbExec(db,"UPDATE Veiculos SET Conta = ? WHERE ID = ?", contaComprador, idtabela)
end)