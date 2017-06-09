local PlayersHarvestingStone = {}
local PlayersWashingStone    = {}
local PlayersFoundringStone  = {}
local PlayersCopperReselling       = {}
local PlayersIronReselling       = {}
local PlayersGoldReselling       = {}
local PlayersDiamondReselling       = {}

RegisterServerEvent('esx_minerjob:requestPlayerData')
AddEventHandler('esx_minerjob:requestPlayerData', function(reason)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		TriggerEvent('esx_skin:requestPlayerSkinInfosCb', source, function(skin, jobSkin)

			local data = {
				job       = xPlayer.job,
				inventory = xPlayer.inventory,
				skin      = skin
			}

			TriggerClientEvent('esx_minerjob:responsePlayerData', source, data, reason)
		end)
	end)
end)

local function HarvestStone(source)

	SetTimeout(3000, function()

		if PlayersHarvestingStone[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local StoneQuantity = xPlayer:getInventoryItem('stone').count

				if StoneQuantity >= 32 then
					TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez plus rammasser de pierre')
				else
					
					xPlayer:addInventoryItem('stone', 1)
					HarvestStone(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_minerjob:startHarvestStone')
AddEventHandler('esx_minerjob:startHarvestStone', function()
	PlayersHarvestingStone[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Ramassage en cours...')
	HarvestStone(source)
end)

RegisterServerEvent('esx_minerjob:stopHarvestStone')
AddEventHandler('esx_minerjob:stopHarvestStone', function()
	PlayersHarvestingStone[source] = false
end)

local function WashStone(source)

	SetTimeout(5000, function()

		if PlayersWashingStone[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local StoneQuantity = xPlayer:getInventoryItem('stone').count

				if StoneQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de pierre a lavée')
				else
					
					xPlayer:removeInventoryItem('stone', 1)
					xPlayer:addInventoryItem('washed_stone', 1)

					WashStone(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_minerjob:startWashStone')
AddEventHandler('esx_minerjob:startWashStone', function()
	PlayersWashingStone[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Lavage en cours...')
	WashStone(source)
end)

RegisterServerEvent('esx_minerjob:stopWashStone')
AddEventHandler('esx_minerjob:stopWashStone', function()
	PlayersWashingStone[source] = false
end)

local function FounderingStone(source)

	SetTimeout(4000, function()

		if PlayersFoundringStone[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local WashedStoneQuantity = xPlayer:getInventoryItem('washed_stone').count
				local CooperQuantity      = xPlayer:getInventoryItem('copper').count
				local IronQuantity        = xPlayer:getInventoryItem('iron').count
				local GoldQuantity        = xPlayer:getInventoryItem('gold').count
				local DiamondQuantity     = xPlayer:getInventoryItem('diamond').count

				if WashedStoneQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de pierre a fondre')
				elseif CooperQuantity >= 50 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de place')
				elseif IronQuantity >= 50 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de place')
                elseif GoldQuantity >= 50 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de place')
                elseif DiamondQuantity >= 50 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de place')					
				else
					
					xPlayer:removeInventoryItem('washed_stone', 1)
					xPlayer:addInventoryItem('copper', 8)
					xPlayer:addInventoryItem('iron', 6)
					xPlayer:addInventoryItem('gold', 3)
					xPlayer:addInventoryItem('diamond', 1)
					
					FounderingStone(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_minerjob:startFounderingStone')
AddEventHandler('esx_minerjob:startFounderingStone', function()
	PlayersFoundringStone[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Fonte en cours...')
	FounderingStone(source)
end)

RegisterServerEvent('esx_minerjob:stopFounderingStone')
AddEventHandler('esx_minerjob:stopFounderingStone', function()
	PlayersFoundringStone[source] = false
end)

local function CopperResell(source)

	SetTimeout(500, function()

		if PlayersCopperReselling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local CopperQuantity = xPlayer:getInventoryItem('copper').count

				if CopperQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de cuivre à vendre')
				else
					
					xPlayer:removeInventoryItem('copper', 1)
					xPlayer:addMoney(15)
					
					CopperResell(source)
				end

			end)

		end
	end)
end

local function IronResell(source)

	SetTimeout(500, function()

		if PlayersIronReselling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local IronQuantity = xPlayer:getInventoryItem('iron').count

				if IronQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de Fer à vendre')
				else
					
					xPlayer:removeInventoryItem('iron', 1)
					xPlayer:addMoney(25)
					
					IronResell(source)
				end

			end)

		end
	end)
end

local function GoldResell(source)

	SetTimeout(500, function()

		if PlayersGoldReselling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local GoldQuantity = xPlayer:getInventoryItem('gold').count

				if GoldQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus d\'or à vendre')
				else
					
					xPlayer:removeInventoryItem('gold', 1)
					xPlayer:addMoney(45)
					
					GoldResell(source)
				end

			end)

		end
	end)
end

local function DiamondResell(source)

	SetTimeout(500, function()

		if PlayersDiamondReselling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local DiamondQuantity = xPlayer:getInventoryItem('diamond').count

				if DiamondQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de Diamant à vendre')
				else
					
					xPlayer:removeInventoryItem('diamond', 1)
					xPlayer:addMoney(100)
					
					DiamondResell(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_minerjob:startCopperResell')
AddEventHandler('esx_minerjob:startCopperResell', function()
	PlayersCopperReselling[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours...')
	CopperResell(source)
end)

RegisterServerEvent('esx_minerjob:stopCopperResell')
AddEventHandler('esx_minerjob:stopCopperResell', function()
	PlayersCopperReselling[source] = false
end)

RegisterServerEvent('esx_minerjob:startIronResell')
AddEventHandler('esx_minerjob:startIronResell', function()
	PlayersIronReselling[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours...')
	IronResell(source)
end)

RegisterServerEvent('esx_minerjob:stopIronResell')
AddEventHandler('esx_minerjob:stopIronResell', function()
	PlayersIronReselling[source] = false
end)

RegisterServerEvent('esx_minerjob:startGoldResell')
AddEventHandler('esx_minerjob:startGoldResell', function()
	PlayersGoldReselling[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours...')
	GoldResell(source)
end)

RegisterServerEvent('esx_minerjob:stopGoldResell')
AddEventHandler('esx_minerjob:stopGoldResell', function()
	PlayersGoldReselling[source] = false
end)

RegisterServerEvent('esx_minerjob:startDiamondResell')
AddEventHandler('esx_minerjob:startDiamondResell', function()
	PlayersDiamondReselling[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours...')
	DiamondResell(source)
end)

RegisterServerEvent('esx_minerjob:stopDiamondResell')
AddEventHandler('esx_minerjob:stopDiamondResell', function()
	PlayersDiamondReselling[source] = false
end)
