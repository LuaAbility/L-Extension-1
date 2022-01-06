function main(abilityData)
	local attribute = import("$.attribute.Attribute")
	local effect = import("$.potion.PotionEffectType")
	
	plugin.registerEvent(abilityData, "EntityDamageEvent", 0, function(a, e)
		if e:getEntity():getType():toString() == "PLAYER" then
			if game.checkCooldown(e:getEntity(), a, 0) then
				if game.getPlayer(e:getEntity()):getVariable("EX004-isResurrection") == "true" then e:setCancelled(true)
				elseif e:getEntity():getHealth() - e:getDamage() <= 0 then
					if not e:isCancelled() then
						local lives = tonumber(game.getPlayer(e:getEntity()):getVariable("EX004-lives")) - 1
						game.getPlayer(e:getEntity()):setVariable("EX004-lives", tostring(lives))
						if lives > 0 then
							e:setCancelled(true)
							e:getEntity():getWorld():spawnParticle(import("$.Particle").TOTEM, e:getEntity():getLocation():add(0,1,0), 200, 0.5, 1, 0.5, 0.75)
							e:getEntity():getWorld():playSound(e:getEntity():getLocation(), import("$.Sound").ITEM_TOTEM_USE, 0.5, 1)
							e:getEntity():setHealth(2.0)
							game.getPlayer(e:getEntity()):setVariable("EX004-isResurrection", "true")
							util.runLater(function() game.getPlayer(e:getEntity()):setVariable("EX004-isResurrection", "false") end, 60)
						else
							game.getPlayer(e:getEntity()):setVariable("EX004-lives", "9")
							game.sendMessage(e:getEntity(), "§4[§c구피§4] §c목숨을 모두 소모하여 사망합니다.")	
						end
					end
				end
			end
		end
	end)
	
	plugin.onPlayerEnd(abilityData, function(p)
		p:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):setBaseValue(p:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):getDefaultValue())
	end)
	
	plugin.addPassiveScript(abilityData, 0, function(p)
		p:setHealth(2.0)
		p:getAttribute(attribute.GENERIC_MAX_HEALTH):setBaseValue(2.0)
		game.getPlayer(p):setVariable("EX004-lives", "9")
	end)
	
	plugin.addPassiveScript(abilityData, 1, function(p)
		local lives = game.getPlayer(p):getVariable("EX004-lives")
		if game.getPlayer(p):getVariable("EX004-isResurrection") == "true" then game.sendActionBarMessage(p, "§6[데미지 무시] §a목숨 §7: §2" .. lives .. "개") 
		else game.sendActionBarMessage(p, "§a목숨 §7: §2" .. lives .. "개") end
	end)
end