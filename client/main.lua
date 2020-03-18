ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
        
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterCommand('logout', function(source, args, rawCommand)
    for i=1, #Config.Logouts, 1 do
    	local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(player, 0)
        local logoutspot = Config.Logouts[i]
		local logoutDistance = GetDistanceBetweenCoords(logoutspot, coords, true)
		if logoutDistance <= 3 then
			TriggerEvent('kashactersC:ReloadCharacters')
        end
    end
end)


-- Create Blips
Citizen.CreateThread(function()
	for i = 1, #Config.Logouts, 1 do
		local blip = AddBlipForCoord(Config.Logouts[i])
		SetBlipSprite (blip, 280)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Logout")
		EndTextCommandSetBlipName(blip)
	end
end)


-- Display Marker & Drawtext
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			local player = GetPlayerPed(-1)
			local coords = GetEntityCoords(player, 0)
			for i = 1, #Config.Logouts, 1 do

			local logoutspot = Config.Logouts[i]
			local logoutdistance = GetDistanceBetweenCoords(coords['x'], coords['y'], coords['z'], logoutspot['x'], logoutspot['y'], logoutspot['z'], true)
			if logoutdistance <= 3 then
				Draw3DText(logoutspot['x'],logoutspot['y'],logoutspot['z'], '~w~Type ~g~/logout~s~ ~w~to swap Characters~s~.')
				DrawMarker(Config.Type, logoutspot['x'], logoutspot['y'], logoutspot['z'] - 1, 0, 0, 0, 0, 0, 0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 250, false, false, 2, true, false, false, false)
			end
		end
	end
end)
