ESX = exports['es_extended']:getSharedObject()
local playersProcessingCannabis = {}
local playersProcessingMeth = {}
local playersProcessingHeroin = {}

function ensureLegitness(xPlayer, drug, stage)
	local xPlayer, drug, stage = xPlayer, drug, stage;
	local legit = {["legit"] = true, ["reason"] = "No flags found."}
	if xPlayer ~= nil then
		local pCoord = xPlayer.getCoords();
		if pCoord ~= nil then
			if drug ~= nil then
				if stage ~= nil then
					if drug == "weed" then
						if stage == "collect" then
							local dCoord = Config.CircleZones.WeedField;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						elseif stage == "process" then
							local dCoord = Config.CircleZones.WeedProcessing;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						elseif stage == "sell" then
							local dCoord = Config.CircleZones.DrugDealer;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
					elseif drug == "meth" then
						if stage == "collect" then
							local dCoord = Config.CircleZones.MethField;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						elseif stage == "process" then
							local dCoord = Config.CircleZones.MethProcessing;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						elseif stage == "sell" then
							local dCoord = Config.CircleZones.DrugDealer;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
					elseif drug == "heroin" then
						if stage == "collect" then
							local dCoord = Config.CircleZones.HeroinField;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						elseif stage == "process" then
							local dCoord = Config.CircleZones.HeroinProcessing;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						elseif stage == "sell" then
							local dCoord = Config.CircleZones.DrugDealer;
							local distance = #(pCoord - dCoord.coords);
							if distance < dCoord.radius * 1.1 then
								return legit
							else
								legit = {["legit"] = false, ["reason"] = "Player was out of the radius."}
								return legit
							end
						else
							legit = {["legit"] = false, ["reason"] = "The drug stage could not be matched."}
							return legit
						end
					else
						legit = {["legit"] = false, ["reason"] = "The drug type could not be matched."}
						return legit
					end
				else
					legit = {["legit"] = false, ["reason"] = "The drug stage was not supplied."}
					return legit
				end
			else
				legit = {["legit"] = false, ["reason"] = "The drug type was not supplied."}
				return legit
			end
		else
			legit = {["legit"] = false, ["reason"] = "Player coords were nil."}
			return legit
		end
	else
		legit = {["legit"] = false, ["reason"] = "xPlayer was nil."}
		return legit
	end
end


RegisterServerEvent('esx_drugs:processMeth')
AddEventHandler('esx_drugs:processMeth', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if playersProcessingMeth[src] then
		return
	end

	local xMeth = xPlayer.getInventoryItem('meth_raw')
	local legit = ensureLegitness(xPlayer, "meth", "process");
	if legit["legit"] == true then
		if xMeth.count >= 3 then
			playersProcessingMeth[src] = ESX.SetTimeout(Config.Delays.MethProcessing, function()
				if xMeth.count >= 3 then
					if xPlayer.canSwapItem('meth_raw', 3, 'meth', 1) then
						xPlayer.removeInventoryItem('meth_raw', 3)
						xPlayer.addInventoryItem('meth', 1)
						xPlayer.showNotification(_U('meth_processed'))
					else
						xPlayer.showNotification(_U('meth_processingfull'))
					end
				else
					xPlayer.showNotification(_U('meth_processingenough'))
				end
				playersProcessingMeth[src] = nil
			end)
		else
			xPlayer.showNotification(_U('meth_processingenough'))
		end
	end
end)

RegisterServerEvent('esx_drugs:processHeroin')
AddEventHandler('esx_drugs:processHeroin', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if playersProcessingHeroin[src] then
		return
	end

	local xHeroin = xPlayer.getInventoryItem('heroin_raw')
	local legit = ensureLegitness(xPlayer, "heroin", "process");
	if legit["legit"] == true then
		if xHeroin.count >= 3 then
			playersProcessingHeroin[src] = ESX.SetTimeout(Config.Delays.HeroinProcessing, function()
				if xHeroin.count >= 3 then
					if xPlayer.canSwapItem('heroin_raw', 3, 'heroin', 1) then
						xPlayer.removeInventoryItem('heroin_raw', 3)
						xPlayer.addInventoryItem('heroin', 1)
						xPlayer.showNotification(_U('heroin_processed'))
					else
						xPlayer.showNotification(_U('heroin_processingfull'))
					end
				else
					xPlayer.showNotification(_U('heroin_processingenough'))
				end
				playersProcessingHeroin[src] = nil
			end)
		else
			xPlayer.showNotification(_U('heroin_processingenough'))
		end
	end
end)

RegisterServerEvent('esx_drugs:pickedUpMeth')
AddEventHandler('esx_drugs:pickedUpMeth', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local legit = ensureLegitness(xPlayer, "meth", "collect");
	if legit["legit"] == true then
		if xPlayer.canCarryItem('meth_raw', 1) then
			xPlayer.addInventoryItem('meth_raw', 1)
		else
			xPlayer.showNotification(_U('meth_inventoryfull'))
		end
	end
end)

RegisterServerEvent('esx_drugs:pickedUpHeroin')
AddEventHandler('esx_drugs:pickedUpHeroin', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local legit = ensureLegitness(xPlayer, "heroin", "collect");
	if legit["legit"] == true then
		if xPlayer.canCarryItem('heroin_raw', 1) then
			xPlayer.addInventoryItem('heroin_raw', 1)
		else
			xPlayer.showNotification(_U('heroin_inventoryfull'))
		end
	end
end)

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function(itemName, amount)
	local src = source;
	local xPlayer = ESX.GetPlayerFromId(src)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		xPlayer.showNotification(_U('dealer_notenough'))
		return
	end

	local drugType = nil;
	if itemName == "marijuana" then
		drugType = "weed";
	elseif itemName == "drug_meth" then
		drugType = "meth";
	elseif itemName == "heroin" then
		drugType = "heroin";
	end
	local legit = ensureLegitness(xPlayer, drugType, "sell");
	if legit["legit"] == true then
		price = ESX.Math.Round(price * amount)

		if Config.GiveBlack then
			xPlayer.addAccountMoney('black_money', price)
		else
			xPlayer.addMoney(price)
		end

		xPlayer.removeInventoryItem(xItem.name, amount)
		xPlayer.showNotification(_U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
	else
		print(
			string.format(
				"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to sell ^2%s^7 but the legitness check returned false because ^1%s^7.",
				GetCurrentResourceName(), src, GetPlayerName(src), drugType, legit["reason"]
			)
		)
	end
end)

ESX.RegisterServerCallback('esx_drugs:buyLicense', function(source, cb, licenseName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = Config.LicensePrices[licenseName]

	if license then
		if xPlayer.getMoney() >= license.price then
			xPlayer.removeMoney(license.price)

			TriggerEvent('esx_license:addLicense', source, licenseName, function()
				cb(true)
			end)
		else
			cb(false)
		end
	else
		print(('esx_drugs: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end
end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	local src = source;
	local xPlayer = ESX.GetPlayerFromId(src)

	local legit = ensureLegitness(xPlayer, "weed", "collect");
	if legit["legit"] == true then
		if xPlayer.canCarryItem('cannabis', 1) then
			xPlayer.addInventoryItem('cannabis', 1)
		else
			xPlayer.showNotification(_U('weed_inventoryfull'))
		end
	else
		print(
			string.format(
				"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to collect ^2weed^7 but the legitness check returned false because ^1%s^7.",
				GetCurrentResourceName(), src, GetPlayerName(src), legit["reason"]
			)
		)
	end
end)

ESX.RegisterServerCallback('esx_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	if not playersProcessingCannabis[source] then
		local _source = source

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis = xPlayer.getInventoryItem('cannabis')

			if xCannabis.count > 3 then
				if xPlayer.canSwapItem('cannabis', 3, 'marijuana', 1) then
					local legit = ensureLegitness(xPlayer, "weed", "process");
					if legit["legit"] == true then
						xPlayer.removeInventoryItem('cannabis', 3)
						xPlayer.addInventoryItem('marijuana', 1)
						xPlayer.showNotification(_U('weed_processed'))
					else
						print(
							string.format(
								"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to process ^2weed^7 but the legitness check returned false because ^1%s^7.",
								GetCurrentResourceName(), _source, GetPlayerName(_source), legit["reason"]
							)
						)
					end
				else
					xPlayer.showNotification(_U('weed_processingfull'))
				end
			else
				xPlayer.showNotification(_U('weed_processingenough'))
			end

			playersProcessingCannabis[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ESX.ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)


local calledUsers = {};
ESX.RegisterServerCallback('esx_drugs:getCoords', function(source, cb)
	if calledUsers[source] == nil then
		calledUsers[source] = true;
		cb(Config.CircleZones)
	end
end)