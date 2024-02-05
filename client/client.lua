local activeTextUIs = {}

---@param action string
---@param data any
local function sendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function handlePauseMenu()
    if IsPauseMenuActive() then
        sendReactMessage('pause', true)
        repeat Wait(100) until not IsPauseMenuActive()
        sendReactMessage('pause', false)
    end
end

---@param coords vector3
---@return boolean onScreen, {left: string, top: string}
local function getNuiPosFromCoords(coords)
    if not coords then return false, {} end
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 0.3)
    return onScreen, { left = tostring(x * 100) .. "%", top = tostring(y * 100) .. "%" }
end

---@param index number
local function createInteraction(index)
    local interactionData = Interactions[index]

    activeTextUIs[index] = {
        pos = { left = '50%', top = '50%' },
        show = false,
        active = false,
        currentDistance = 9999,
        isClosest = false,
        index = index,
        lastTrigger = 0,
        options = {}
    }

    -- Push Interaction Option Text
    for i,v in pairs(interactionData.options) do
        table.insert(activeTextUIs[index].options, {
            text = interactionData.options[i].text
        })    
    end
end

---@param index number
local function destroyInteraction(index)
    local interactionData = Interactions[index]

    activeTextUIs[index] = nil
    sendReactMessage('remove', index)
end


local loopActive = false
local activeinteractionIndex = nil

RegisterNUICallback('setSelectedIndexClient', function(data, cb)  
    if not activeinteractionIndex then return end

    local textUI = activeTextUIs[activeinteractionIndex]

    if not textUI then return end

    if textUI.active and textUI.show then
        activeTextUIs[activeinteractionIndex].lastTrigger = GetGameTimer()
        Interactions[activeinteractionIndex].options[data+1].onSelect()
    end
end)

--interact:disable(true)

local function textUILoop()
    if loopActive then return end
    loopActive = true
    while next(activeTextUIs) do
        local wait = 100
        local drawing = false
        activeinteractionIndex = nil
        for index, textUI in pairs(activeTextUIs) do
            local interactionData = Interactions[textUI.index]
            local inTimeOut = GetGameTimer() - textUI.lastTrigger < (1000)
            local onScreen, position = getNuiPosFromCoords(textUI.coords)
            local active = (textUI.currentDistance < (3.0) and textUI.isClosest)
            local inDistance = textUI.currentDistance < (5.0)


            activeTextUIs[index].pos = position
            activeTextUIs[index].show = onScreen and not inTimeOut and inDistance
            activeTextUIs[index].active = active

            if active then
                activeinteractionIndex = textUI.index
            end

            if activeTextUIs[index].show and not drawing then
                wait = 10
                drawing = true
            end
        end

        sendReactMessage('textUIs', activeTextUIs)
        handlePauseMenu()
        Wait(wait)
    end
    loopActive = false
end

CreateThread(function()
    for i = 1, #Interactions do
        local interactionData = Interactions[i]
        local coords = interactionData.coords.xyz

        local point = lib.points.new({
            coords = coords,
            distance = interactionData.renderDistance,
        })

        function point:onEnter()
            createInteraction(i)

            -- NUI Flag for input
            SetNuiFocus(true,false)
            SetNuiFocusKeepInput(true)
            
            CreateThread(textUILoop)
        end

        function point:onExit()
            destroyInteraction(i)

            -- NUI Flag for input
            SetNuiFocus(false,false)
            SetNuiFocusKeepInput(false)
            
            lib.hideContext()
        end

        function point:nearby()
            local interactionData = Interactions[i]
            activeTextUIs[i].currentDistance = self.currentDistance
            activeTextUIs[i].isClosest = self.isClosest
            activeTextUIs[i].index = i
            activeTextUIs[i].coords = self.coords
        end
    end
end)