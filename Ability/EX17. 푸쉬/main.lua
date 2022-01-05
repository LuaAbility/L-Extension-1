function main(abilityData)
	plugin.addPassiveScript(abilityData, 2, function(p)
		local players = util.getTableFromList(game.getPlayers())
		for i = 1, #players do
			if players[i]:getPlayer() ~= p then
				if (p:getLocation():distance(players[i]:getPlayer():getLocation()) <= 5) then
					local moveDir = newInstance("$.util.Vector", {
					players[i]:getPlayer():getLocation():getX() - p:getLocation():getX(), 
					0.4, 
					players[i]:getPlayer():getLocation():getZ() - p:getLocation():getZ()})
					
					local dirLenfth = moveDir:length()
					moveDir:setX(moveDir:getX() / dirLenfth)
					moveDir:setZ(moveDir:getZ() / dirLenfth)
					players[i]:getPlayer():setVelocity(moveDir)
					
					p:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").ENTITY_LLAMA_SPIT, 0.2, 1)
					p:getPlayer():getWorld():spawnParticle(import("$.Particle").SPIT, p:getPlayer():getLocation():add(0,1,0), 50, 0.5, 1, 0.5, 0.5)
					players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").SPIT, players[i]:getPlayer():getLocation():add(0,1,0), 50, 0.5, 1, 0.5, 0.5)
				end
			end
		end
	end)
end