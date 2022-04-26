local effect = import("$.potion.PotionEffectType")

function Init(abilityData)
	plugin.registerEvent(abilityData, "EX006-curse", "PlayerDeathEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX006-curse" then curse(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function curse(LAPlayer, event, ability, id)
	local damageEvent = event:getEntity():getLastDamageCause()
	
	if (damageEvent ~= nil and damageEvent:isCancelled() == false and damageEvent:getEventName() == "EntityDamageByEntityEvent") then
		local damagee = damageEvent:getEntity()
		local damager = util.getRealDamager(damageEvent:getDamager())
		
		
		if damager ~= nil and damager:getType():toString() == "PLAYER" and damagee:getType():toString() == "PLAYER" then
			if game.checkCooldown(LAPlayer, game.getPlayer(damagee), ability, id) then
				game.broadcastMessage("§4[§cLAbility§4] " .. damager:getName() .. "§c님은 §4" .. damagee:getName() .. "§c님에게 저주를 받아 모든 능력을 잃습니다.")
				game.removeAbility(game.getPlayer(damager), ability, true)
				damager:getWorld():spawnParticle(import("$.Particle").REDSTONE, damager:getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").PURPLE, 1}))
				damager:getWorld():playSound(damager:getLocation(), import("$.Sound").BLOCK_BEACON_DEACTIVATE, 2, 0.9)
				damager:getWorld():playSound(damager:getLocation(), import("$.Sound").ENTITY_ZOMBIE_BREAK_WOODEN_DOOR, 0.3, 1)
				damager:addPotionEffect(newInstance("$.potion.PotionEffect", {effect.WEAKNESS, 3600, 2}))
			end
		end
	end
end