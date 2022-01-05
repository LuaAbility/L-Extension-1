function main(abilityData)
	plugin.addPassiveScript(abilityData, 200, function(p) shuffle() end)
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
		players[i]:changeAbility(abilities[i])
	end
	
	game.broadcastMessage("§2셔플 §a능력에 의해 모든 플레이어의 능력이 섞입니다!")
end