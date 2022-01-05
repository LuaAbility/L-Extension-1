function main(abilityData)
	plugin.registerEvent(abilityData, "SignChangeEvent", 0, function(a, e)
		if game.checkCooldown(e:getPlayer(), a, 0) then
			local playerName = e:getLine(0)
			local players = util.getTableFromList(game.getPlayers())
			for i = 1, #players do
				if players[i]:getPlayer():getName() == playerName then
					local targetPlayer = players[i]:getPlayer()
					if players[i]:hasAbility("LA-EX-007") then 
						game.sendMessage(e:getPlayer(), "§c미러링 능력에 의해 즉사합니다.")
						game.sendMessage(players[i]:getPlayer(), "§4[§c미러링§4] §c능력이 발동되어 능력이 제거됩니다.")
						
						local abilities = util.getTableFromList(players[i]:getAbility())
						for j = 1, #abilities do
							if abilities[j].abilityID == "LA-EX-007" then
								game.removeAbility(players[i]:getPlayer(), abilities[j], false)
							end
						end
						
						targetPlayer = e:getPlayer() 
					end
					
					targetPlayer:setHealth(0)
					targetPlayer:getWorld():strikeLightningEffect(targetPlayer:getLocation())
					targetPlayer:getWorld():spawnParticle(import("$.Particle").EXPLOSION_HUGE, targetPlayer:getLocation():add(0,1,0), 1, 4, 1, 4, 0.05)
					targetPlayer:getWorld():createExplosion(targetPlayer:getLocation(), 5)
					
					game.sendMessage(targetPlayer, "§8데스노트 §7능력으로 인해 즉사합니다.")
					game.sendMessage(e:getPlayer(), "§8[§7데스노트§8] §7능력이 발동되어 능력이 제거됩니다.")
					game.removeAbility(e:getPlayer(), a, false)
					e:setLine(0, "[Death Certificate]")
					e:setLine(1, playerName)
					e:setLine(2, "Cause: Explosion")
					
					e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
					e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ENTITY_WITHER_AMBIENT, 0.5, 1.0)
					return 0
				end
			end
			game.sendMessage(e:getPlayer(), "§8[§7데스노트§8] §7해당 플레이어가 존재하지 않거나 탈락한 상태입니다.")
		end
	end)
end