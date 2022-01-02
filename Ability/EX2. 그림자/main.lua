function main(abilityData)
	plugin.registerEvent(abilityData, "PlayerInteractEvent", 1200, function(a, e)
		if e:getAction():toString() == "RIGHT_CLICK_AIR" or e:getAction():toString() == "RIGHT_CLICK_BLOCK" then
			if e:getItem() ~= nil then
				if game.isAbilityItem(e:getItem(), "IRON_INGOT") then
					if game.checkCooldown(e:getPlayer(), a, 0) then
						game.getPlayer(e:getPlayer()):setVariable("EX002-isInvisible", "true")
						e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1.2)
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5)
						
						local players = util.getTableFromList(game.getAllPlayers())
						for i = 1, #players do
							if players[i]:getPlayer():getName() ~= e:getPlayer():getName() then
								players[i]:getPlayer():hidePlayer(plugin.getPlugin(), e:getPlayer())
							end
						end
						
						util.runLater(function()
							game.sendMessage(e:getPlayer(), "§1[§b그림자§1] §b능력 시전 시간이 종료되었습니다.")	
							game.getPlayer(e:getPlayer()):setVariable("EX002-isInvisible", "false")
							e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1.2)
							e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
							e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5)
							
							local players = util.getTableFromList(game.getAllPlayers())
							for i = 1, #players do
								if players[i]:getPlayer():getName() ~= e:getPlayer():getName() then
									players[i]:getPlayer():showPlayer(plugin.getPlugin(), e:getPlayer())
								end
							end
						end, 200)
					end
				end
			end
		end
	end)
	
	plugin.onPlayerEnd(abilityData, function(p)
		local players = util.getTableFromList(game.getAllPlayers())
		for i = 1, #players do
			if players[i]:getPlayer():getName() ~= p:getPlayer():getName() then
				players[i]:getPlayer():showPlayer(plugin.getPlugin(), p:getPlayer())
			end
		end
	end)
	
	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 0, function(a, e)
		local damager = e:getDamager()
		if e:getCause():toString() == "PROJECTILE" then damager = e:getDamager():getShooter() end
			
		if damager:getType():toString() == "PLAYER" and game.getPlayer(damager):getVariable("EX002-isInvisible") == "true" then
			if game.checkCooldown(damager, a, 1) then
				e:setCancelled(true)
			end
		end
		
		if e:getEntity():getType():toString() == "PLAYER" and game.getPlayer(e:getEntity()):getVariable("EX002-isInvisible") == "true" then
			if game.checkCooldown(e:getEntity(), a, 1) then
				e:setCancelled(true)
			end
		end
	end)
end