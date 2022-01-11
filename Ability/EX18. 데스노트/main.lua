function Init(abilityData)
	plugin.registerEvent(abilityData, "EX018-deathNote", "SignChangeEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX018-deathNote" then deathNote(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function deathNote(LAPlayer, event, ability, id)
	if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
		local playerName = event:getLine(0)
		local players = util.getTableFromList(game.getPlayers())
		for i = 1, #players do
			if players[i]:getPlayer():getName() == playerName then
				local targetPlayer = players[i]:getPlayer()
				if players[i]:hasAbility("LA-EX-007") then 
					game.sendMessage(event:getPlayer(), "§c미러링 능력에 의해 즉사합니다.")
					game.sendMessage(players[i]:getPlayer(), "§4[§c미러링§4] §c능력이 발동되어 능력이 제거됩니다.")
					
					util.runLater(function() game.removeAbilityAsID(players[i], "LA-EX-007") end, 1)
					targetPlayer = event:getPlayer() 
				end
				
				targetPlayer:setHealth(0)
				targetPlayer:getWorld():strikeLightningEffect(targetPlayer:getLocation())
				targetPlayer:getWorld():spawnParticle(import("$.Particle").EXPLOSION_HUGE, targetPlayer:getLocation():add(0,1,0), 1, 4, 1, 4, 0.05)
				targetPlayer:getWorld():createExplosion(targetPlayer:getLocation(), 5)
				
				game.sendMessage(targetPlayer, "§8데스노트 §7능력으로 인해 즉사합니다.")
				game.sendMessage(event:getPlayer(), "§8[§7데스노트§8] §7능력이 발동되어 능력이 제거됩니다.")
				util.runLater(function() game.removeAbilityAsID(game.getPlayer(event:getPlayer()), "LA-EX-018") end, 1)
				event:setLine(0, "[Death Certificate]")
				event:setLine(1, playerName)
				event:setLine(2, "Cause: Explosion")
				
				event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
				event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").ENTITY_WITHER_AMBIENT, 0.5, 1.0)
				return 0 
			end
		end
		game.sendMessage(event:getPlayer(), "§8[§7데스노트§8] §7해당 플레이어가 존재하지 않거나 탈락한 상태입니다.")
	end
end