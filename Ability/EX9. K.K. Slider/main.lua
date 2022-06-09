function Init(abilityData)
	plugin.registerEvent(abilityData, "콘서트 개최", "PlayerInteractEvent", 3000)
end

function onEvent(funcTable)
	if funcTable[1] == "콘서트 개최" then concertAbility(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function concertAbility(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					concert(event:getPlayer())
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
	playerLoc:setY(targetVec:getY() - 1)
	playerLoc:setZ(targetVec:getZ())
	
	local players = util.getTableFromList(game.getPlayers())

	for i = 1, #players do
		if players[i]:getPlayer():getName() ~= p:getName() and game.targetPlayer(game.getPlayer(p), players[i], false, true) then
			players[i]:getPlayer():setFallDistance(0)
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