function main(abilityData)
	local effect = import("$.potion.PotionEffectType")

	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 0, function(a, e)
		local damagee = e:getEntity()
		local damager = e:getDamager()
		if damager:getType():toString() == "PROJECTILE" then damager = e:getDamager():getShooter() end
		
		if damager:getType():toString() == "PLAYER" and damagee:getType():toString() == "PLAYER" then
			if damagee:getHealth() - e:getDamage() <= 0 then
				if game.checkCooldown(e:getEntity(), a, 0) then
					game.sendMessage(damager, "§c미러링 능력에 의해 즉사합니다.")
					game.sendMessage(damagee, "§4[§c미러링§4] §c능력이 발동되어 능력이 제거됩니다.")
					game.removeAbility(damagee, a, false)
					e:setCancelled(true)
					damagee:addPotionEffect(newInstance("$.potion.PotionEffect", {effect.HEAL, 10, 9}))
					damager:getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, damager:getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
					damager:getWorld():spawnParticle(import("$.Particle").REDSTONE, damager:getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
					damager:getWorld():playSound(damager:getLocation(), import("$.Sound").ENTITY_WITHER_AMBIENT, 0.5, 1.0)
					damager:setHealth(0)
				end
			end
		end
	end)
end