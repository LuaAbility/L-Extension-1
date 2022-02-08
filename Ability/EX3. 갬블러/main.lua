function Init(abilityData)
	plugin.registerEvent(abilityData, "EX003-gamble", "EntityDamageEvent", 3600)
end

function onEvent(funcTable)
	if funcTable[1] == "EX003-gamble" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then gamble(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX003-killPercent") == nil then player:setVariable("EX003-killPercent", 50) end
	local killPercent = player:getVariable("EX003-killPercent")
	game.sendActionBarMessage(player:getPlayer(), "§a승리 확률 §7: §2" .. killPercent .. "%" .. "§7 / " .. "§c패배 확률 §7: §4" .. (100 - killPercent) .. "%")
end

function gamble(LAPlayer, event, ability, id)
	if event:getDamager():getType():toString() == "PLAYER" and event:getEntity():getType():toString() == "PLAYER" then
		local item = event:getDamager():getInventory():getItemInMainHand()
		if game.isAbilityItem(item, "IRON_INGOT") then
			if game.checkCooldown(LAPlayer, game.getPlayer(event:getDamager()), ability, id) then
				local killPercent = game.getPlayer(event:getDamager()):getVariable("EX003-killPercent")
				game.sendMessage(event:getEntity(), "§a갬블러가 게임을 신청하였습니다.")	
				game.sendMessage(event:getEntity(), "§a승리 확률 §7: §2" .. (100 - killPercent) .. "%" .. "§7 / " .. "§c패배 확률 §7: §4" .. killPercent .. "%")	
				event:getDamager():getWorld():playSound(event:getDamager():getLocation(), import("$.Sound").BLOCK_PORTAL_TRIGGER, 1, 1)
				
				for i = 1, 5 do
					util.runLater(function() 
						event:getDamager():getWorld():playSound(event:getDamager():getLocation(), import("$.Sound").ITEM_FLINTANDSTEEL_USE, 0.5, 1)
						event:getEntity():getWorld():playSound(event:getEntity():getLocation(), import("$.Sound").ITEM_FLINTANDSTEEL_USE, 0.5, 1)
						
						event:getDamager():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getDamager():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
						event:getEntity():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getEntity():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
					end, (i - 1) * 20)
				end
			
				util.runLater(function() 
					
					local randomNumber = util.random(1, 100)
					if randomNumber <= killPercent then 
						event:getEntity():getWorld():strikeLightningEffect(event:getEntity():getLocation())
						event:getEntity():damage(9999999, event:getDamager())
						game.sendMessage(event:getDamager(), "§2[§a갬블러§2] §a승리하셨습니다.")	
						game.sendMessage(event:getEntity(), "§c갬블러에게 패배하셨습니다.")	
						
						killPercent = killPercent - util.random(10, 20)
						if killPercent < 10 then killPercent = 10 end
						game.getPlayer(event:getDamager()):setVariable("EX003-killPercent", killPercent)
					else 
						event:getDamager():getWorld():strikeLightningEffect(event:getDamager():getLocation())
						event:getDamager():damage(9999999, event:getEntity())
						game.sendMessage(event:getEntity(), "§a갬블러에게 승리하셨습니다.")	
						game.sendMessage(event:getDamager(), "§4[§c갬블러§4] §c패배하셨습니다.")	
					end
				end, 100)
			end
		end
	end
end