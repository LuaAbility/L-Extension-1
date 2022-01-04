function main(abilityData)
	local stop = 0
	
	plugin.registerEvent(abilityData, "PlayerInteractEvent", 900, function(a, e)
		if e:getAction():toString() == "RIGHT_CLICK_AIR" or e:getAction():toString() == "RIGHT_CLICK_BLOCK" then
			if e:getPlayer():getInventory():getItemInMainHand() ~= nil then
				if game.isAbilityItem(e:getPlayer():getInventory():getItemInMainHand(), "IRON_INGOT") then
					local x = game.getPlayer(e:getPlayer()):getVariable("EX015-x")
					local y = game.getPlayer(e:getPlayer()):getVariable("EX015-y")
					local z = game.getPlayer(e:getPlayer()):getVariable("EX015-z")
					
					if x ~= "" and y ~= "" and z ~= "" then
						if game.checkCooldown(e:getPlayer(), abilityData, 0) then
							x = tonumber(x)
							y = tonumber(y)
							z = tonumber(z)
							
							e:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, e:getPlayer():getLocation():add(0,1,0), 1000, 0.1, 0.1, 0.1, 1)
							e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1)
							e:getPlayer():teleport(newInstance("$.Location", {e:getPlayer():getWorld(), x, y, z}))
							e:getPlayer():getWorld():spawnParticle(import("$.Particle").REVERSE_PORTAL, e:getPlayer():getLocation():add(0,1,0), 1000, 0.1, 0.1, 0.1, 1)
							e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1)
							
							game.checkCooldown(e:getPlayer(), abilityData, 1, false)
						end
					else 
						game.sendMessage(e:getPlayer(), "§4[§c트랜스볼§4] §c좌표가 저장되어 있지 않습니다.")
					end
				end
			end
		end
	end)
	
	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 900, function(a, e)
		if e:getDamager():getType():toString() == "PLAYER" and e:getEntity():getType():toString() == "PLAYER" then
			local item = e:getDamager():getInventory():getItemInMainHand()
			if game.isAbilityItem(item, "IRON_INGOT") then
				local x = game.getPlayer(e:getDamager()):getVariable("EX015-x")
				local y = game.getPlayer(e:getDamager()):getVariable("EX015-y")
				local z = game.getPlayer(e:getDamager()):getVariable("EX015-z")
				
				if x ~= "" and y ~= "" and z ~= "" then
					if game.checkCooldown(e:getDamager(), a, 1) then
						x = tonumber(x)
						y = tonumber(y)
						z = tonumber(z)
						
						e:getEntity():getWorld():spawnParticle(import("$.Particle").PORTAL, e:getEntity():getLocation():add(0,1,0), 1000, 0.1, 0.1, 0.1, 1)
						e:getEntity():getWorld():playSound(e:getEntity():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1)
						e:getEntity():teleport(newInstance("$.Location", {e:getDamager():getWorld(), x, y, z}))
						e:getEntity():getWorld():spawnParticle(import("$.Particle").REVERSE_PORTAL, e:getEntity():getLocation():add(0,1,0), 1000, 0.1, 0.1, 0.1, 1)
						e:getEntity():getWorld():playSound(e:getEntity():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1)
						game.sendMessage(e:getEntity(), "§2트랜스볼 §a능력의 영향으로 지정된 좌표로 이동합니다.")
						
						game.checkCooldown(e:getDamager(), abilityData, 0, false)
					end
				else 
					game.sendMessage(e:getDamager(), "§4[§c트랜스볼§4] §c좌표가 저장되어 있지 않습니다.")
				end
			end
		end
	end)
	
	plugin.registerEvent(abilityData, "PlayerSwapHandItemsEvent", 0, function(a, e)
		if e:getOffHandItem() ~= nil then
			if game.isAbilityItem(e:getOffHandItem(), "IRON_INGOT") then
				if game.checkCooldown(e:getPlayer(), abilityData, 2) then
					game.getPlayer(e:getPlayer()):setVariable("EX015-x", tostring(e:getPlayer():getLocation():getX()))
					game.getPlayer(e:getPlayer()):setVariable("EX015-y", tostring(e:getPlayer():getLocation():getY()))
					game.getPlayer(e:getPlayer()):setVariable("EX015-z", tostring(e:getPlayer():getLocation():getZ()))
					
					game.sendMessage(e:getPlayer(), "§2[§a트랜스볼§2] §a좌표를 저장했습니다.")
					e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.1)
					e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").BLOCK_BEACON_ACTIVATE, 0.5, 1)
				end
			end
		end
	end)
	
	plugin.addPassiveScript(abilityData, 5, function(p)
		local x = game.getPlayer(p):getVariable("EX015-x")
		local y = game.getPlayer(p):getVariable("EX015-y")
		local z = game.getPlayer(p):getVariable("EX015-z")
		
		if x ~= "" and y ~= "" and z ~= "" then
			game.sendActionBarMessage(p, "§aX §6: §b" .. x .. " §aY §6: §b" .. y .. " §aZ §6: §b" .. z)
			x = tonumber(x)
			y = tonumber(y)
			z = tonumber(z)
			local loc = newInstance("$.Location", {p:getWorld(), x, y + 1, z})
			
			p:getWorld():spawnParticle(import("$.Particle").REDSTONE, loc, 300, 0.2, 0.2, 0.2, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").LIME, 1}))
			p:getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, loc, 150, 0.2, 0.2, 0.2, 0.05)
		end
	end)
end