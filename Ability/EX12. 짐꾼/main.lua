local attribute = import("$.attribute.Attribute")

function Init(abilityData) end

function onTimer(player, ability)
	checkItem(player:getPlayer())
end

function Reset(player, ability)
	player:getPlayer():setWalkSpeed(0.2)
	game.sendActionBarMessageToAll("EX012", "")
end

function checkItem(p)
	local itemCount = 0
	for i = 0, 35 do
		local item = p:getInventory():getItem(i)
		if item ~= nil and item:getType():toString() ~= "AIR" then itemCount = itemCount + ((item:getAmount() / item:getMaxStackSize()) * 64f) end
	end
	
	local helmet = p:getInventory():getHelmet()
	if helmet ~= nil and helmet:getType():toString() ~= "AIR" then itemCount = itemCount + ((helmet:getAmount() / helmet:getMaxStackSize()) * 64f) end
	
	local chestplate = p:getInventory():getChestplate()
	if chestplate ~= nil and chestplate:getType():toString() ~= "AIR" then itemCount = itemCount + ((chestplate:getAmount() / chestplate:getMaxStackSize()) * 64f) end
	
	local legging = p:getInventory():getLeggings()
	if legging ~= nil and legging:getType():toString() ~= "AIR" then itemCount = itemCount + ((legging:getAmount() / legging:getMaxStackSize()) * 64f) end
	
	local boots = p:getInventory():getBoots()
	if boots ~= nil and boots:getType():toString() ~= "AIR" then itemCount = itemCount + ((boots:getAmount() / boots:getMaxStackSize()) * 64f) end
	
	local offHand = p:getInventory():getItemInOffHand()
	if offHand ~= nil and offHand:getType():toString() ~= "AIR" then itemCount = itemCount + ((offHand:getAmount() / offHand:getMaxStackSize()) * 64f) end
	
	itemCount = itemCount - 64 
	if itemCount < 0 then itemCount = 0 end
	if itemCount > 2000 then itemCount = 2000 end
	p:setWalkSpeed(0.4 - (0.00015 * itemCount))
	
	game.sendActionBarMessage(p, "EX012", "§a현재 속도 §6: §bx" .. tostring(2.0 - (0.00075 * itemCount)))
end