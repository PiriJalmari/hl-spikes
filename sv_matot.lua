ESX = nil
local sMatot = {}

TriggerEvent('arp:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('matot:lisaa')
AddEventHandler('matot:lisaa', function(x, y ,z, h)
	local uusid = 0
	for k,v in pairs(sMatot) do uusid = k + 1 end
	table.insert(sMatot, {["id"] = uusid, ["x"] = x, ["y"] = y, ["z"] = z, ["h"] = h})
	TriggerClientEvent('matot:uusi', -1, x, y ,z, h, uusid)
end)

RegisterServerEvent('matot:poista')
AddEventHandler('matot:poista', function(m)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addInventoryItem('piikkimatto', 1)
	for k,v in pairs(sMatot) do
		if v.id == m then
			table.remove(sMatot, k)
			TriggerClientEvent('matot:cpoista', -1, m)
			
			break
		end
	end
end)

RegisterServerEvent('matot:ota')
AddEventHandler('matot:ota', function()
	local src = source
	TriggerClientEvent('matot:ekakerta', src, sMatot)
end)

ESX.RegisterUsableItem('piikkimatto', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('piikkimatto', 1)
    TriggerClientEvent('matot:kayta', playerId)
end)

