function main(abilityData)
	local attribute = import("$.attribute.Attribute")
	
	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 0, function(a, e)
		if e:getDamager():getType():toString() == "PLAYER" and e:getEntity():getType():toString() == "PLAYER" then
			local item = e:getDamager():getInventory():getItemInMainHand()
			local hit = tonumber(game.getPlayer(e:getDamager()):getVariable("EX010-hit"))
			if game.checkCooldown(e:getDamager(), a, 0) then
				if game.isAbilityItem(item, "IRON_INGOT") and hit ~= nil and hit > 0 then
					game.getPlayer(e:getDamager()):setVariable("EX010-hit", tostring(hit - 1))
					e:getEntity():setMaximumNoDamageTicks(0)
					util.runLater(function() 
						e:getEntity():setMaximumNoDamageTicks(12) 
					end, 1)
				else 
					e:getDamager():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(e:getDamager():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue())
				end
			end
		end
	end)
	
	plugin.registerEvent(abilityData, "PlayerSwapHandItemsEvent", 0, function(a, e)
		local item = e:getPlayer():getInventory():getItemInMainHand()
		local hit = tonumber(game.getPlayer(e:getPlayer()):getVariable("EX010-hit"))
		if game.checkCooldown(e:getPlayer(), a, 1) then
			if game.isAbilityItem(item, "IRON_INGOT") and hit ~= nil and hit > 0 then
				e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(1000)
			else 
				e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue())
			end
		end
		
		print(e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getBaseValue())
	end)
	
	plugin.registerEvent(abilityData, "PlayerItemHeldEvent", 0, function(a, e)
		local item = e:getPlayer():getInventory():getItem(e:getNewSlot())
		local hit = tonumber(game.getPlayer(e:getPlayer()):getVariable("EX010-hit"))
		if game.checkCooldown(e:getPlayer(), a, 2) then
			if game.isAbilityItem(item, "IRON_INGOT") and hit ~= nil and hit > 0 then
				e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(1000)
			else 
				e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue())
			end
		end
		
		print(e:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getBaseValue())
	end)
	
	plugin.addPassiveScript(abilityData, 0, function(p)
		local players = util.getTableFromList(game.getAllPlayers())
		game.getPlayer(p):setVariable("EX010-hit", tostring(#players * 20))
	end)
	
	plugin.addPassiveScript(abilityData, 1, function(p)
		local hit = game.getPlayer(p):getVariable("EX010-hit")
		game.sendActionBarMessage(p, "§a남은 타격 횟수 §6: §b" .. hit .. "회")
	end)
	
	plugin.onPlayerEnd(abilityData, function(p)
		p:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):setBaseValue(p:getPlayer():getAttribute(attribute.GENERIC_ATTACK_SPEED):getDefaultValue())
	end)
end