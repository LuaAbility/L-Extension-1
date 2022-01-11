function Init(abilityData)
	plugin.registerEvent(abilityData, "EX009-concert", "PlayerInteractEvent", 12000)
end

function onEvent(funcTable)
	if funcTable[1] == "EX009-concert" then concertAbility(funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX009-cooldown") == nil then 
		player:setVariable("EX009-cooldown", 0) 
		game.checkCooldown(player, ability, "EX009-concert", false)
	end
end

function concertAbility(event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(game.getPlayer(event:getPlayer()), ability, id) then
					if game.getPlayer(event:getPlayer()):getVariable("EX009-concert") ~= "true" then
						game.getPlayer(event:getPlayer()):setVariable("EX009-concert", "true")
						concert(event:getPlayer())
					else 
						game.sendMessage(event:getPlayer(), "§4[§cK.K.§4] §c당신의 콘서트는 이번 게임에서 이미 개최 되었습니다.") 
					end
				end
			end
		end
	end
end

function concert(p)
	local playerLoc = p:getLocation()
	
	local targetVec = newInstance("$.util.Vector", {playerLoc:getX(), playerLoc:getY(),playerLoc:getZ()})
	local playerEye = p:getEyeLocation():getDirection()
	playerEye = newInstance("$.util.Vector", {playerEye:getX() * 5, 0, playerEye:getZ() * 5})
	
	targetVec:setX(targetVec:getX() + playerEye:getX())
	targetVec:setZ(targetVec:getZ() + playerEye:getZ())
	
	playerLoc:setX(targetVec:getX())
	playerLoc:setY(targetVec:getY())
	playerLoc:setZ(targetVec:getZ())
	
	local players = util.getTableFromList(game.getPlayers())

	for i = 1, #players do
		if players[i]:getPlayer():getName() ~= p:getName() then
			players[i]:getPlayer():teleport(playerLoc)
			game.sendMessage(players[i]:getPlayer(), "§a어디선가 들려오는 노랫소리를 따라갑니다.")
		end
	end
	
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 1.10) end, 0)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 1.00) end, 4)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.90) end, 8)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.60) end, 12)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.70) end, 16)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.80) end, 18)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.90) end, 22)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.60) end, 44)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.70) end, 49)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.80) end, 51)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.85) end, 57)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.80) end, 63)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.70) end, 67)
	util.runLater(function() p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_NOTE_BLOCK_CHIME, 2, 0.60) end, 71)
	
	p:getWorld():spawnParticle(import("$.Particle").NOTE, p:getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.5)
end