local types = import("$.entity.EntityType")

function Init(abilityData)
	plugin.registerEvent(abilityData, "EX001-summonTNT", "PlayerInteractEvent", 10)
end

function onEvent(funcTable)
	if funcTable[1] == "EX001-summonTNT" then summonTNT(funcTable[3], funcTable[2], funcTable[4], funcTable[1]) end
end

function onTimer(player, ability)
	if player:getVariable("EX001-passiveCount") == nil then 
		player:setVariable("EX001-passiveCount", 0) 
		player:setVariable("EX001-bomb", 1) 
		player:setVariable("EX001-tnt", {}) 
	end
	local count = player:getVariable("EX001-passiveCount")
	game.sendActionBarMessage(player:getPlayer(), "§a폭탄 §6: §b" .. player:getVariable("EX001-bomb") .. "개")
	if count >= 400 then 
		count = 0
		addBomb(player)
	end
	count = count + 1
	player:setVariable("EX001-passiveCount", count)
end

function summonTNT(LAPlayer, event, ability, id)
	if event:getAction():toString() == "RIGHT_CLICK_AIR" or event:getAction():toString() == "RIGHT_CLICK_BLOCK" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id, false) then
					local bomb = LAPlayer:getVariable("EX001-bomb")
					if bomb > 0 then
						game.sendMessage(event:getPlayer(), "§1[§b봄버맨§1] §b능력을 사용했습니다.")
						local entity = event:getPlayer():getWorld():spawnEntity(event:getPlayer():getLocation(), types.PRIMED_TNT)
						entity:setSource(event:getPlayer())
						entity:setFuseTicks(9999999)
						table.insert(LAPlayer:getVariable("EX001-tnt"), entity)
						
						bomb = bomb - 1
						LAPlayer:setVariable("EX001-bomb", bomb)
						event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").BLOCK_GRASS_PLACE, 0.5, 0.8)
						event:getPlayer():getWorld():playSound(event:getPlayer():getLocation(), import("$.Sound").ENTITY_TNT_PRIMED, 0.5, 1)
					else 
						game.sendMessage(event:getPlayer(), "§4[§c봄버맨§4] §c현재 소지 중인 폭탄이 없습니다.")
						ability:resetCooldown(id)
					end
				end
			end
		end
	elseif event:getAction():toString() == "LEFT_CLICK_AIR" or event:getAction():toString() == "LEFT_CLICK_AIR" then
		if event:getItem() ~= nil then
			if game.isAbilityItem(event:getItem(), "IRON_INGOT") then
				if game.checkCooldown(LAPlayer, game.getPlayer(event:getPlayer()), ability, id, false) then
					local tnt = LAPlayer:getVariable("EX001-tnt")
					if #tnt > 0 then
						for i = 1, #tnt do
							tnt[i]:setFuseTicks(0)
						end
						LAPlayer:setVariable("EX001-tnt", { })
						game.sendMessage(event:getPlayer(), "§1[§b봄버맨§1] §b점화된 모든 폭탄을 폭파했습니다.")
					else 
						game.sendMessage(event:getPlayer(), "§4[§c봄버맨§4] §c현재 점화된 폭탄이 없습니다.")
						ability:resetCooldown(id)
					end
				end
			end
		end
	end
end

function addBomb(player)
	local bomb = player:getVariable("EX001-bomb")
	if bomb == nil then player:setVariable("EX001-bomb", 5) bomb = 5 end
	if bomb < 3 then
		bomb = bomb + 1
		player:setVariable("EX001-bomb", bomb)
	end
end