function main(abilityData)
	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 3600, function(a, e)
		if e:getDamager():getType():toString() == "PLAYER" and e:getEntity():getType():toString() == "PLAYER" then
			local item = e:getDamager():getInventory():getItemInMainHand()
			if game.isAbilityItem(item, "IRON_INGOT") then
				if game.checkCooldown(e:getDamager(), a, 0) then
					local killPercent = tonumber(game.getPlayer(e:getDamager()):getVariable("EX003-killPercent"))
					game.sendMessage(e:getEntity(), "§a갬블러가 게임을 신청하였습니다.")	
					game.sendMessage(e:getEntity(), "§a승리 확률 §7: §2" .. (100 - killPercent) .. "%" .. "§7 / " .. "§c패배 확률 §7: §4" .. killPercent .. "%")	
					e:getDamager():getWorld():playSound(e:getDamager():getLocation(), import("$.Sound").BLOCK_PORTAL_TRIGGER, 1, 1)
					
					for i = 1, 5 do
						util.runLater(function() 
							e:getDamager():getWorld():playSound(e:getDamager():getLocation(), import("$.Sound").ITEM_FLINTANDSTEEL_USE, 0.5, 1)
							e:getEntity():getWorld():playSound(e:getEntity():getLocation(), import("$.Sound").ITEM_FLINTANDSTEEL_USE, 0.5, 1)
							
							e:getDamager():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getDamager():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
							e:getEntity():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getEntity():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
						end, (i - 1) * 20)
					end
				
					util.runLater(function() 
						local randomNumber = math.random(1, 100)
						if randomNumber <= killPercent then 
							e:getEntity():getWorld():strikeLightningEffect(e:getEntity():getLocation())
							e:getEntity():damage(9999999, e:getDamager())
							game.sendMessage(e:getDamager(), "§2[§a갬블러§2] §a승리하셨습니다.")	
							game.sendMessage(e:getEntity(), "§c갬블러에게 패배하셨습니다.")	
							
							killPercent = killPercent - math.random(10, 20)
							if killPercent < 10 then killPercent = 10 end
							game.getPlayer(e:getDamager()):setVariable("EX003-killPercent", tostring(killPercent))
						else 
							e:getDamager():getWorld():strikeLightningEffect(e:getDamager():getLocation())
							e:getDamager():damage(9999999, e:getEntity())
							game.sendMessage(e:getEntity(), "§a갬블러에게 승리하셨습니다.")	
							game.sendMessage(e:getDamager(), "§4[§c갬블러§4] §c패배하셨습니다.")	
						end
						
					end, 100)
				end
			end
		end
	end)
	
	plugin.addPassiveScript(abilityData, 0, function(p)
		game.getPlayer(p):setVariable("EX003-killPercent", "75")
	end)
	
	plugin.addPassiveScript(abilityData, 1, function(p)
		local killPercent = tonumber(game.getPlayer(p):getVariable("EX003-killPercent"))
		game.sendActionBarMessage(p, "§a승리 확률 §7: §2" .. killPercent .. "%" .. "§7 / " .. "§c패배 확률 §7: §4" .. (100 - killPercent) .. "%")
	end)
end