function main(abilityData)
	plugin.registerEvent(abilityData, "EntityDamageByEntityEvent", 3600, function(a, e)
		if e:getDamager():getType():toString() == "PLAYER" and e:getEntity():getType():toString() == "PLAYER" then
			local item = e:getDamager():getInventory():getItemInMainHand()
			if game.isAbilityItem(item, "IRON_INGOT") then
				local ability = util.getTableFromList(game.getPlayer(e:getEntity()):getAbility())
				if #ability > 0 then
					if game.checkCooldown(e:getDamager(), a, 0) then
						game.addAbility(e:getDamager(), ability[1].abilityID)
						game.sendMessage(e:getDamager(), "§2[§a따라쟁이§2] ".. ability[1].abilityName .. "§a 능력을 사용할 수 있습니다.")
						
						e:getDamager():getWorld():playSound(e:getDamager():getLocation(), import("$.Sound").ENTITY_FOX_BITE, 0.5, 1)
							
						e:getDamager():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getDamager():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
						e:getEntity():getWorld():spawnParticle(import("$.Particle").REDSTONE, e:getEntity():getLocation():add(0,1,0), 200, 0.5, 1, 0.5, 0.05, newInstance("$.Particle$DustOptions", {import("$.Color").RED, 1}))
						
						util.runLater(function() 
							game.removeAbility(e:getDamager(), ability[1], false)
							game.sendMessage(e:getDamager(), "§1[§b따라쟁이§1] §b능력 시전 시간이 종료 되었습니다. (".. ability[1].abilityName ..")")
							e:getDamager():getWorld():playSound(e:getDamager():getLocation(), import("$.Sound").ENTITY_FOX_SPIT, 0.5, 1)
							e:getDamager():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, e:getDamager():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5)
						end, 300)
					end
				else game.sendMessage(e:getDamager(), "§4[§c따라쟁이§4] §c해당 플레이어는 능력이 없습니다.") end
			end
		end
	end)
end