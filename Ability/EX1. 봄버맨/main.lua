function main(abilityData)
	local types = import("$.entity.EntityType")
	
	plugin.registerEvent(abilityData, "PlayerInteractEvent", 10, function(a, e)
		if e:getAction():toString() == "RIGHT_CLICK_AIR" or e:getAction():toString() == "RIGHT_CLICK_BLOCK" then
			if e:getItem() ~= nil then
				if game.isAbilityItem(e:getItem(), "IRON_INGOT") then
					if game.checkCooldown(e:getPlayer(), a, 0, false) then
						local bomb = tonumber(game.getPlayer(e:getPlayer()):getVariable("EX001-bomb"))
						if bomb > 0 then
							game.sendMessage(e:getPlayer(), "§1[§b봄버맨§1] §b능력을 사용했습니다.")
							local entity = e:getPlayer():getWorld():spawnEntity(e:getPlayer():getLocation(), types.PRIMED_TNT)
							bomb = bomb - 1
							game.getPlayer(e:getPlayer()):setVariable("EX001-bomb", tostring(bomb))
							e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").BLOCK_GRASS_PLACE, 0.5, 0.8)
							e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ENTITY_TNT_PRIMED, 0.5, 1)
						else 
							game.sendMessage(e:getPlayer(), "§4[§c봄버맨§4] §c현재 소지 중인 폭탄이 없습니다.")
							a:ResetCooldown(e:getPlayer(), 0, false)
						end
					end
				end
			end
		end
	end)
	
	plugin.addPassiveScript(abilityData, 0, function(p)
		game.getPlayer(p):setVariable("EX001-bomb", "5")
	end)
	
	plugin.addPassiveScript(abilityData, 200, function(p)
		local bomb = tonumber(game.getPlayer(p):getVariable("EX001-bomb"))
		if bomb == nil then game.getPlayer(p):setVariable("EX001-bomb", 5) bomb = 5 end
		if bomb < 5 then
			bomb = bomb + 1
			game.getPlayer(p):setVariable("EX001-bomb", tostring(bomb))
		end
	end)
	
	plugin.addPassiveScript(abilityData, 1, function(p)
		local bomb = game.getPlayer(p):getVariable("EX001-bomb")
		game.sendActionBarMessage(p, "§a폭탄 §6: §b" .. bomb .. "개")
	end)
end