function main(abilityData)
	local stop = 0
	
	plugin.registerEvent(abilityData, "PlayerInteractEvent", 1600, function(a, e)
		if e:getAction():toString() == "RIGHT_CLICK_AIR" or e:getAction():toString() == "RIGHT_CLICK_BLOCK" then
			if e:getItem() ~= nil then
				if game.isAbilityItem(e:getItem(), "IRON_INGOT") then
					if game.checkCooldown(e:getPlayer(), abilityData, 0) then
						stop = 300


						local players = util.getTableFromList(game.getPlayers())
						
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5, newInstance("$.Particle$DustOptions", {import("$.Color").AQUA, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.1)
						e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").BLOCK_BELL_USE, 2, 1)
						game.getPlayer(e:getPlayer()):setVariable("EX014-stop", "true")
						
						for i = 1, #players do
							if players[i]:getVariable("EX014-stop") ~= "true" then
								game.sendMessage(players[i]:getPlayer(), "§4시간 정지 §c능력에 의해 이동, 능력이 봉인됩니다.")
								players[i]:setVariable("abilityLock", "true")
								players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").BLOCK_BELL_RESONATE, 2, 1)
								players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, players[i]:getPlayer():getLocation():add(0,1,0), 500, 0.1, 0.1, 0.1, 1)
							end
						end
						
						util.runLater(function() 
							game.sendMessage(e:getPlayer(), "§2[§a시간 정지§2] §a능력 시전 시간이 종료되었습니다.") 
							game.getPlayer(e:getPlayer()):setVariable("EX014-stop", "false")
						end, 301)
					end
				end
			end
		end
	end)
	
	plugin.addPassiveScript(abilityData, 1, function(p)
		if stop > 0 then
			local players = util.getTableFromList(game.getPlayers())

			for i = 1, #players do
				if players[i]:getVariable("EX014-stop") ~= "true" then
					players[i]:getPlayer():setVelocity(newInstance("$.util.Vector", {0, 0, 0}))
				end
			end
			
			stop = stop - 1
			if stop == 0 then
				for i = 1, #players do
					if players[i]:getVariable("EX014-stop") ~= "true" then
						players[i]:removeVariable("abilityLock")
						players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").BLOCK_GLASS_BREAK, 2, 1.2)
						players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").BLOCK_BELL_USE, 1, 1)
						players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").ITEM_CRACK, players[i]:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05, newInstance("$.inventory.ItemStack", {import("$.Material").GLASS}))
						players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").REVERSE_PORTAL, players[i]:getPlayer():getLocation():add(0,1,0), 500, 0.1, 0.1, 0.1, 1)
					end
				end
			end
		end
	end)
	
	plugin.registerEvent(abilityData, "PlayerMoveEvent", 0, function(a, e)
		if stop > 0 then
			if game.getPlayer(e:getPlayer()):getVariable("EX014-stop") ~= "true" then
				e:setCancelled(true)
				game.sendMessage(e:getPlayer(), "§4시간 정지 §c능력에 의해 이동하실 수 없습니다. (남은 시간 : " .. stop / 20.0 .. "s)")
			end
		end
	end)
end