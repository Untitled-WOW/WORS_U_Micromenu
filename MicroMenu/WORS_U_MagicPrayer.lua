--------------------------------------------
--------------------Pray for me-------------
--------------------------------------------
magicID, prayerID = 1169, 1170
magicLevel, prayerLevel = 1, 1
function InitializeMagicPrayerLevels()
    magicLevel = GetLevelFromFactionReputation(magicID)
	prayerLevel = GetLevelFromFactionReputation(prayerID)
end

local magicButtons = {}
local prayerButtons = {}

-- Function to set up magic buttons dynamically
function SetupMagicButtons(YOffset, frameName)
    if InCombatLockdown() then return end

    -- Clear existing buttons
    for _, btn in pairs(magicButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(magicButtons)

    local buttonSize, colPadding, rowPadding, margin, columns = 20, 5, 3, 10, 7 -- Adjust rowPadding as desired
	local buttonYOffset = YOffset -- Adjust this value to move buttons vertically

    for i, spellData in ipairs(WORS_U_SpellBook.spells) do
        local spellID = spellData.id
        local requiredLevel = spellData.level
        local spellButton = CreateFrame("Button", nil, frameName, "SecureActionButtonTemplate")
        spellButton:SetSize(buttonSize, buttonSize)
        local row = math.floor((i - 1) / columns)
        local col = (i - 1) % columns
		spellButton:SetPoint("TOPLEFT", frameName, "TOPLEFT", margin + (buttonSize + colPadding) * col, -margin - (buttonSize + rowPadding) * row - buttonYOffset)
        local icon = spellButton:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexture(spellData.icon)
        if magicLevel < requiredLevel then
            icon:SetVertexColor(0.1, 0.1, 0.1)
        else
            local hasRunes = WORS_U_SpellBook:HasRequiredRunes(spellData.runes)
            if hasRunes then
                icon:SetVertexColor(1, 1, 1)
                if spellData.openInv then
                    spellButton:SetScript("PostClick", function()
                        ToggleBackpack()
                        local names = {"High Alchemy", "Low Alchemy", "Superheat", "Level-1 Enchant", "Level-2 Enchant", "Level-3 Enchant", "Level-4 Enchant", "Level-5 Enchant"}
                        local watcher = CreateFrame("Frame")
                        watcher:RegisterEvent("UNIT_SPELLCAST_SENT")
                        watcher:SetScript("OnEvent", function(self, _, unit, spellName)
                            if unit == "player" then
                                for _, name in ipairs(names) do
                                    if spellName == name then
                                        MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)
                                        self:UnregisterAllEvents()
                                        self:SetScript("OnEvent", nil)
                                        break
                                    end
                                end
                            end
                        end)
                    end)
                end
            else
                icon:SetVertexColor(0.25, 0.25, 0.25)
            end
        end

        spellButton:SetAttribute("type", "spell")
        spellButton:SetAttribute("spell", spellID)
        
		spellButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        spellButton:SetScript("OnLeave", GameTooltip_Hide)

        table.insert(magicButtons, spellButton)
    end
end

function SetupPrayerButtons(YOffset, frameName)
    if InCombatLockdown() then return end
    -- clear old buttons
    for _, btn in pairs(prayerButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(prayerButtons)

	local buttonSize, colPadding, rowPadding, margin, columns = 35, 2, -5, 5, 5 -- Adjust rowPadding as desired
    local buttonYOffset = YOffset -- Change this value to move buttons up or down

    for i, data in ipairs(WORS_U_PrayBook.prayers) do
        local id, reqLvl = data.id, data.level
        -- Grab the localized name just once for buff checks & tooltips
        local prayerName = select(1, GetSpellInfo(id))
        -- Create the secure button
        local btn = CreateFrame("Button", nil, frameName, "SecureActionButtonTemplate")
        btn:SetSize(buttonSize, buttonSize)
        -- Position in grid
        local row, col = math.floor((i-1)/columns), (i-1) % columns
		btn:SetPoint("TOPLEFT", frameName, "TOPLEFT", margin + (buttonSize + colPadding) * col, -margin - (buttonSize + rowPadding) * row - buttonYOffset)
        btn:SetNormalTexture(data.icon)

        -- Gray out if not high enough level
        local nt = btn:GetNormalTexture()
        nt:SetVertexColor(prayerLevel < reqLvl and .2 or 1, prayerLevel < reqLvl and .2 or 1, prayerLevel < reqLvl and .2 or 1)
		
		btn:SetAttribute("type1", "spell") -- Left-click
		btn:SetAttribute("spell1", prayerName)

		btn:SetAttribute("type2", "macro") -- Right-click
		btn:SetAttribute("macrotext2", "/cancelaura " .. prayerName)
        
		-- Tooltip
        btn:SetScript("OnEnter", function()
            GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(id)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        -- OnUpdate: swap between your two static textures
        btn:SetScript("OnUpdate", function()
            if UnitBuff("player", prayerName) then
                btn:SetNormalTexture(data.buffIcon)
            else
                btn:SetNormalTexture(data.icon)
            end
        end)

        table.insert(prayerButtons, btn)
    end
end