ESX = nil
local matot = false
local cMatot = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('arp:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
	RequestModel('p_ld_stinger_s')
	while not HasModelLoaded('p_ld_stinger_s') do
		Wait(1)
	end
	Citizen.Wait(3000)
	TriggerServerEvent('matot:ota')
end)

RegisterNetEvent('arp:setJob')
AddEventHandler('arp:setJob', function()
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('matot:kayta')
AddEventHandler('matot:kayta', function()
	local c = GetEntityCoords(GetPlayerPed(-1))
	local h = GetEntityHeading(GetPlayerPed(-1))
	TriggerServerEvent('matot:lisaa', c.x, c.y, c.z, h)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if ESX ~= nil and PlayerData ~= nil then
			if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				if matot then
					if json.encode(cMatot) ~= "[]" then
						for f,y in pairs(cMatot) do
							local omatC = GetEntityCoords(GetPlayerPed(-1))
							local matonC = vector3(y.x, y.y, y.z)
							if GetDistanceBetweenCoords(omatC, matonC, false) < 2.0 then
								ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ ottaaksesi piikkimaton pois')
								if IsControlJustReleased(0, 38) then
									TriggerServerEvent('matot:poista', y.id)
								end
							end
						end
					end
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(250)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local auto = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if auto ~= 0 then
			local obj = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1)), 25.0, GetHashKey('p_ld_stinger_s'), false, false, false)
			if DoesEntityExist(obj) then
				local objC = GetEntityCoords(obj)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), objC, true) < 2.0 then
					for i=0, 7, 1 do
						SetVehicleTyreBurst(auto, i, true, 1000)
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('matot:ekakerta')
AddEventHandler('matot:ekakerta', function(d)
	Citizen.Wait(3000)
	for x, z in pairs(d) do
		local matto = CreateObject(GetHashKey('p_ld_stinger_s'), tonumber(z.x), tonumber(z.y), tonumber(z.z), false, true, true)
		SetEntityHeading(matto, z.h)
		PlaceObjectOnGroundProperly(matto)
		table.insert(cMatot, {["id"] = z.id, ["matto"] = matto, ["x"] = z.x, ["y"] = z.y, ["z"] = z.z, ["h"] = z.h})
	end
	matot = true
end)

RegisterNetEvent('matot:uusi')
AddEventHandler('matot:uusi', function(x, y, z, h, id)
	local matto = CreateObject(GetHashKey('p_ld_stinger_s'), tonumber(x), tonumber(y), tonumber(z), false, true, true)
	table.insert(cMatot, {["id"] = id, ["matto"] = matto, ["x"] = x, ["y"] = y, ["z"] = z, ["h"] = h})
	SetEntityHeading(matto, h)
	PlaceObjectOnGroundProperly(matto)
end)

RegisterNetEvent('matot:cpoista')
AddEventHandler('matot:cpoista', function(m)
	for k,v in pairs(cMatot) do
		if v.id == m then
			DeleteEntity(v.matto)
			table.remove(cMatot, k)
			break
		end
	end
end)

AddEventHandler('onClientResourceStop', function(n)
	if n == GetCurrentResourceName() then
		for k,v in pairs(cMatot) do
			DeleteObject(v.matto)
		end
	end
end)