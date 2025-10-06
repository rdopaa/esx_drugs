local spawnedMeth = 0
local methPlants = {}
local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	repeat
		Wait(1000)
	until Config.CircleZones ~= nil
	while true do
		Citizen.Wait(500)
		local coords = GetEntityCoords(PlayerPedId())
		local dist = #(coords - Config.CircleZones.MethField.coords)

		if dist < 50 then
			SpawnMethPlants()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #methPlants, 1 do
			if #(coords - GetEntityCoords(methPlants[i])) < 1 then
				nearbyObject, nearbyID = methPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			if not isPickingUp then
				ESX.ShowHelpNotification(_U('meth_pickupprompt'))
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)
					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(methPlants, nearbyID)
						spawnedMeth = spawnedMeth - 1
		
						TriggerServerEvent('esx_drugs:pickedUpMeth')
					else
						ESX.ShowNotification(_U('meth_inventoryfull'))
					end

					isPickingUp = false
				end, 'meth_raw')
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
		local dist = #(coords - Config.CircleZones.MethProcessing.coords)

		if dist < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('meth_processprompt'))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessMeth()
						else
							OpenBuyLicenseMenu('meth_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'meth_processing')
				else
					ProcessMeth()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessMeth()
	isProcessing = true
	ESX.ShowNotification(_U('meth_processingstarted'))
	TriggerServerEvent('esx_drugs:processMeth')
	local timeLeft = Config.Delays.MethProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1
		if #(GetEntityCoords(playerPed) - Config.CircleZones.MethProcessing.coords) > 4 then
			ESX.ShowNotification(_U('meth_processingtoofar'))
			TriggerServerEvent('esx_drugs:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

function SpawnMethPlants()
	while spawnedMeth < 15 do
		Citizen.Wait(0)
		local methCoords = GenerateMethCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_01a', methCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(methPlants, obj)
			spawnedMeth = spawnedMeth + 1
		end)
	end
end

function ValidateMethCoord(plantCoord)
	if spawnedMeth > 0 then
		local validate = true

		for k, v in pairs(methPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		return validate
	else
		return true
	end
end

function GenerateMethCoords()
	while true do
		Citizen.Wait(1)

		local methCoordX, methCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		methCoordX = Config.CircleZones.MethField.coords.x + modX
		methCoordY = Config.CircleZones.MethField.coords.y + modY

		local coordZ = GetCoordZMeth(methCoordX, methCoordY)
		local coord = vector3(methCoordX, methCoordY, coordZ)

		if ValidateMethCoord(coord) then
			return coord
		end
	end
end

function GetCoordZMeth(x, y)
	local groundCheckHeights = { 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end
