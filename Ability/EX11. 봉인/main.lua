function main(abilityData)
	local attribute = import("$.attribute.Attribute")
	
	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 2400, function(a, e)
		local damagee = e:getEntity()
		local damager = e:getDamager()
		if damager:getType():toString() == "PROJECTILE" then damager = e:getDamager():getShooter() end
	
		if damager:getType():toString() == "PLAYER" and damagee:getType():toString() == "PLAYER" then
			if game.checkCooldown(damagee, a, 0, false) then
				game.getPlayer(damager):setVariable("abilityLock", "true")
				damagee:sendMessage("§1[§b봉인§1] §b능력을 사용했습니다.")
				damager:sendMessage("§c능력이 봉인되었습니다! 30초 뒤에 재사용 가능합니다.")
				damager:getWorld():spawnParticle(import("$.Particle").REDSTONE, damager:getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").NAVY, 1}))
				damager:getWorld():playSound(damager:getLocation(), import("$.Sound").BLOCK_SCULK_SENSOR_CLICKING, 1, 0.5)

				util.runLater(function() 
					game.getPlayer(damager):removeVariable("abilityLock")
					damager:sendMessage("§a능력 봉인이 해제되었습니다.")
					damager:getWorld():spawnParticle(import("$.Particle").REDSTONE, damager:getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").YELLOW, 1}))
					damager:playSound(damager:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_PLING, 1, 2)
				end, 600)
			end
		end
	end)
end