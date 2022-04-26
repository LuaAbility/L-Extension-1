function Init(abilityData)
	plugin.registerEvent(abilityData, "푸쉬", "PlayerInteractEvent", 1000)
end

function onEvent(funcTable)
	if funcTable[1] == "푸쉬" then enable(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX017-useAbility") == nil then player:setVariable("EX017-useAbility", 0) end
	if player:getVariable("EX017-useAbility") > 0 then 
		push(player) 
		game.sendActionBarMessage(player:getPlayer(), "EX017", "§b푸쉬 §f: §a" .. math.ceil(player:getVariable("EX017-useAbility") / 20) .. "초")
		player:setVariable("EX017-useAbility", player:getVariable("EX017-useAbility") - 1)
		player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player:getPlayer():getLocation():add(0,1,0), 3, 0.5, 1, 0.5, 0.05)
	else
		game.sendActionBarMessage(player:getPlayer(), "EX017", "")
	end
end

function Reset(player, ability)
	game.sendActionBarMessageToAll("EX017", "")
end

function push(player)
	local players = util.getTableFromList(game.getTeamManager():getOpponentTeam(player, false))
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

function enable(LAPlayer, event, ability, id)
	if event:getAction():toString() == "LEFT_CLICK_AIR" or event:getAction():toString() == "LEFT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					if game.getPlayer(event:getPlayer()):getVariable("EX017-useAbility") then
						game.getPlayer(event:getPlayer()):setVariable("EX017-useAbility", 200)
						event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.05)
					end
				end
			end
		end
	end
end