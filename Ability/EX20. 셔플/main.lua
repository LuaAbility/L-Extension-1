function Init(abilityData) 
	plugin.registerEvent(abilityData, "EX020-abilityUse", "PlayerInteractEvent", 100)
end

function onEvent(funcTable)
	if funcTable[1] == "EX020-abilityUse" then abilityUse(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability) 
	if plugin.getPlugin().gameManager:getVariable("EX020-abilityCount") == nil then 
		plugin.getPlugin().gameManager:setVariable("EX020-abilityCount", 0)
	end
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
	local abilityCount = plugin.getPlugin().gameManager:getVariable("EX020-abilityCount")
	if abilityCount == nil then
		plugin.getPlugin().gameManager:setVariable("EX020-abilityCount", 0)
		abilityCount = 0
	elseif abilityCount >= 3 then
		plugin.getPlugin().gameManager:ResignAbility(lap)
		plugin.getPlugin().gameManager:AssignAbility(lap)
		return 0
	end
	
	local players = util.getTableFromList(game.getPlayers())
	local abilities = { }
	
	for i = 1, #players do
		table.insert(abilities, players[i]:getAbility():clone())
	end
	
	
	for i = 1, 100 do
		local randomIndex = util.random(1, #abilities)
		local temp = abilities[randomIndex]
		abilities[randomIndex] = abilities[1]
		abilities[1] = temp
	end
	
	for i = 1, #players do
		util.runLater(function() players[i]:changeAbility(abilities[i]) end, 3)
	end
	
	plugin.getPlugin().gameManager:setVariable("EX020-abilityCount", abilityCount + 1)
	game.broadcastMessage("§2셔플 §a능력에 의해 모든 플레이어의 능력이 섞입니다!")
end