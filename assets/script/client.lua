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

------------/CONFIG UTIL\------------
local screenW, screenH = guiGetScreenSize ()
local x, y = screenW/1280, screenH/720

local x2, y2 = screenW/1920, screenH/1080

local dxfont0_font = dxCreateFont("assets/font/font.ttf", y*11)
local dxfont1_font = dxCreateFont("assets/font/font.ttf", y*10)
local dxfont2_font = dxCreateFont("assets/font/font.ttf", y*15)
local dxfont3_font = dxCreateFont("assets/font/font.ttf", y*12)
local dxfont4_font = dxCreateFont("assets/font/font.ttf", y*7)
local dxfont5_font = dxCreateFont("assets/font/font.ttf", y*8)
local dxfont6_font = dxCreateFont("assets/font/font.ttf", y*14)

local vehicle = { }
local pos = { }
local visualizando = false


local scroll = { }
local values = { }
local visible = 6
local visible_2 = 8
local selected = 1

local window = 0

function message (message, type)
    triggerEvent(config.gerais.infobox, localPlayer, message, type)
end

function createEventHandler (event, ...)
    addEvent (event, true)
    addEventHandler (event, ...)
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function isCursorOnElement(x, y, w, h)
    if (not isCursorShowing()) then
        return false
    end
    local mx, my = getCursorPosition()
    local fullx, fully = guiGetScreenSize()
    cursorx, cursory = mx*fullx, my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
    end
end

function drawBorde(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 200)
        end
      
        if (not bgColor) then
            bgColor = borderColor
        end

        if not postGUI then
            postGUI = false
        end

        dxDrawRectangle(x, y, w, h, bgColor, postGUI)

        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI) -- top
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI) -- bottom
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI) -- left
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI) -- right
    end
end

function convertNumber (number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end

function dxDrawTextOnElement(TheElement, text, height, distance, R, G, B, alpha, size, font, ...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end
------------/CONFIG UTIL\------------

------------/CONFIG DX CONTROLLER\------------
createEventHandler ("MST.onPlayerCheckVehicles", getRootElement(),
function (posicao)
    if not isEventHandlerAdded ("onClientRender", getRootElement(), DX_Concessionaria) then
        values = { }
        for i, v in ipairs (config.veiculos) do
            table.insert (values, v)
        end
        addEventHandler ("onClientRender", getRootElement(), DX_Concessionaria)
        showCursor (true)
        scroll["GringoConcessionaria"] = 0
        selected = 0
        Parte = 1
        pos = { }
        table.insert (pos, posicao)
    end
end)

createEventHandler ("MST.onPlayerCheckGarage", getRootElement(),
function (data, vals)
    if not isEventHandlerAdded ("onClientRender", getRootElement(), DX_Garagem) then
        values = { }
        for i, v in ipairs (data) do
            table.insert (values, v)
        end
        addEventHandler ("onClientRender", getRootElement(), DX_Garagem)
        showCursor (true)
        scroll["GringoConcessionaria"] = 0
        selected = 0
        pos = { }
        table.insert (pos, vals)
    end
end)
createEventHandler ("MST.onVictorVenda", getRootElement(),
function()
    if not isEventHandlerAdded ("onClientRender", getRootElement(), DX_Venda) then 
        addEventHandler ("onClientRender", getRootElement(), DX_Venda)  
            showCursor(true)
            scroll["GringoConcessionaria"] = 0
            selected = 0
            window = 1
        end
    end

)
createEventHandler ("MST.onPlayerCheckDetran", getRootElement(),
function (data)
    if not isEventHandlerAdded ("onClientRender", getRootElement(), DX_Detran) then
        values = { }
        for i, v in ipairs (data) do
            table.insert (values, v)
        end
        addEventHandler ("onClientRender", getRootElement(), DX_Detran)
        showCursor (true)
        scroll["GringoConcessionaria"] = 0
        selected = 0
        window = 1
    end
end)

createEventHandler ("MST.onPlayerCloseEvents", getRootElement(),
function ()
    if isEventHandlerAdded ("onClientRender", getRootElement(), DX_Concessionaria) then
        if vehicle[localPlayer] and isElement (vehicle[localPlayer]) then destroyElement(vehicle[localPlayer]) vehicle[localPlayer] = nil end
        setCameraTarget (localPlayer)
        setElementFrozen (localPlayer, false)
        toggleAllControls (true)
        removeEventHandler ("onClientRender", getRootElement(), DX_Concessionaria)
        showCursor (false)
    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Garagem) then
        removeEventHandler ("onClientRender", getRootElement(), DX_Garagem)
        showCursor (false)
    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Detran) then
        removeEventHandler ("onClientRender", getRootElement(), DX_Detran)
        showCursor (false)
    end
end)
------------/CONFIG DX CONTROLLER\------------

------------/CONFIG DX\------------
function DX_Concessionaria ()
    if not visualizando then
        drawBorde(x*485, y*181, x*310, y*359, tocolor(28, 28, 28, 225), false)
        drawBorde(x*485, y*181, x*310, y*37, tocolor(28, 28, 28, 255), false)
        dxDrawText("Concessionária", x*572, y*188, x*709, y*204, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "center", "center", false, false, false, true, false)

        drawBorde(x*485, y*228, x*310, y*37, tocolor(28, 28, 28, 255), false)
        dxDrawText("Veículo", x*494, y*239, x*537, y*251, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
        dxDrawText("Preço", x*623, y*238, x*785, y*250, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
        dxDrawText("Visualizar", x*730, y*238, x*785, y*250, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)

        local data = scroll["GringoConcessionaria"] or 0
        for i = 1, visible do
            local valores = values[i + data]
            if valores then
                local val1 = (275 - 34) + (i * 34)
                local val2 = (280 - 34 * 2) + (i * 34 * 2)

                if selected == valores then
                    drawBorde(x*485, y*val1, x*310, y*27, tocolor(70,130,180, 200), false)
                else
                    drawBorde(x*485, y*val1, x*310, y*27, tocolor(28, 28, 28, 255), false)
                end

                dxDrawText(valores.name, x*494, y*val2 + y*2, x*566, y*292, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
                dxDrawText("R$"..convertNumber(valores.price)..",00", x*623, y*val2 + y*2, x*785, y*292, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)

                if isCursorOnElement (x*750, y*val1 + y*4, x*21, y*18) then 
                    dxDrawImage (x*750, y*val1 + y*4, x*21, y*18, "assets/gfx/1.png", 0, 0, 0, tocolor (255, 255, 255, 255), false)
                else
                    dxDrawImage (x*750, y*val1 + y*4, x*21, y*18, "assets/gfx/2.png", 0, 0, 0, tocolor (255, 255, 255, 255), false)
                end
            end
        end

        if isCursorOnElement (x*556, y*503, x*169, y*27) then
            drawBorde(x*556, y*503, x*169, y*27, tocolor(70,130,180, 200), false)
        else
            drawBorde(x*556, y*503, x*169, y*27, tocolor(28, 28, 28, 255), false)
        end
        dxDrawText("Comprar", x*579, y*510, x*703, y*520, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, true, false)
    else
        dxDrawRectangle(x*971, y*574, x*299, y*136, tocolor(28, 28, 28, 225), false)
        dxDrawRectangle(x*971, y*584, x*124, y*126, tocolor(28, 28, 28, 255), false)
        
        if fileExists ("assets/gfx/types/"..string.lower(selected.mark)..".png") then
            dxDrawImage(x*976, y*598, x*115, y*90, "assets/gfx/types/"..string.lower(selected.mark)..".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        end

        dxDrawText("Concessionária BRR", x*1097, y*590, x*1260, y*585, tocolor(255, 255, 255, 255), 1.00, dxfont3_font, "center", "center", false, false, false, true, false)
        dxDrawText("Estoque disponível : #00FF7F"..estoqueGeral, x*1101, y*617, x*1268, y*594, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
        dxDrawText("Marca : #00FF7F"..selected.mark, x*1101, y*617, x*1268, y*629, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
        dxDrawText("Porta-Malas : #00FF7F"..selected.capacity.." KG", x*1101, y*639, x*1268, y*651, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
        dxDrawText("Velocidade :", x*1101, y*661, x*1175, y*673, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
            
        drawBorde(x*1176, y*663, x*92, y*12, tocolor(28, 28, 28, 255), false)
        drawBorde(x*1176, y*663, x*92*selected.velocity/config.gerais.velocitymax, y*12, tocolor(70,130,180, 255), false)
            
        dxDrawText(selected.velocity.." KM", x*1236, y*665, x*1260, y*673, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)
        dxDrawText("Pressione \"backspace\" para sair.", x*1103, y*692, x*1260, y*700, tocolor(255, 255, 255, 255), 1.00, dxfont5_font, "center", "center", false, false, false, true, false)
            


        if vehicle[localPlayer] and isElement(vehicle[localPlayer]) then
            if Parte == 1 then
                rt = interpolateBetween(0, 0, 0, 360, 0, 0, (getTickCount() - tick)/20000, "Linear")
                if rt == 360 then
                    Parte = 2
                    tick_3 = getTickCount()
                end
            elseif Parte == 2 then
                rt = interpolateBetween(360, 0, 0, 0, 0, 0, (getTickCount() - tick)/20000, "Linear")
                if rt == 0 then
                    Parte = 1
                    tick_3 = getTickCount()
                end
            end
            setElementRotation(vehicle[localPlayer], 0, 0, rt)
        end
    end
end

function DX_Garagem ()
    drawBorde(x*485, y*181, x*310, y*359, tocolor(28, 28, 28, 225), false)
    drawBorde(x*485, y*181, x*310, y*37, tocolor(28, 28, 28, 255), false)
    dxDrawText("Garagem", x*572, y*188, x*709, y*204, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "center", "center", false, false, false, true, false)
    
    drawBorde(x*485, y*228, x*310, y*37, tocolor(28, 28, 28, 255), false)
    dxDrawText("Veículo", x*494, y*239, x*537, y*251, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
    dxDrawText("Estado", x*615, y*238, x*785, y*250, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
    dxDrawText("Motor", x*730, y*238, x*785, y*250, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
    
    local data = scroll["GringoConcessionaria"] or 0
    for i = 1, visible do
        local valores = values[i + data]
        if valores then
            local val1 = (275 - 34) + (i * 34)
            local val2 = (280 - 34 * 2) + (i * 34 * 2)
            
            local vida = math.floor (valores.Vida / 10)

            if selected == valores then
                drawBorde(x*485, y*val1, x*310, y*27, tocolor(70,130,180, 200), false)
            else
                drawBorde(x*485, y*val1, x*310, y*27, tocolor(28, 28, 28, 255), false)
            end
            
            dxDrawText(valores.Nome, x*494, y*val2 + y*2, x*566, y*292, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
            dxDrawText(valores.Estado, x*615, y*val2 + y*2, x*785, y*292, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
            dxDrawText(vida.."%", x*730, y*val2 + y*2, x*785, y*292, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "left", "center", false, false, false, true, false)
        end
    end
    
    if isCursorOnElement (x*556, y*503, x*169, y*27) then
        drawBorde(x*556, y*503, x*169, y*27, tocolor(70,130,180, 200), false)
    else
        drawBorde(x*556, y*503, x*169, y*27, tocolor(28, 28, 28, 255), false)
    end
    if selected ~= 0 then
        if selected.Estado == "Guardado" then
            dxDrawText("Retirar", x*579, y*510, x*703, y*520, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, true, false)
        elseif selected.Estado == "Roubado" then
            dxDrawText("Retirar", x*579, y*510, x*703, y*520, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, true, false)
        elseif selected.Estado == "Apreendido" then
            dxDrawText("Retirar", x*579, y*510, x*703, y*520, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, true, false)
        elseif selected.Estado == "Spawnado" then
            dxDrawText("Guardar", x*579, y*510, x*703, y*520, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, true, false)
        end
    else
        dxDrawText("Retirar", x*579, y*510, x*703, y*520, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, true, false)
    end
end

function DX_Detran ()
    drawBorde(x2*671, y2*299, x2*578, y2*483, tocolor(28, 28, 28, 225), false)
    drawBorde(x2*671, y2*299, x2*578, y2*59, tocolor(28, 28, 28, 255), false)
    dxDrawText("Detran", x2*749, y2*309, x2*1180, y2*348, tocolor(255, 255, 255, 255), 1.00, dxfont1_font, "center", "center", false, false, false, false, false)

    drawBorde(x2*671, y2*368, x2*578, y2*43, tocolor(28, 28, 28, 255), false)
    dxDrawText("Veículo", x2*683, y2*378, x2*764, y2*401, tocolor(255, 255, 255, 255), 1.00, dxfont5_font, "center", "center", false, false, false, true, false)
    dxDrawText("Estado", x2*810, y2*378, x2*906, y2*401, tocolor(255, 255, 255, 255), 1.00, dxfont5_font, "center", "center", false, false, false, true, false)
    dxDrawText("Seguro", x2*929, y2*378, x2*1019, y2*401, tocolor(255, 255, 255, 255), 1.00, dxfont5_font, "center", "center", false, false, false, true, false)
    dxDrawText("Placa", x2*1056, y2*378, x2*1138, y2*401, tocolor(255, 255, 255, 255), 1.00, dxfont5_font, "center", "center", false, false, false, true, false)
    dxDrawText("IPVA", x2*1170, y2*378, x2*1246, y2*401, tocolor(255, 255, 255, 255), 1.00, dxfont5_font, "center", "center", false, false, false, true, false)

    
    local data = scroll["GringoConcessionaria"] or 0
    for i = 1, visible_2 do
        local valores = values[i + data]
        if valores then
            local val1 = (421 - 31) + (i * 31)
            local val2 = (431 - 62) + (i * 62)
            
            if selected == valores then
                drawBorde(x2*671, y2*val1, x2*578, y2*24, tocolor(70,130,180, 175), false)
            else
                drawBorde(x2*671, y2*val1, x2*578, y2*24, tocolor(28, 28, 28, 255), false)
            end
            
            dxDrawText(valores.Nome, x2*671 + x2*15, y2*val2, x2*764, y2*438, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, false, false)
            dxDrawText(valores.Estado, x2*810, y2*val2, x2*906, y2*438, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, false, false)
            dxDrawText(valores.Seguro, x2*929, y2*val2, x2*1019, y2*438, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, false, false)
            dxDrawText(valores.Placa, x2*1056, y2*val2, x2*1138, y2*438, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, false, false)
            dxDrawText(valores.IPVA, x2*1170, y2*val2, x2*1246, y2*438, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, false, false)
        end
    end
    
    if window == 1 then
        drawBorde(x2*681, y2*735, x2*132, y2*37, isCursorOnElement(x2*681, y2*735, x2*132, y2*37) and tocolor (70,130,180, 175) or tocolor (28, 28, 28, 175), false)
        dxDrawText("Localizar", x2*686, y2*745, x2*810, y2*758, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)
        
        drawBorde(x2*823, y2*735, x2*132, y2*37, isCursorOnElement(x2*823, y2*735, x2*132, y2*37) and tocolor (70,130,180, 175) or tocolor (28, 28, 28, 175), false)
        dxDrawText("Retirar", x2*828, y2*745, x2*953, y2*758, tocolor (255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)
        
        drawBorde(x2*965, y2*735, x2*132, y2*37, isCursorOnElement(x2*965, y2*735, x2*132, y2*37) and tocolor (70,130,180, 175) or tocolor (28, 28, 28, 175), false)
        dxDrawText("Emplacar", x2*970, y2*745, x2*1095, y2*758, tocolor (255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)
        
        drawBorde(x2*1107, y2*735, x2*132, y2*37, isCursorOnElement(x2*1107, y2*735, x2*132, y2*37) and tocolor (70,130,180, 175) or tocolor (28, 28, 28, 175), false)
        dxDrawText("Pagar", x2*1112, y2*745, x2*1237, y2*758, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)
		
        drawBorde(x2*1107, y2*686, x2*132, y2*37, isCursorOnElement(x2*1107, y2*686, x2*132, y2*37) and tocolor (70,130,180, 175) or tocolor (28, 28, 28, 175), false)
        dxDrawText("Seguro", x2*1107, y2*650, x2*1245, y2*758, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)

        drawBorde(x2*962, y2*686, x2*132, y2*37,  isCursorOnElement( x2*962, y2*686, x2*132, y2*37) and tocolor (70,130,180, 175) or tocolor (28, 28, 28, 175), false)
        dxDrawText("Transferir", x2*1040, y2*378, x2*1019, y2*1031, tocolor(255, 255, 255, 255), 1.00, dxfont4_font, "center", "center", false, false, false, true, false)
    end
end
------------/CONFIG DX\------------

------------/CONFIG DX CLICK\------------
addEventHandler ("onClientClick", getRootElement(),
function (button, state)
    if isEventHandlerAdded ("onClientRender", getRootElement(), DX_Concessionaria) then
        if button == "left" and state == "down" then
            for i = 1, visible do
                local data = scroll["GringoConcessionaria"] or 0
                local data = values[i + data]
                if data then
                    local val1 = (275 - 34) + (i * 34)
                    if isCursorOnElement (x*485, y*val1, x*310, y*27) and not isCursorOnElement (x*750, y*val1 + y*4, x*21, y*18) then
                        selected = data
                        break
                    elseif isCursorOnElement (x*750, y*val1 + y*4, x*21, y*18) then
                        if selected ~= 0 then
                            if vehicle[localPlayer] and isElement (vehicle[localPlayer]) then destroyElement(vehicle[localPlayer]) vehicle[localPlayer] = nil end
                            tick = getTickCount ()
                            vehicle[localPlayer] = createVehicle (selected.model, config.camera.posicaoveiculo[1], config.camera.posicaoveiculo[2], config.camera.posicaoveiculo[3] + 0.5, 0, 0, config.camera.posicaoveiculo[4])
                            setCameraMatrix (config.camera.cameraveiculo[1], config.camera.cameraveiculo[2], config.camera.cameraveiculo[3], config.camera.cameraveiculo[4], config.camera.cameraveiculo[5], config.camera.cameraveiculo[6], config.camera.cameraveiculo[7], config.camera.cameraveiculo[8])
                            setElementFrozen (localPlayer, true)
                            setElementFrozen (vehicle[localPlayer], true)
                            toggleAllControls (false)
                            triggerServerEvent("victor:estoque", localPlayer, selected.model)
                            addEvent("victor:receivEstoque", true )
                            addEventHandler("victor:receivEstoque", root, function(estoque)
                                estoqueGeral = tonumber(estoque)
                                global_estoque = estoque
                                if estoqueGeral == nil then 
                                    estoqueGeral = estoque
                                end
                                setTimer(function()
                                    visualizando = true
                                end,0500,1)
                                
                            end)
                            break
                        else
                            message ("Selecione algum veículo da lista.", "error")
                            break
                        end
                    end
                end
            end
            if isCursorOnElement (x*556, y*503, x*169, y*27) then
                if selected ~= 0 then
                    if visualizando then return end
                    triggerServerEvent ("MST.onPlayerBuyVehicle", localPlayer, localPlayer, selected, math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
                    selected = 0
                else
                    message ("Selecione algum veículo da lista.", "error")
                end
            end
        end
    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Garagem) then
        if button == "left" and state == "down" then
            for i = 1, visible do
                local data = scroll["GringoConcessionaria"] or 0
                local data = values[i + data]
                if data then
                    local val1 = (275 - 31) + (i * 31)
                    if isCursorOnElement (x*485, y*val1, x*310, y*31) then
                        selected = data
                        break
                    end
                end
            end
            if isCursorOnElement (x*556, y*503, x*169, y*27) then
                if selected ~= 0 then
                    if selected.Estado == "Guardado" then
                        triggerServerEvent ("MST.onPlayerExecuteGarageFuncs", localPlayer, localPlayer, "Retirar", selected, pos[1][1][1], pos[1][1][2], pos[1][1][3], pos[1][1][4], pos[1][1][5], pos[1][1][6])
                        selected = 0
                    elseif selected.Estado == "Roubado" then
                        triggerServerEvent ("MST.onPlayerExecuteGarageFuncs", localPlayer, localPlayer, "Retirar", selected, pos[1][1][1], pos[1][1][2], pos[1][1][3], pos[1][1][4], pos[1][1][5], pos[1][1][6])
                        selected = 0
                    elseif selected.Estado == "Apreendido" then
                        triggerServerEvent ("MST.onPlayerExecuteGarageFuncs", localPlayer, localPlayer, "Retirar", selected, pos[1][1][1], pos[1][1][2], pos[1][1][3], pos[1][1][4], pos[1][1][5], pos[1][1][6])
                        selected = 0
                    elseif selected.Estado == "Spawnado" then
                        triggerServerEvent ("MST.onPlayerExecuteGarageFuncs", localPlayer, localPlayer, "Guardar", selected)
                        selected = 0
                    end
                else
                    message ("Selecione algum veículo da lista.", "error")
                end
            end
        end
    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Detran) then
        if button == "left" and state == "down" then
            for i = 1, visible_2 do
                local data = scroll["GringoConcessionaria"] or 0
                local data = values[i + data]
                if data then
                    local val1 = (421 - 31) + (i * 31)
                    if isCursorOnElement (x2*678, y2*val1, x2*578, y2*31) then
                        selected = data
                        break
                    end
                end
            end
            if window == 1 then
                if isCursorOnElement (x2*681, y2*735, x2*132, y2*37) then
                    if selected ~= 0 then
                        triggerServerEvent ("MST.onPlayerExecuteDetranFuns", localPlayer, localPlayer, "Localizar", selected)
                        selected = 0
                    else
                        message ("Selecione algum de seus Veículos.", "error")
                    end
                elseif isCursorOnElement (x2*823, y2*735, x2*132, y2*37) then
                    if selected ~= 0 then
                        triggerServerEvent ("MST.onPlayerExecuteDetranFuns", localPlayer, localPlayer, "Retirar", selected)
                        selected = 0
                    else
                        message ("Selecione algum de seus Veículos.", "error")
                    end
                elseif isCursorOnElement (x2*962, y2*686, x2*132, y2*37) then -- Transferir veiculo
                    if selected ~= 0 then 
                        removeEventHandler ("onClientRender", getRootElement(), DX_Detran)
                        triggerServerEvent ("MST.onPlayerExecuteDetranFuns", localPlayer, localPlayer, "Transferir", selected) -- Muda aqui
                        selected = 0
                    else 
                        message ("Selecione algum de seus Veículos.", "error")
                    end
                elseif isCursorOnElement (x2*965, y2*735, x2*132, y2*37) then
                    if selected ~= 0 then
                        triggerServerEvent ("MST.onPlayerExecuteDetranFuns", localPlayer, localPlayer, "Emplacar", selected)
                        selected = 0
                    else
                        message ("Selecione algum de seus Veículos.", "error")
                    end
                elseif isCursorOnElement (x2*1107, y2*735, x2*132, y2*37) then
                    if selected ~= 0 then
                        triggerServerEvent ("MST.onPlayerExecuteDetranFuns", localPlayer, localPlayer, "Pagar", selected)
                        selected = 0
                    else
                        message ("Selecione algum de seus Veículos.", "error")
                    end
                end
                if isCursorOnElement (x2*1107, y2*686, x2*132, y2*37) then
                    if selected ~= 0 then
                        triggerServerEvent ("MST.onPlayerExecuteDetranFuns", localPlayer, localPlayer, "Seguro", selected)
                        selected = 0
                    else
                        message ("Selecione algum de seus Veículos.", "error")
                    end
                end
            end
        end
    end
end)
------------/CONFIG DX CLICK\------------

------------/CONFIG DX BUTTONS\------------
function allValuesInPanel (button)
    if isEventHandlerAdded ("onClientRender", getRootElement(), DX_Concessionaria) then
        if isCursorOnElement (x*484, y*274, x*312, y*200) then
            local data = scroll["GringoConcessionaria"] or 0
            if button == "mouse_wheel_up" and data > 0 then
                data = data - 1
            elseif button == "mouse_wheel_down" and data < #values - visible then
                data = data + 1
            end
            scroll["GringoConcessionaria"] = data
        end
        if button == "backspace" then
            if visualizando then
                if vehicle[localPlayer] and isElement (vehicle[localPlayer]) then destroyElement(vehicle[localPlayer]) vehicle[localPlayer] = nil end
                setElementPosition(localPlayer, pos[1][1], pos[1][2], pos[1][3])
                setCameraTarget (localPlayer)
                setElementFrozen (localPlayer, false)
                toggleAllControls (true)
                visualizando = false
            else
                removeEventHandler ("onClientRender", getRootElement(), DX_Concessionaria)
                showCursor (false)
            end
        end
    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Venda) then 
        if isCursorOnElement(x*484, y*274, x*312, y*200) then 
            local data = scroll["GringoConcessionaria"] or 0 
            if button == "mouse_wheel_up" and data > 0 then
                data = data - 1
            elseif button == "mouse_wheel_down" and data < #values - visible then 
                data = data + 1
            end
            scroll["GringoConcessionaria"] = data 
        end



    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Garagem) then
        if isCursorOnElement (x*484, y*274, x*312, y*200) then
            local data = scroll["GringoConcessionaria"] or 0
            if button == "mouse_wheel_up" and data > 0 then
                data = data - 1
            elseif button == "mouse_wheel_down" and data < #values - visible then
                data = data + 1
            end
            scroll["GringoConcessionaria"] = data
        end
        if button == "backspace" then
            removeEventHandler ("onClientRender", getRootElement(), DX_Garagem)
            showCursor (false)
        end
    elseif isEventHandlerAdded ("onClientRender", getRootElement(), DX_Detran) then
        if isCursorOnElement (x2*678, y2*368, x2*578, y2*165) then
            local data = scroll["GringoConcessionaria"] or 0
            if button == "mouse_wheel_up" and data > 0 then
                data = data - 1
            elseif button == "mouse_wheel_down" and data < #values - visible then
                data = data + 1
            end
            scroll["GringoConcessionaria"] = data
        end
        if button == "backspace" then
            removeEventHandler ("onClientRender", getRootElement(), DX_Detran)
            showCursor (false)
        elseif button == "arrow_l" and window - 1 == 1 then
            playSoundFrontEnd (32)
            window = window - 1
        elseif button == "arrow_r" and window + 1 == 2 then
            playSoundFrontEnd (32)
            window = window + 1
        else
            playSoundFrontEnd (33)
        end
    end
end
bindKey ("mouse_wheel_up", "down", allValuesInPanel)
bindKey ("mouse_wheel_down", "down", allValuesInPanel)
bindKey ("arrow_l", "down", allValuesInPanel)
bindKey ("arrow_r", "down", allValuesInPanel)
bindKey ("backspace", "down", allValuesInPanel)
------------/CONFIG DX BUTTONS\------------

------------/CONFIG DX TEXT\------------
addEventHandler ("onClientRender", getRootElement(),
function ()
    for i, v in ipairs (getElementsByType ("marker")) do
        if getElementData (v, "MST.onZoneDesmanche") then
            dxDrawTextOnElement (v, "", 2, 20, 255, 255, 255, 255, 1, dxfont2_font)
        elseif getElementData (v, "MST.onZoneApreensao") then
            dxDrawTextOnElement (v, "", 2, 20, 255, 255, 255, 255, 1, dxfont2_font)
        end
    end
end)
------------/CONFIG DX TEXT\------------