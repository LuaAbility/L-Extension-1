function Init(abilityData)
	plugin.registerEvent(abilityData, "EX019-swap", "EntityDamageEvent", 6000)
end

function onEvent(funcTable)
	if funcTable[1] == "EX019-swap" then swap(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function swap(LAPlayer, event, ability, id)
	if event:getEntity():getType():toString() == "PLAYER" then
		if event:getEntity():getHealth() - event:getDamage() <= 0 then
			if game.checkCooldown(LAPlayer, game.getPlayer(event:getEntity()), ability, id) then
				event:setCancelled(true)
				local players = util.getTableFromList(game.getPlayers())
				
				local targetPlayer = players[math.random(1, #players)]:getPlayer()
				while targetPlayer:getName() == event:getEntity():getName() do targetPlayer = players[math.random(1, #players)]:getPlayer() end
				
				local targetLoc1 = targetPlayer:getLocation():clone()
				local targetLoc2 = event:getEntity():getLocation():clone()
				
				targetPlayer:teleport(targetLoc2)
				event:getEntity():teleport(targetLoc1)
				
				util.runLater(function() 
					targetPlayer:getWorld():spawnParticle(import("$.Particle").SMOKE_LARGE, targetLoc2:add(0,1,0), 1000, 0.5, 1, 0.5, 0.05)
					targetPlayer:getWorld():playSound(targetLoc2, import("$.Sound").ENTITY_SHULKER_BULLET_HURT, 0.5, 1.2)
					game.sendMessage(targetPlayer, "§2고기방패 §a능력으로 인해 해당 플레이어와 위치가 바뀝니다.")
					
					event:getEntity():getWorld():spawnParticle(import("$.Particle").SMOKE_LARGE, targetLoc1:add(0,1,0), 1000, 0.5, 1, 0.5, 0.05)
					event:getEntity():getWorld():playSound(targetLoc1, import("$.Sound").ENTITY_SHULKER_BULLET_HURT, 0.5, 1.2)
					game.sendMessage(event:getEntity(), "§2[§a고기방패§2] ".. targetPlayer:getName() .. "§a님과 위치를 바꿉니다.")
				end, 2)
			end
		end
	end
end