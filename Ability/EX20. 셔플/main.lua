function Init(abilityData) 
	plugin.registerEvent(abilityData, "능력 셔플", "PlayerInteractEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "능력 셔플" then abilityUse(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability) 
	local count = player:getVariable("EX020-abilityTime")
	if count == nil then 
		player:setVariable("EX020-abilityTime", 6000)
		count = 6000
	end
	
	if count > 0 then
		count = count - 1
		
		if count == 0 then
            game.sendMessage(player:getPlayer(), "§1[§b셔플§1] §b재사용 대기시간이 종료되었습니다. (능력 셔플)")
            player:getPlayer():playSound(player:getPlayer(), import("$.Sound").ENTITY_PLAYER_LEVELUP, 0.5, 2)
        elseif count == 20 then
			game.sendMessage(player:getPlayer(), "§1[§b셔플§1] §b남은 시간 : 1초 (능력 셔플)")
			player:getPlayer():playSound(player:getPlayer(), import("$.Sound").ENTITY_EXPERIENCE_ORB_PICKUP, 0.5, 2)
        elseif count == 40 then
			game.sendMessage(player:getPlayer(), "§1[§b셔플§1] §b남은 시간 : 2초 (능력 셔플)")
			player:getPlayer():playSound(player:getPlayer(), import("$.Sound").ENTITY_EXPERIENCE_ORB_PICKUP, 0.5, 2)
        elseif count == 60 then
			game.sendMessage(player:getPlayer(), "§1[§b셔플§1] §b남은 시간 : 3초 (능력 셔플)");
			player:getPlayer():playSound(player:getPlayer(), import("$.Sound").ENTITY_EXPERIENCE_ORB_PICKUP, 0.5, 2)
        elseif count == 80 then
			game.sendMessage(player:getPlayer(), "§1[§b셔플§1] §b남은 시간 : 4초 (능력 셔플)")
			player:getPlayer():playSound(player:getPlayer(), import("$.Sound").ENTITY_EXPERIENCE_ORB_PICKUP, 0.5, 2)
        elseif count == 100 then
			game.sendMessage(player:getPlayer(), "§1[§b셔플§1] §b남은 시간 : 5초 (능력 셔플)")
			player:getPlayer():playSound(player:getPlayer(), import("$.Sound").ENTITY_EXPERIENCE_ORB_PICKUP, 0.5, 2)
		end
        
		player:setVariable("EX020-abilityTime", count)
	end
end

function abilityUse(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					local count = LAPlayer:getVariable("EX020-abilityTime")
					if count then
						if count <= 0 then
							LAPlayer:setVariable("EX020-abilityTime", 6000)
							shuffle(LAPlayer)
						else
							game.sendMessage(event:getPlayer(), "§1[§b셔플§1] §b재사용 대기시간 입니다. (" .. (count / 20) .. "초 / 능력 셔플)" )
						end
					end
				end
			end
		end
	end
end

function shuffle(lap) 
	local players = util.getTableFromList(game.getPlayers())
	local abilities = { }
	
	for i = 1, #players do
		if game.targetPlayer(lap, players[i], false) then
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
		if game.targetPlayer(lap, players[i], false) then
			util.runLater(function() players[i]:changeAbility(abilities[j]) j = j + 1 end, 1)
		end
	end
	
	game.broadcastMessage("§2셔플 §a능력에 의해 모든 플레이어의 능력이 섞입니다!")
end