local attribute = import("$.attribute.Attribute")

function Init(abilityData)
	plugin.registerEvent(abilityData, "EX013-cancelDamage", "EntityDamageEvent", 0)
	plugin.registerEvent(abilityData, "EX013-checkFriendDead", "PlayerDeathEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "EX013-cancelDamage" then cancelDamage(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "EX013-checkFriendDead" then checkFriendDead(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX013-friend") == nil then 
		local players = util.getTableFromList(game.getPlayers())
		local playerIndex = 1
		local playerName = player:getPlayer():getName()
		
		while player:getPlayer():getName() == playerName do 
			
			playerIndex = util.random(1, #players)
			playerName = players[playerIndex]:getPlayer():getName() 
		end
		
		player:setVariable("EX013-friend", playerName)
		game.broadcastMessage("§2[§a일심동체§2] " .. playerName .. "§a님이 사망 시 §2" .. player:getPlayer():getName() .. "§a님이 동반 사망합니다.")
		game.broadcastMessage("§2[§a일심동체§2] " .. player:getPlayer():getName() .. "§a님은 사망 전 까지 모든 데미지를 50%로 줄여 받습니다.")
		
		createBossbar(player)
	end
	
	local friend = player:getVariable("EX013-friend")
	game.sendActionBarMessage(player:getPlayer(), "EX013", "§e일심동체 §7: §6" .. friend)
	
	if #util.getTableFromList(game.getPlayers()) <= 2 then
		game.removeAbility(player, ability, false)
		player:getPlayer():getAttribute(attribute.GENERIC_MAX_HEALTH):setBaseValue(game.getMaxHealth() * 2)
		game.broadcastMessage("§2[§a일심동체§2] §a게임 인원이 2명이 되어 일심동체 능력이 제거됩니다.")
	end
end

function cancelDamage(LAPlayer, event, ability, id)
	if event:getEntity():getType():toString() == "PLAYER" then
		if game.checkCooldown(LAPlayer, game.getPlayer(event:getEntity()), ability, id) then
			event:setDamage(event:getDamage() * 0.5)
		end
	end
end

function checkFriendDead(player, event, ability, id)
	if event:getEntity():getType():toString() == "PLAYER" then
		local players = util.getTableFromList(game.getPlayers())
		if player:getVariable("EX013-friend") == event:getEntity():getName() and #players > 2 then
			if game.checkCooldown(player, player, ability, id) then
				game.sendMessage(player:getPlayer(), "§4[§c일심동체§4] " .. event:getEntity():getName() .. "§c님이 사망하여 같이 사망합니다.")
				player:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, player:getPlayer():getLocation():add(0,1,0), 1000, 0.5, 1, 0.5)
				player:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, player:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05)
				player:getPlayer():playSound(player:getPlayer():getLocation(), import("$.Sound").ENTITY_WITHER_DEATH, 2, 0.7)
				player:getPlayer():setHealth(0)
			end
		end
	end
end

function createBossbar(player)
	local barText = "§6" .. player:getPlayer():getName() .. " §e: §c" .. player:getVariable("EX013-friend") .. " 사망 시 동반 사망"
	local friendKey = newInstance("$.NamespacedKey", {plugin.getPlugin(), player:getPlayer():getUniqueId():toString() .. "DRAGON" })
	local friendBar = plugin.getServer():createBossBar(friendKey, barText, import("$.boss.BarColor").PURPLE, import("$.boss.BarStyle").SEGMENTED_20, { } )
	local players = util.getTableFromList(game.getPlayers())
	for i = 1, #players do
		friendBar:addPlayer(players[i]:getPlayer())
	end
	
	friendBar:setProgress(1)
	player:setVariable("EX013-friendBar", friendBar)
end

function removeBossbar(player)
	local friendBar = player:getVariable("EX013-friendBar")
	if friendBar ~= nil then
		friendBar:setVisible(false)
	end
end

function Reset(player, ability)
	removeBossbar(player)
	game.sendActionBarMessageToAll("EX013", "")
end