function main(abilityData)
	plugin.registerEvent(abilityData, "PlayerDeathEvent", 0, function(a, e)
		local damageEvent = e:getEntity():getLastDamageCause()
		
		if (damageEvent ~= nil and damageEvent:isCancelled() == false and damageEvent:getEventName() == "EntityDamageByEntityEvent") then
			local damagee = damageEvent:getEntity()
			local damager = damageEvent:getDamager()
			if damageEvent:getCause():toString() == "PROJECTILE" then damager = damageEvent:getDamager():getShooter() end
			
			if damager:getType():toString() == "PLAYER" and damagee:getType():toString() == "PLAYER" then
				if game.checkCooldown(e:getEntity(), a, 0) then
					game.broadcastMessage("§4[§cLAbility§4] " .. damager:getName() .. "§c님은 §4" .. damagee:getName() .. "§c님에게 저주 받아 모든 능력을 잃습니다.")
					game.removeAbility(damager, a, true)
					damager:getWorld():spawnParticle(import("$.Particle").REDSTONE, damager:getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").PURPLE, 1}))
					damager:getWorld():playSound(damager:getLocation(), import("$.Sound").BLOCK_BEACON_DEACTIVATE, 2, 0.9)
					damager:getWorld():playSound(damager:getLocation(), import("$.Sound").ENTITY_ZOMBIE_BREAK_WOODEN_DOOR, 0.3, 1)
				end
			end
		end
	end)
end