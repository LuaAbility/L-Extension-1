function Init(abilityData)
	plugin.registerEvent(abilityData, "시간 정지", "PlayerInteractEvent", 2400)
	plugin.registerEvent(abilityData, "EX014-stopMove", "PlayerMoveEvent", 0)
end

function onEvent(funcTable)
	if funcTable[1] == "시간 정지" then stopTime(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
	if funcTable[1] == "EX014-stopMove" then stopMove(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if plugin.getPlugin().gameManager:getVariable("stopTime") == nil then plugin.getPlugin().gameManager:setVariable("stopTime", 0) end
	local count = plugin.getPlugin().gameManager:getVariable("stopTime")
	if count > 0 then 
		count = count - 1 
		if count <= 0 then endOfAbility(player)
		else cancelVelocity(player) end
	end
	plugin.getPlugin().gameManager:setVariable("stopTime", count)
end

function stopMove(player, event, ability, id)
	local stop = plugin.getPlugin().gameManager:getVariable("stopTime")
	if stop ~= nil and stop > 0 then
		if game.getPlayer(event:getPlayer()) ~= player and game.targetPlayer(player, game.getPlayer(event:getPlayer()), false) then
			event:setCancelled(true)
			game.sendActionBarMessage(event:getPlayer(), "§4시간 정지 §c능력에 의해 이동하실 수 없습니다. (남은 시간 : " .. stop / 20.0 .. "s)")
		end
	end
end

function cancelVelocity(player)
	local players = util.getTableFromList(game.getPlayers())
	for i = 1, #players do
		if players[i] ~= player and game.targetPlayer(player, players[i], false) then
			players[i]:getPlayer():setVelocity(newInstance("$.util.Vector", {0, 0, 0}))
		end
	end
end

function endOfAbility(player)
	local players = util.getTableFromList(game.getPlayers())
	for i = 1, #players do
		if players[i] ~= player and game.targetPlayer(player, players[i], false) then
			players[i]:removeVariable("abilityLock")
			players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").BLOCK_GLASS_BREAK, 2, 1.2)
			players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").BLOCK_BELL_USE, 1, 1)
			players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").ITEM_CRACK, players[i]:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.05, newInstance("$.inventory.ItemStack", {import("$.Material").GLASS}))
			players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").REVERSE_PORTAL, players[i]:getPlayer():getLocation():add(0,1,0), 500, 0.1, 0.1, 0.1)
		end
	end
	
	game.sendMessage(player:getPlayer(), "§2[§a시간 정지§2] §a능력 시전 시간이 종료되었습니다. (시간 정지)") 
end

function Reset(player, ability)
	if plugin.getPlugin().gameManager:getVariable("stopTime") ~= nil and plugin.getPlugin().gameManager:getVariable("stopTime") > 0 then endOfAbility(player) end
end

function stopTime(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id) then
					plugin.getPlugin().gameManager:setVariable("stopTime", 100)
					
					local players = util.getTableFromList(game.getPlayers())
					
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").REDSTONE, event:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.5, newInstance("$.Particle$DustOptions", {import("$.Color").AQUA, 1}))
					event:getPlayer():getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, event:getPlayer():getLocation():add(0,1,0), 150, 0.5, 1, 0.5, 0.1)
					event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").BLOCK_BELL_USE, 2, 1)
					
					for i = 1, #players do
						if players[i] ~= game.getPlayer(event:getPlayer()) and game.targetPlayer(LAPlayer, players[i], false) then
							game.sendMessage(players[i]:getPlayer(), "§4시간 정지 §c능력에 의해 이동, 능력이 봉인됩니다.")
							players[i]:setVariable("abilityLock", true)
							players[i]:getPlayer():getWorld():playSound(players[i]:getPlayer():getLocation(), import("$.Sound").BLOCK_BELL_RESONATE, 2, 1)
							players[i]:getPlayer():getWorld():spawnParticle(import("$.Particle").PORTAL, players[i]:getPlayer():getLocation():add(0,1,0), 500, 0.1, 0.1, 0.1)
						end
					end
				end
			end
		end
	end
end