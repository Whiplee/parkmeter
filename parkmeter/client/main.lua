local ESX = exports["es_extended"]:getSharedObject()
local usedEntities = {}

local cache = {
    serverId = GetPlayerServerId(PlayerId())
}

function playAnimation()
    local ped = PlayerPedId()
    local animDict = "anim@gangops@facility@servers@"
    local animName = "hotwire"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
end

function stopAnimation()
    ClearPedTasks(PlayerPedId())
end

function disableMovement()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, false)
end

function enableMovement()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
end

function progressCircle(duration, label)
    disableMovement()

    playAnimation()
    local cancelled = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 73) then  
                cancelled = true
                stopAnimation()
                enableMovement()
                break
            end
        end
    end)

    if exports["ox_lib"] then
        local success = exports.ox_lib:progressBar({
            duration = duration,
            label = label,
            canCancel = true
        })

        stopAnimation()
        enableMovement()
        return success and not cancelled
    else
        Citizen.Wait(duration)
        stopAnimation()
        enableMovement()
        return not cancelled
    end
end

function notify(message)
    ESX.ShowNotification(message)
end

SmallParkOpt = {
    {
        name = "parkmeter",
        label = "Search",
        icon = "fas fa-coins",
        distance = 2,
        onSelect = function(entity)
            local entityId = entity.entity  
            if usedEntities[entityId] then
                notify("In this stand is nothing!")
                return
            end

            if progressCircle(4000, "Searching Money...") then 
                TriggerServerEvent("parkmeter:dostatitem", cache.serverId, Config.SmallParkReward.item, Config.SmallParkReward.amount)
                usedEntities[entityId] = true
                notify("Money Found!")
            else 
                notify("Searching canceled!")
            end
        end
    }
}

BigParkOpt = {
    {
        name = "parkmeter",
        label = "Search",
        icon = "fas fa-coins",
        distance = 2,
        onSelect = function(entity)
            local entityId = entity.entity  
            if usedEntities[entityId] then
                notify("In this stand is nothing!")
                return
            end

            if progressCircle(5000, "Searching Money...") then 
                TriggerServerEvent("parkmeter:dostatitem", cache.serverId, Config.BigParkReward.item, Config.BigParkReward.amount)
                usedEntities[entityId] = true
                notify("Money Found!")
            else 
                notify("Searching canceled!")
            end
        end
    }
}

exports.ox_target:addModel(Config.SmallPark, SmallParkOpt)
exports.ox_target:addModel(Config.BigPark, BigParkOpt)
