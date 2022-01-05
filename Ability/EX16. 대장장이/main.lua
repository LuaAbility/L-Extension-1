function main(abilityData)
	
	plugin.registerEvent(abilityData, "PlayerInteractEvent", 40, function(a, e)
		if e:getAction():toString() == "LEFT_CLICK_AIR" or e:getAction():toString() == "LEFT_CLICK_BLOCK" then
			if e:getPlayer():getInventory():getItemInMainHand() ~= nil then
				if game.isAbilityItem(e:getPlayer():getInventory():getItemInMainHand(), "IRON_INGOT") then
					if game.checkCooldown(e:getPlayer(), a, 0, false) then
						local targetItem = e:getPlayer():getInventory():getItemInOffHand()
						if targetItem ~= nil and targetItem:getType():toString() ~= "AIR" then
							if string.find(targetItem:getItemMeta():getDisplayName(), "★5") == nil then
								if weaponDamage(targetItem:getType()) > 1 then
									local materialItem = { newInstance("$.inventory.ItemStack", { e:getPlayer():getInventory():getItemInMainHand():getType(), 1}) }
									
									game.sendActionBarMessage(e:getPlayer(), "§a강화 중...")
									effect(e:getPlayer())
										
									util.runLater(function() effect(e:getPlayer()) end, 10)
									util.runLater(function() effect(e:getPlayer()) end, 20)
									util.runLater(function()
									local result = starForce(targetItem)
										if result == -1 then
											e:getPlayer():getInventory():removeItem( materialItem )
											e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ENTITY_ITEM_BREAK, 1, 1.2)
											e:getPlayer():getWorld():spawnParticle(import("$.Particle").ITEM_CRACK, e:getPlayer():getLocation():add(0,1,0), 200, 0.1, 0.1, 0.1, 0.05, targetItem)
											game.sendMessage(e:getPlayer(), "§4[§c대장장이§4] §c강화에 실패하여 아이템이 파괴되었습니다.")
											game.sendActionBarMessage(e:getPlayer(), "§c강화 실패!")
											e:getPlayer():getInventory():setItemInOffHand(nil)
										else
											e:getPlayer():getInventory():removeItem( materialItem )
											game.sendMessage(e:getPlayer(), "§2[§a대장장이§2] §a강화에 성공했습니다! §6(★" .. (result - 1) .. " -> ★" .. result .. ")")
											game.sendActionBarMessage(e:getPlayer(), "§6강화 성공!")
											e:getPlayer():getWorld():spawnParticle(import("$.Particle").VILLAGER_HAPPY, e:getPlayer():getLocation():add(0,1,0), 100, 0.5, 1, 0.5, 0.05)
											if result < 5 then e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").ENTITY_VILLAGER_YES, 0.25, 1)
											else e:getPlayer():getWorld():playSound(e:getPlayer():getLocation(), import("$.Sound").UI_TOAST_CHALLENGE_COMPLETE, 1, 1) end 
										end
									end, 30)
								else game.sendMessage(e:getPlayer(), "§4[§c대장장이§4] §c강화 가능한 아이템이 아닙니다.") a:ResetCooldown(e:getPlayer(), 0, false) end
							else game.sendMessage(e:getPlayer(), "§4[§c대장장이§4] §c이미 최대 강화 상태입니다.") a:ResetCooldown(e:getPlayer(), 0, false) end
						else game.sendMessage(e:getPlayer(), "§4[§c대장장이§4] §c왼손에 아이템이 없습니다.") a:ResetCooldown(e:getPlayer(), 0, false) end
					end
				end
			end
		end
	end)
end

function effect(p)
	p:getWorld():spawnParticle(import("$.Particle").LAVA, p:getLocation():add(0,1,0), 20, 0.5, 0.5, 0.5, 0.5)
	p:getWorld():spawnParticle(import("$.Particle").SMOKE_NORMAL, p:getLocation():add(0,1,0), 50, 0.5, 0.5, 0.5, 0.05)
	p:getWorld():playSound(p:getLocation(), import("$.Sound").BLOCK_ANVIL_PLACE, 0.5, 1.6)
end

function starForce(targetItem)
	local attribute = import("$.attribute.Attribute")
	local equipmentSlot = import("$.inventory.EquipmentSlot")
	
	local itemMeta = targetItem:getItemMeta()
	
	local targetStar = 1
	local displayName = itemMeta:getDisplayName()
	if 		string.find(displayName, "★1") then targetStar = 2
	elseif	string.find(displayName, "★2") then targetStar = 3
	elseif	string.find(displayName, "★3") then targetStar = 4
	elseif	string.find(displayName, "★4") then targetStar = 5 end
	
	local targetStarPercent = 80
	if 		targetStar == 2 then targetStarPercent = 60
	elseif	targetStar == 3 then targetStarPercent = 40
	elseif	targetStar == 4 then targetStarPercent = 20
	elseif	targetStar == 5 then targetStarPercent = 10 end
	
	local randomNumber = math.random(1, 100)
	if randomNumber <= targetStarPercent then
		local itemDamage = weaponDamage(targetItem:getType()) - 1
		
		if 		targetStar == 1 then itemDamage = itemDamage + 1
		elseif 	targetStar == 2 then itemDamage = itemDamage + 2
		elseif	targetStar == 3 then itemDamage = itemDamage + 3
		elseif	targetStar == 4 then itemDamage = itemDamage + 4
		elseif	targetStar == 5 then itemDamage = itemDamage + 5 end
		
		local itemAttribute = newInstance("$.attribute.AttributeModifier", {import("java.util.UUID"):randomUUID(), "generic.attackDamage", itemDamage, import("$.attribute.AttributeModifier$Operation").ADD_NUMBER, equipmentSlot.HAND})
		
		if itemMeta:hasEnchant(import("$.enchantments.Enchantment").VANISHING_CURSE) ~= true then itemMeta:addEnchant(import("$.enchantments.Enchantment").VANISHING_CURSE, 1, true) end
		if itemMeta:hasItemFlag(import("$.inventory.ItemFlag").HIDE_ATTRIBUTES) ~= true then itemMeta:addItemFlags({ import("$.inventory.ItemFlag").HIDE_ATTRIBUTES }) end
		if itemMeta:hasAttributeModifiers() then itemMeta:removeAttributeModifier(attribute.GENERIC_ATTACK_DAMAGE) end
		itemMeta:addAttributeModifier(attribute.GENERIC_ATTACK_DAMAGE, itemAttribute)
		itemMeta:removeAttributeModifier(equipmentSlot.OFF_HAND)
		
		local lore = newInstance("java.util.ArrayList", {})
		lore:add("§7무기 데미지 : " .. tostring(itemDamage + 1))
		itemMeta:setLore( lore )
		itemMeta:setUnbreakable(true)
		
		itemMeta:setDisplayName("§6[★" .. targetStar .. "] §a대장장이의 무기")
		targetItem:setItemMeta(itemMeta)
	else return -1 end
	
	return targetStar
end

function weaponDamage(itemType)
	local material = import("$.Material")
	 if 	itemType == material.WOODEN_AXE 		then	return 7 
	 elseif itemType == material.WOODEN_SWORD 		then	return 4 
	 elseif itemType == material.STONE_AXE 			then	return 9 
	 elseif itemType == material.STONE_SWORD 		then	return 5 
	 elseif itemType == material.IRON_AXE 			then	return 9 
	 elseif itemType == material.IRON_SWORD 		then	return 6 
	 elseif itemType == material.GOLDEN_AXE 		then	return 7 
	 elseif itemType == material.GOLDEN_SWORD 		then	return 4 
	 elseif itemType == material.DIAMOND_AXE 		then	return 9 
	 elseif itemType == material.DIAMOND_SWORD 		then	return 7 
	 elseif itemType == material.NETHERITE_AXE 		then	return 10 
	 elseif itemType == material.NETHERITE_SWORD 	then	return 8  
	 else 													return 1 end
end