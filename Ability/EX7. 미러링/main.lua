local effect = import("$.potion.PotionEffectType")

function Init(abilityData)
	plugin.registerEvent(abilityData, "EX007-reflection", "EntityDamageEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX007-reflection" and funcTable[2]:getEventName() == "EntityDamageByEntityEvent" then reflection(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function reflection(LAPlayer, event, ability, id)
	local damagee = event:getEntity()
	local damager = event:getDamager()
	if damager:getType():toString() == "PROJECTILE" then damager = event:getDamager():getShooter() end
	
	if damager:getType():toString() == "PLAYER" and damagee:getType():toString() == "PLAYER" then
		if damagee:getHealth() - event:getDamage() <= 0 then
			if game.checkCooldown(LAPlayer, game.getPlayer(damagee), ability, id) then
				game.sendMessage(damager, "§c미러링 능력에 의해 즉사합니다.")
				game.sendMessage(damagee, "§4[§c미러링§4] §c능력이 발동되어 능력이 제거됩니다.")
				util.runLater(function() game.removeAbility(game.getPlayer(damagee), ability, false) end, 1)
				event:setCancelled(true)
				damagee:addPotionEffect(newInstance("$.potion.PotionEffect", {effect.HEAL, 10, 9}))
				damager:getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, damager:getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
				damager:getWorld():spawnParticle(import("$.Particle").REDSTONE, damager:getLocation():add(0,1,0), 300, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
				damager:getWorld():playSound(damager:getLocation(), import("$.Sound").ENTITY_WITHER_AMBIENT, 0.5, 1.0)
				damager:setHealth(0)
			end
		end
	end
end