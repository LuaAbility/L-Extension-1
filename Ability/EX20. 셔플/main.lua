function Init(abilityData) 
	plugin.registerEvent(abilityData, "능력 셔플", "PlayerInteractEvent", 300)
end

function onEvent(funcTable)
	if funcTable[1] == "능력 셔플" then abilityUse(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function abilityUse(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					shuffle(LAPlayer)
				end
			end
		end
	end
end

function shuffle(lap) 
	local players = util.getTableFromList(game.getPlayers())
	local abilities = { }
	
	for i = 1, #players do
		if game.targetPlayer(lap, players[i], false, true) then
			table.insert(abilities, players[i]:getAbility():clone())
		end
	end
	
	for i = 1, 100 do
		local randomIndex = util.random(1, #abilities)
		local temp = abilities[randomIndex]
		abilities[randomIndex] = abilities[1]
		abilities[1] = temp
	end
	
	local j = 1
	for i = 1, #players do
		if game.targetPlayer(lap, players[i], false, true) then
			util.runLater(function() players[i]:changeAbility(abilities[j]) j = j + 1 end, 1)
		end
	end
	
	game.broadcastMessage("§2셔플 §a능력에 의해 모든 플레이어의 능력이 섞입니다!")
end