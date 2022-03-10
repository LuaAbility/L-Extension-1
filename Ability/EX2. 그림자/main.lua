function Init(abilityData)
	plugin.registerEvent(abilityData, "숨기", "PlayerInteractEvent", 1200)
	plugin.registerEvent(abilityData, "EX002-cancelDamage", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "숨기" then hiding(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "EX002-cancelDamage" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then cancelDamage(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX002-isInvisible") == nil then player:setVariable("EX002-isInvisible", 0) end
	local count = player:getVariable("EX002-isInvisible")
	if count > 0 then 
		count = count - 2 
		if count <= 0 then stopHiding(player) end
	end
	player:setVariable("EX002-isInvisible", count)
end

function Reset(player, ability)
	if player:getVariable("EX002-isInvisible") ~= nil and player:getVariable("EX002-isInvisible") > 0 then stopHiding(player) end
end

function stopHiding(player)
	game.sendMessage(player:getPlayer(), "§1[§b그림자§1] §b능력 시전 시간이 종료되었습니다. (숨기)")	
	player:setVariable("EX002-isInvisible", 0)
	player:getPlayer():getWorld():playSound(player:getPlayer():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1.2)
	player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
	player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5)
	
	local players = util.getTableFromList(game.getAllPlayers())
	for i = 1, #players do
		if players[i] ~= player then
			players[i]:getPlayer():showPlayer(plugin.getPlugin(), player:getPlayer())
		end
	end
end

function hiding(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					game.getPlayer(event:getPlayer()):setVariable("EX002-isInvisible", 200)
					event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").ITEM_CHORUS_FRUIT_TELEPORT, 0.5, 1.2)
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5)
					
					local players = util.getTableFromList(game.getAllPlayers())
					for i = 1, #players do
						if players[i] ~= game.getPlayer(event:getPlayer()) then
							players[i]:getPlayer():hidePlayer(plugin.getPlugin(), event:getPlayer())
						end
					end
				end
			end
		end
	end
end

function cancelDamage(LAPlayer, event, ability, id)
	local damager = event:getDamager()
	if event:getCause():toString() == "PROJECTILE" then damager = event:getDamager():getShooter() end
		
	if not util.hasClass(damager, "org.bukkit.projectiles.BlockProjectileSource") and damager:getType():toString() == "PLAYER" and game.getPlayer(damager):getVariable("EX002-isInvisible") ~= nil and game.getPlayer(damager):getVariable("EX002-isInvisible") > 0 then
		if game.checkCooldown(LAPlayer, game.getPlayer(damager), ability, id) then
			event:setCancelled(true)
		end
	end
	
	if event:getEntity():getType():toString() == "PLAYER" and game.getPlayer(event:getEntity()):getVariable("EX002-isInvisible") ~= nil and game.getPlayer(event:getEntity()):getVariable("EX002-isInvisible") > 0 then
		if game.checkCooldown(LAPlayer, game.getPlayer(event:getEntity()), ability, id) then
			event:setCancelled(true)
		end
	end
end