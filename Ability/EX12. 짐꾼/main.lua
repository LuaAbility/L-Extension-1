function main(abilityData)
	plugin.addPassiveScript(abilityData, 1, function(p)
		local itemCount = 0
		for i = 0, 35 do
			local item = p:getInventory():getItem(i)
			if item ~= nil then itemCount = itemCount + item:getAmount() end
		end
		
		local helmet = p:getInventory():getHelmet()
		if helmet ~= nil then itemCount = itemCount + helmet:getAmount() end
		local chestplate = p:getInventory():getChestplate()
		if chestplate ~= nil then itemCount = itemCount + chestplate:getAmount() end
		local legging = p:getInventory():getLeggings()
		if legging ~= nil then itemCount = itemCount + legging:getAmount() end
		local boots = p:getInventory():getBoots()
		if boots ~= nil then itemCount = itemCount + boots:getAmount() end
		local offHand = p:getInventory():getItemInOffHand()
		if offHand ~= nil then itemCount = itemCount + offHand:getAmount() end
		
		itemCount = itemCount - 64 
		if itemCount < 0 then itemCount = 0 end
		if itemCount > 2000 then itemCount = 2000 end
		p:setWalkSpeed(0.4 - (0.00015 * itemCount))
		
		game.sendActionBarMessage(p, "§a현재 속도 §6: §bx" .. tostring(2.0 - (0.00075 * itemCount)))
	end)
	
	plugin.onPlayerEnd(abilityData, function(p)
		p:getPlayer():setWalkSpeed(0.2)
	end)
end