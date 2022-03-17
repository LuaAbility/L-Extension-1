local attribute = import("$.attribute.Attribute")

function Init(abilityData)
	plugin.registerEvent(abilityData, "EX004-checkLives", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX004-checkLives" then checkLives(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX004-lives") == nil then
		player:getPlayer():setHealth(game.getMaxHealth() * 0.1)
		player:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):setBaseValue(game.getMaxHealth() * 0.1)
		player:setVariable("EX004-lives", 9)
		player:setVariable("EX004-isResurrection", false) 
	end
	
	if player:getVariable("EX004-isResurrection") == true then game.sendActionBarMessage(player:getPlayer(), "§6[데미지 무시] §a목숨 §7: §2" .. player:getVariable("EX004-lives") .. "개") 
	else game.sendActionBarMessage(player:getPlayer(), "§a목숨 §7: §2" .. player:getVariable("EX004-lives") .. "개") end
end

function Reset(player, ability)
	player:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):setBaseValue(player:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):getDefaultValue())
end

function checkLives(LAPlayer, event, ability, id)
	if event:getEntity():getType():toString() == "PLAYER" then
		if game.checkCooldown(LAPlayer, game.getPlayer(event:getEntity()), ability, id) then
			if game.getPlayer(event:getEntity()):getVariable("EX004-isResurrection") == true then event:setCancelled(true)
			elseif event:getEntity():getHealth() - event:getDamage() <= 0 then
				if not event:isCancelled() then
					local lives = game.getPlayer(event:getEntity()):getVariable("EX004-lives") - 1
					game.getPlayer(event:getEntity()):setVariable("EX004-lives", lives)
					if lives > 0 then
						event:setCancelled(true)
						event:getEntity():getWorld():spawnParticle(import("$.Particle").TOTEM, event:getEntity():getLocation():add(0,1,0), 200, 0.5, 1, 0.5, 0.75)
						event:getEntity():getWorld():playSound(event:getEntity():getLocation(), import("$.Sound").ITEM_TOTEM_USE, 0.5, 1)
						event:getEntity():setHealth(2.0)
						game.getPlayer(event:getEntity()):setVariable("EX004-isResurrection", true)
						util.runLater(function() game.getPlayer(event:getEntity()):setVariable("EX004-isResurrection", false) end, 20)
					else
						game.getPlayer(event:getEntity()):setVariable("EX004-lives", 9)
						game.sendMessage(event:getEntity(), "§4[§c구피§4] §c목숨을 모두 소모하여 사망합니다.")	
					end
				end
			end
		end
	end
end