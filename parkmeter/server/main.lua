RegisterNetEvent("parkmeter:dostatitem", function(playerId, item, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local success = exports.ox_inventory:AddItem(playerId, item, amount)
    
end)
