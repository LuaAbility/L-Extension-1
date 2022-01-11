function Init(abilityData)
	plugin.registerEvent(abilityData, "EX005-copy", "EntityDamageEvent", 3600)
end

function onEvent(funcTable)
	if funcTable[1] == "EX005-copy" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then copy(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX005-copyTime") == nil then 
		player:setVariable("EX005-copyTime", {})
		player:setVariable("EX005-copyID", {})
	end
	
	local count = player:getVariable("EX005-copyTime")
	local id = player:getVariable("EX005-copyID")
	local removalIndex = 0
	for i = 1, #count do
		if count[i] > 0 then 
			count[i] = count[i] - 2 
			if count[i] <= 0 then 
				removeAbility(player, id[i]) 
				removalIndex = i
			end
		end
	end
	
	if removalIndex > 0 then 
		table.remove(count, removalIndex)
		table.remove(id, removalIndex)
	end
	
	player:setVariable("EX005-copyTime", count)
	player:setVariable("EX005-copyID", id)
end

function Reset(player, ability)
	local id = player:getVariable("EX005-copyID")
	for i = 1, #id do
		removeAbility(player, id[i])
	end
end

function removeAbility(player, id)
	util.runLater(function() game.removeAbilityAsID(player, id) end, 1)
	game.sendMessage(player:getPlayer(), "§1[§b따라쟁이§1] §b능력 시전 시간이 종료 되었습니다. (".. id ..")")
	player:getPlayer():getWorld():playSound(player:getPlayer():getLocation(), import("$.Sound").ENTITY_FOX_SPIT, 0.5, 1)
	player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5)
end

function copy(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		local item = event:getDamager():getInventory():getItemInMainHand()
		if game.isAbilityItem(item, "IRON_INGOT") then
			if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
			local ability = util.getTableFromList(game.getPlayer(event:getEntity()):getAbility():clone())
				if #ability > 0 then
					game.sendMessage(event:getDamager(), "§2[§a따라쟁이§2] ".. ability[1].abilityName .. "§a 능력을 사용할 수 있습니다.")
					event:getDamager():getWorld():playSound(event:getDamager():getLocation(), import("$.Sound").ENTITY_FOX_BITE, 0.5, 1)
					event:getDamager():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getDamager():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
					event:getEntity():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getEntity():getLocation():add(0,1,0), 200, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
					util.runLater(function() 
						game.addAbility(game.getPlayer(event:getDamager()), ability[1].abilityID)
						local count = game.getPlayer(event:getDamager()):getVariable("EX005-copyTime")
						local copyID = game.getPlayer(event:getDamager()):getVariable("EX005-copyID")
						
						table.insert(count, 300)
						table.insert(copyID, ability[1].abilityID)
						
						game.getPlayer(event:getDamager()):setVariable("EX005-copyTime", count)
						game.getPlayer(event:getDamager()):setVariable("EX005-copyID", copyID)
					end, 1)
				else 
					game.sendMessage(event:getDamager(), "§4[§c따라쟁이§4] §c해당 플레이어는 능력이 없습니다.")
					ability:resetCooldown(id)
				end
			end
		end
	end
end