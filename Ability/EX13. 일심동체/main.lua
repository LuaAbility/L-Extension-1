function main(abilityData)
	plugin.addPassiveScript(abilityData, 0, function(p)
		local players = util.getTableFromList(game.getPlayers())
		local playerIndex = 1
		local playerName = p:getName()
		
		while p:getName() == playerName do 
			
			playerIndex = math.random(1, #players)
			playerName = players[playerIndex]:getPlayer():getName() 
		end
		
		game.getPlayer(p):setVariable("EX013-friend", playerName)
		game.broadcastMessage("§2[§a일심동체§2] " .. playerName .. "§a님이 사망 시 §2" .. p:getName() .. "§a님이 동반 사망합니다.")
		game.broadcastMessage("§2[§a일심동체§2] " .. p:getName() .. "§a님은 사망 전 까지 모든 데미지를 받지 않습니다.")
	end)
	
	plugin.addPassiveScript(abilityData, 1, function(p)
		local friend = game.getPlayer(p):getVariable("EX013-friend")
		game.sendActionBarMessage(p, "§e일심동체 §7: §6" .. friend)
	end)
	
	plugin.registerEvent(abilityData, "PlayerDeathEvent", 0, function(a, e)
		if e:getEntity():getType():toString() == "PLAYER" then
			local players = util.getTableFromList(game.getPlayers())
			local player = { }
			for i = 1, #players do
				if players[i]:hasAbility("LA-EX-013") then table.insert(player, players[i]) end
			end
			
			if #player > 0 then
				for i = 1, #player do
					if player[i]:getVariable("EX013-friend") == e:getEntity():getName() then
						if game.checkCooldown(player[i]:getPlayer(), a, 0) then
							game.sendMessage(player[i]:getPlayer(), "§4[§c일심동체§4] " .. e:getEntity():getName() .. "§c님이 사망하여 같이 사망합니다.")
							player[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, player[i]:getPlayer():getLocation():add(0,1,0), 1000, 0.5, 1, 0.5, 0.75)
							player[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player[i]:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
							player[i]:getPlayer():playSound(player[i]:getPlayer():getLocation(), import("$.Sound").ENTITY_WITHER_DEATH, 2, 0.7)
							player[i]:getPlayer():setHealth(0)
						end
					end
				end
			end
		end
	end)
	
	plugin.registerEvent(abilityData, "EntityDamageEvent", 0, function(a, e)
		if e:getEntity():getType():toString() == "PLAYER" then
			if game.checkCooldown(e:getEntity(), a, 0) then
				e:setCancelled(true)
			end
		end
	end)
end