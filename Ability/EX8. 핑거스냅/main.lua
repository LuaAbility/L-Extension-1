function Init(abilityData)
	plugin.registerEvent(abilityData, "핑거스냅", "PlayerInteractEvent", 12000)
end

function onEvent(funcTable)
	if funcTable[1] == "핑거스냅" then half(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX008-cooldown") == nil then 
		player:setVariable("EX008-cooldown", 0) 
	end
end

function half(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").ORANGE, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").YELLOW, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").GREEN, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").BLUE, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").PURPLE, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
					event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").BLOCK_PORTAL_TRAVEL, 2, 1)
					snap(event:getPlayer()) 
				end
			end
		end
	end
end

function snap(caster)
	local players = util.getTableFromList(game.getPlayers())
	
	for i = 1, 100 do
		local randomIndex = util.random(1, #players)
		local temp = players[randomIndex]
		players[randomIndex] = players[1]
		players[1] = temp
	end
	
	for j = 1, (#players / 2) do
		if game.targetPlayer(game.getPlayer(caster), players[j], false) then
			game.sendMessage(players[j]:getPlayer(), "§c핑거스냅 능력으로 인해 곧 큰 폭발이 일어납니다!")
			players[j]:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, players[j]:getPlayer():getLocation():add(0,1,0), 1000, 0.1, 0.1, 0.1)
			players[j]:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, players[j]:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
			players[j]:getPlayer():playSound(players[j]:getPlayer():getLocation(), import("$.Sound").BLOCK_PORTAL_TRAVEL, 0.1, 1)
			util.runLater(function() 
				players[j]:getPlayer():getLocation():getWorld():createExplosion(players[j]:getPlayer():getLocation(), 10.0)
			end, 60)
		end
	end
end