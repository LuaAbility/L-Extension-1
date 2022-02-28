function Init(abilityData) end

function onTimer(player, ability)
	push(player)
end

function push(player)
	local players = util.getTableFromList(game.getPlayers())
	for i = 1, #players do
		if players[i] ~= player and game.targetPlayer(player, players[i], false) then
			if player:getPlayer():getWorld():getEnvironment() == players[i]:getPlayer():getWorld():getEnvironment() and
			player:getPlayer():getLocation():distance(players[i]:getPlayer():getLocation()) <= 5 then
				local moveDir = newInstance("$.util.Vector", {
				players[i]:getPlayer():getLocation():getX() - player:getPlayer():getLocation():getX(), 
				0.4, 
				players[i]:getPlayer():getLocation():getZ() - player:getPlayer():getLocation():getZ()})
				
				local dirLenfth = moveDir:length()
				moveDir:setX(moveDir:getX() / dirLenfth)
				moveDir:setZ(moveDir:getZ() / dirLenfth)
				players[i]:getPlayer():setVelocity(moveDir)
				
				player:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").ENTITY_LLAMA_SPIT, 0.2, 1)
				player:getPlayer():getWorld():spawnParticle(import("$.Particle").SPIT, player:getPlayer():getLocation():add(0,1,0), 50, 0.5, 1, 0.5, 0.5)
				players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").SPIT, players[i]:getPlayer():getLocation():add(0,1,0), 50, 0.5, 1, 0.5, 0.5)
			end
		end
	end
end