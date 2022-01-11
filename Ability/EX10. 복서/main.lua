local attribute = import("$.attribute.Attribute")

function Init(abilityData)
	plugin.registerEvent(abilityData, "EX010-setAttackSpeed1", "PlayerSwapHandItemsEvent", 0)
	plugin.registerEvent(abilityData, "EX010-setAttackSpeed2", "PlayerItemHeldEvent", 0)
	plugin.registerEvent(abilityData, "EX010-removeTicks", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX010-setAttackSpeed1" then setAttackSpeed(funcTable[2]:getPlayer():getInventory():getItemInOffHand(), funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "EX010-setAttackSpeed2" then setAttackSpeed(funcTable[2]:getPlayer():getInventory():getItem(funcTable[2]:getNewSlot()), funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "EX010-removeTicks" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then removeTicks(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX010-hit") == nil then 
		local players = util.getTableFromList(game.getAllPlayers())
		player:setVariable("EX010-hit", #players * 20) 
	end
	
	local hit = player:getVariable("EX010-hit")
	game.sendActionBarMessage(player:getPlayer(), "§a남은 타격 횟수 §6: §b" .. hit .. "회")
end

function Reset(player, ability)
	player:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(player:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue())
	local players = util.getTableFromList(game.getAllPlayers())
	for i = 1, #players do
		players[i]:getPlayer():setMaximumNoDamageTicks(12) 
	end
end

function setAttackSpeed(item, event, ability, id)
	local hit = game.getPlayer(event:getPlayer()):getVariable("EX010-hit")
	if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
		if game.isAbilityItem(item, "IRON_INGOT") and hit ~= nil and hit > 0 then event:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(1000)
		else event:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(event:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue()) end
	end
end

function removeTicks(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		local item = event:getDamager():getInventory():getItemInMainHand()
		local hit = game.getPlayer(event:getDamager()):getVariable("EX010-hit")
		if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
			if game.isAbilityItem(item, "IRON_INGOT") and hit ~= nil and hit > 0 then
				game.getPlayer(event:getDamager()):setVariable("EX010-hit", hit - 1)
				event:getEntity():setMaximumNoDamageTicks(0)
				util.runLater(function() 
					event:getEntity():setMaximumNoDamageTicks(12) 
				end, 1)
			else 
				event:getDamager():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(event:getDamager():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue())
			end
		end
	end
end