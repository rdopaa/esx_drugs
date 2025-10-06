local spawnedHeroin = 0
local heroinPlants = {}
local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	repeat
		Wait(1000)
	until Config.CircleZones ~= nil
	while true do
		Citizen.Wait(500)
		local coords = GetEntityCoords(PlayerPedId())
		local dist = #(coords - Config.CircleZones.HeroinField.coords)

		if dist < 50 then
			SpawnHeroinPlants()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #heroinPlants, 1 do
			if #(coords - GetEntityCoords(heroinPlants[i])) < 1 then
				nearbyObject, nearbyID = heroinPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			if not isPickingUp then
				ESX.ShowHelpNotification(_U('heroin_pickupprompt'))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)
					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(heroinPlants, nearbyID)
						spawnedHeroin = spawnedHeroin - 1
		
						TriggerServerEvent('esx_drugs:pickedUpHeroin')
					else
						ESX.ShowNotification(_U('heroin_inventoryfull'))
					end

					isPickingUp = false
				end, 'heroin_raw')
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	repeat
		Wait(1000)
	until Config.CircleZones ~= nil
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local dist = #(coords - Config.CircleZones.HeroinProcessing.coords)

		if dist < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('heroin_processprompt'))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessHeroin()
						else
							OpenBuyLicenseMenu('heroin_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'heroin_processing')
				else
					ProcessHeroin()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessHeroin()
	isProcessing = true
	ESX.ShowNotification(_U('heroin_processingstarted'))
	TriggerServerEvent('esx_drugs:processHeroin')
	local timeLeft = Config.Delays.HeroinProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1
		if #(GetEntityCoords(playerPed) - Config.CircleZones.HeroinProcessing.coords) > 4 then
			ESX.ShowNotification(_U('heroin_processingtoofar'))
			TriggerServerEvent('esx_drugs:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

function SpawnHeroinPlants()
	while spawnedHeroin < 15 do
		Citizen.Wait(0)
		local heroinCoords = GenerateHeroinCoords()

		ESX.Game.SpawnLocalObject('prop_plant_01a', heroinCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(heroinPlants, obj)
			spawnedHeroin = spawnedHeroin + 1
		end)
	end
end

function ValidateHeroinCoord(plantCoord)
	if spawnedHeroin > 0 then
		local validate = true

		for k, v in pairs(heroinPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		return validate
	else
		return true
	end
end

function GenerateHeroinCoords()
	while true do
		Citizen.Wait(1)

		local heroinCoordX, heroinCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		heroinCoordX = Config.CircleZones.HeroinField.coords.x + modX
		heroinCoordY = Config.CircleZones.HeroinField.coords.y + modY

		local coordZ = GetCoordZHeroin(heroinCoordX, heroinCoordY)
		local coord = vector3(heroinCoordX, heroinCoordY, coordZ)

		if ValidateHeroinCoord(coord) then
			return coord
		end
	end
end

function GetCoordZHeroin(x, y)
	local groundCheckHeights = { 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end
