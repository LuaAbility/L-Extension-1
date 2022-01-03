function main(abilityData)
	plugin.registerEvent(abilityData, "PlayerInteractEvent", 12000, function(a, e)
		if e:getAction():toString() == "RIGHT_CLICK_AIR" or e:getAction():toString() == "RIGHT_CLICK_BLOCK" then
			if e:getItem() ~= nil then
				if game.isAbilityItem(e:getItem(), "IRON_INGOT") then
					if game.checkCooldown(e:getPlayer(), abilityData, 0) then
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").ORANGE, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").YELLOW, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").GREEN, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").BLUE, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").PURPLE, 1}))
						e:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
						e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").BLOCK_PORTAL_TRAVEL, 2, 1)
						snap() 
					end
				end
			end
		end
	end)
	
	plugin.addPassiveScript(abilityData, 0, function(p)
		game.checkCooldown(p, abilityData, 0, false)
	end)
end

function snap()
	local players = util.getTableFromList(game.getPlayers())
	for i = 1, 100 do
		local randomIndex = math.random(1, #players)
		local temp = players[randomIndex]
		players[randomIndex] = players[1]
		players[1] = temp
	end
	
	for j = 1, (#players / 2) do
		players[j]:getPlayer():damage(9999999)
		game.sendMessage(players[j]:getPlayer(), "§c핑거스냅 능력으로 인해 치명적인 데미지를 입습니다.")
		players[j]:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, players[j]:getPlayer():getLocation():add(0,1,0), 1000, 0.5, 1, 0.5, 0.75)
		players[j]:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, players[j]:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
		players[j]:getPlayer():playSound(players[j]:getPlayer():getLocation(), import("$.Sound").BLOCK_PORTAL_TRAVEL, 0.1, 1)
	end
end