function Init(abilityData) end

function onTimer(player, ability) 
	if player:getVariable("EX020-passiveCount") == nil then 
		player:setVariable("EX020-passiveCount", 0) 
		player:setVariable("EX020-randomPassive", math.random(600, 1200)) 
	end
	local count = player:getVariable("EX020-passiveCount")
	local maxCount = player:getVariable("EX020-randomPassive")
	if count >= maxCount then 
		count = 0
		shuffle()
		player:setVariable("EX020-randomPassive", math.random(600, 1200)) 
	end
	count = count + 2
	player:setVariable("EX020-passiveCount", count)
end

function shuffle() 
	local players = util.getTableFromList(game.getPlayers())
	local abilities = { }
	
	for i = 1, #players do
		table.insert(abilities, players[i]:getAbility():clone())
	end
	
	
	for i = 1, 100 do
		local randomIndex = math.random(1, #abilities)
		local temp = abilities[randomIndex]
		abilities[randomIndex] = abilities[1]
		abilities[1] = temp
	end
	
	for i = 1, #players do
		util.runLater(function() players[i]:changeAbility(abilities[i]) end, 3)
	end
	
	game.broadcastMessage("§2셔플 §a능력에 의해 모든 플레이어의 능력이 섞입니다!")
end