function Init(abilityData)
	plugin.registerEvent(abilityData, "EX018-deathNote", "SignChangeEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX018-deathNote" then deathNote(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX018-isUsed") == nil then 
		player:setVariable("EX018-isUsed", false)
		player:setVariable("EX018-count", 0)
	end
	
	local count = player:getVariable("EX018-count")
	local targetPlayer = player:getVariable("EX018-targetPlayer")
	if count > 0 and targetPlayer then
		count = count - 1
		if count == 0 then killPlayer(player) 
		elseif not game.targetPlayer(player, targetPlayer, false, false) then
			game.sendMessage(player:getPlayer(), "§8[§7데스노트§8] §7발동 이전에 대상이 사망하여 능력이 취소됩니다.")
			game.sendMessage(player:getPlayer(), "§8[§7데스노트§8] §7능력을 다시 사용할 수 있습니다.")
			player:setVariable("EX018-isUsed", false)
			player:setVariable("EX018-isUsed", false)
			player:setVariable("EX018-count", 0)
			game.sendActionBarMessageToAll("EX018", "")
			return 0
		end
		
		game.sendActionBarMessage(player:getPlayer(), "EX018", "§7타겟 : §8" .. targetPlayer:getPlayer():getName() .. " (발동까지 " .. tostring(math.floor(count / 20 + 0.5)) .. "초)")
		game.sendActionBarMessage(targetPlayer:getPlayer(), "EX018", "§7데스노트 : §8" .. player:getPlayer():getName() .. " (발동까지 " .. tostring(math.floor(count / 20 + 0.5)) .. "초)")
	end
	
	player:setVariable("EX018-count", count)
end

function Reset(player, ability)
	game.sendActionBarMessageToAll("EX018", "")
end

function deathNote(LAPlayer, event, ability, id)
	if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
		local playerName = event:getLine(0)
		local players = util.getTableFromList(game.getTeamManager():getOpponentTeam(LAPlayer, false))
		
		if event:getPlayer():getName() == playerName then
			game.sendMessage(event:getPlayer(), "§8[§7데스노트§8] §7자신의 이름을 적을 수 없습니다.")
			return 0
		end
		for i = 1, #players do
			if players[i]:getPlayer():getName() == playerName then
				if game.targetPlayer(LAPlayer, players[i]) then
					local targetPlayer = players[i]
					
					LAPlayer:setVariable("EX018-targetPlayer", targetPlayer)
					LAPlayer:setVariable("EX018-count", 1200)
					LAPlayer:setVariable("EX018-isUsed", true)
					
					game.sendMessage(event:getPlayer(), "§8[§7데스노트§8] " .. targetPlayer:getPlayer():getName() .. "§7님은 60초 후 사망합니다.")
					game.sendMessage(event:getPlayer(), "§8[§7데스노트§8] §7만약 당신이 60초 이내에 탈락할 경우, 해당 플레이어는 사망하지 않습니다.")
					
					game.sendMessage(targetPlayer:getPlayer(), "§8[§7데스노트§8] §7당신은 60초 후 데스노트에 의해 사망합니다.")
					return 0 
				else
					return 0 
				end
			end
		end
		game.sendMessage(event:getPlayer(), "§8[§7데스노트§8] §7해당 플레이어는 타겟팅 할 수 없습니다.")
	end
end

function killPlayer(player)
	local targetPlayer = player:getVariable("EX018-targetPlayer")
	if targetPlayer:hasAbility("LA-EX-007") then 
		game.sendMessage(player:getPlayer(), "§c미러링 능력에 의해 즉사합니다.")
		game.sendMessage(targetPlayer:getPlayer(), "§4[§c미러링§4] §c능력이 발동되어 능력이 제거됩니다.")
		
		game.removeAbilityAsID(players[i], "LA-EX-007", false)
		targetPlayer = player 
	end
	
	targetPlayer:getPlayer():setHealth(0)
	targetPlayer:getPlayer():getWorld():strikeLightningEffect(targetPlayer:getPlayer():getLocation())
	targetPlayer:getPlayer():getWorld():spawnParticle(import("$.Particle").EXPLOSION_HUGE, targetPlayer:getPlayer():getLocation():add(0,1,0), 1, 4, 1, 4, 0.05)
	targetPlayer:getPlayer():getWorld():createExplosion(targetPlayer:getPlayer():getLocation(), 2.5)
	
	game.sendMessage(targetPlayer:getPlayer(), "§8데스노트 §7능력으로 인해 즉사합니다.")
	game.sendMessage(player:getPlayer(), "§8[§7데스노트§8] §7능력이 발동되어 능력이 제거됩니다.")
	game.removeAbilityAsID(player, "LA-EX-018", false)

	player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
	player:getPlayer():getWorld():playSound(player:getPlayer():getLocation(), import("$.Sound").ENTITY_WITHER_AMBIENT, 0.5, 1.0)
end