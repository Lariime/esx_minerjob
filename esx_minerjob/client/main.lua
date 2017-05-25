local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local GUI                     = {}
GUI.Time                      = 0
local hasAlreadyEnteredMarker = false;
local lastZone                = nil;
local Blips                   = {}

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent('esx_minerjob:requestPlayerData', 'playerSpawned')
end)

AddEventHandler('esx_minerjob:hasEnteredMarker', function(zone)

	if zone == 'CloakRoom' then
		SendNUIMessage({
			showControls = true,
			controls     = 'cloakroom'
		})
	end

	if zone == 'Mine' then
		SendNUIMessage({
			showControls = true,
			controls     = 'mine'
		})
	end

	if zone == 'StoneWash' then
		SendNUIMessage({
			showControls = true,
			controls     = 'stonewash'
		})
	end

	if zone == 'Foundry' then
		SendNUIMessage({
			showControls = true,
			controls     = 'foundry'
		})
	end

	if zone == 'VehicleSpawner' then
		SendNUIMessage({
			showControls = true,
			controls     = 'vehiclespawner'
		})
	end

	if zone == 'CopperDelivery' then
		
		if Blips['copperdelivery'] ~= nil then
			RemoveBlip(Blips['copperdelivery'])
			Blips['copperdelivery'] = nil
		end

		SendNUIMessage({
			showControls = true,
			controls     = 'copperdelivery'
		})

	end
	
	if zone == 'IronDelivery' then
		
		if Blips['irondelivery'] ~= nil then
			RemoveBlip(Blips['irondelivery'])
			Blips['irondelivery'] = nil
		end

		SendNUIMessage({
			showControls = true,
			controls     = 'irondelivery'
		})

	end
	
	if zone == 'GoldDelivery' then
		
		if Blips['golddelivery'] ~= nil then
			RemoveBlip(Blips['golddelivery'])
			Blips['golddelivery'] = nil
		end

		SendNUIMessage({
			showControls = true,
			controls     = 'golddelivery'
		})

	end
	
	if zone == 'DiamondDelivery' then
		
		if Blips['diamonddelivery'] ~= nil then
			RemoveBlip(Blips['diamonddelivery'])
			Blips['diamonddelivery'] = nil
		end

		SendNUIMessage({
			showControls = true,
			controls     = 'diamonddelivery'
		})

	end

end)

AddEventHandler('esx_minerjob:hasExitedMarker', function(zone)

	if zone == 'Mine' then
		TriggerServerEvent('esx_minerjob:stopHarvestStone')
	end

	if zone == 'StoneWash' then
		TriggerServerEvent('esx_minerjob:stopWashStone')
	end

	if zone == 'Foundry' then
		TriggerServerEvent('esx_minerjob:stopFounderingStone')
	end

	if zone == 'CopperDelivery' then
		TriggerServerEvent('esx_minerjob:stopCopperResell')
	end
	
	if zone == 'IronDelivery' then
		TriggerServerEvent('esx_minerjob:stopIronResell')
	end
	
	if zone == 'GoldDelivery' then
		TriggerServerEvent('esx_minerjob:stopGoldResell')
	end
	
	if zone == 'DiamondDelivery' then
		TriggerServerEvent('esx_minerjob:stopDiamondResell')
	end

	SendNUIMessage({
		showControls = false,
		showMenu     = false,
	})

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_minerjob:responsePlayerData')
AddEventHandler('esx_minerjob:responsePlayerData', function(data, reason)
	PlayerData = data
end)

RegisterNUICallback('select', function(data, cb)

	if data.menu == 'cloakroom' then

		if data.val == 'citizen_wear' then
			TriggerEvent('esx_skin:loadSkin', PlayerData.skin)
		end

		if data.val == 'miner_wear' then
			if PlayerData.skin.sex == 0 then
				TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, PlayerData.job.skin_male)
			else
				TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, PlayerData.job.skin_female)
			end
		end

	end

	if data.menu == 'vehiclespawner' then

    local playerPed = GetPlayerPed(-1)

		Citizen.CreateThread(function()

			local coords       = Config.Zones.VehicleSpawnPoint.Pos
			local vehicleModel = GetHashKey(data.val)

			RequestModel(vehicleModel)

			while not HasModelLoaded(vehicleModel) do
				Citizen.Wait(0)
			end

			if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, 45.0, true, false)
				SetVehicleHasBeenOwnedByPlayer(vehicle,  true)
				SetEntityAsMissionEntity(vehicle,  true,  true)
				local id = NetworkGetNetworkIdFromEntity(vehicle)
				SetNetworkIdCanMigrate(id, true)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			end

		end)

	end

	cb('ok')

end)

RegisterNUICallback('select_control', function(data, cb)

	if data.control == 'mine' then

		TriggerServerEvent('esx_minerjob:startHarvestStone')

		SendNUIMessage({
			showControls = false
		})

	end

	if data.control == 'stonewash' then

		TriggerServerEvent('esx_minerjob:startWashStone')

		SendNUIMessage({
			showControls = false
		})
		
	end

	if data.control == 'foundry' then

		TriggerServerEvent('esx_minerjob:startFounderingStone')

		SendNUIMessage({
			showControls = false
		})
		
	end

	if data.control == 'copperdelivery' then
		
		TriggerServerEvent('esx_minerjob:startCopperResell')

		SendNUIMessage({
			showControls = false
		})

	end
	
	if data.control == 'irondelivery' then
		
		TriggerServerEvent('esx_minerjob:startIronResell')

		SendNUIMessage({
			showControls = false
		})

	end
	
	if data.control == 'golddelivery' then
		
		TriggerServerEvent('esx_minerjob:startGoldResell')

		SendNUIMessage({
			showControls = false
		})

	end
	
	if data.control == 'diamonddelivery' then
		
		TriggerServerEvent('esx_minerjob:startDiamondResell')

		SendNUIMessage({
			showControls = false
		})

	end

	cb('ok')
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if(PlayerData.job ~= nil and PlayerData.job.name == 'miner' and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if(PlayerData.job ~= nil and PlayerData.job.name == 'miner') then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x / 2) then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_minerjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_minerjob:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- Create blips
Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.Mine.Pos.x, Config.Zones.Mine.Pos.y, Config.Zones.Mine.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Mine")
  EndTextCommandSetBlipName(blip)

end)

Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.StoneWash.Pos.x, Config.Zones.StoneWash.Pos.y, Config.Zones.StoneWash.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Netoyage de pierre")
  EndTextCommandSetBlipName(blip)

end)

Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.Foundry.Pos.x, Config.Zones.Foundry.Pos.y, Config.Zones.Foundry.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Fonderie")
  EndTextCommandSetBlipName(blip)

end)

Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.CopperDelivery.Pos.x, Config.Zones.CopperDelivery.Pos.y, Config.Zones.CopperDelivery.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Vente de Cuivre")
  EndTextCommandSetBlipName(blip)

end)

Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.IronDelivery.Pos.x, Config.Zones.IronDelivery.Pos.y, Config.Zones.IronDelivery.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Vente de Fer")
  EndTextCommandSetBlipName(blip)

end)

Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.GoldDelivery.Pos.x, Config.Zones.GoldDelivery.Pos.y, Config.Zones.GoldDelivery.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Vente d'or")
  EndTextCommandSetBlipName(blip)

end)

Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.DiamondDelivery.Pos.x, Config.Zones.DiamondDelivery.Pos.y, Config.Zones.DiamondDelivery.Pos.z)
  
  SetBlipSprite (blip, 318)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Vente de Diamant")
  EndTextCommandSetBlipName(blip)

end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if IsControlPressed(0, Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				enterPressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['BACKSPACE']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				backspacePressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['LEFT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'LEFT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['RIGHT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'RIGHT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['TOP']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'UP'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['DOWN']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'DOWN'
			})

			GUI.Time = GetGameTimer()

		end

	end
end)

Citizen.CreateThread(function()
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")
end)
