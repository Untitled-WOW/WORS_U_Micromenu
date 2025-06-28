-- WORS_U_MagicPrayer.lua
magicID, prayerID = 1169, 1170
magicLevel, prayerLevel = 1, 1

-- function to initialise and update Magic Prayer Levels
function InitializeMagicPrayerLevels()
    magicLevel = GetLevelFromFactionReputation(magicID)
	prayerLevel = GetLevelFromFactionReputation(prayerID)
end

-- Function to set up magic buttons dynamically, with X and Y offsets
function SetupMagicButtons(XOffset, YOffset, frameName, magicButtons)
    if InCombatLockdown() then return end
    -- Clear existing buttons
    for _, btn in pairs(magicButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(magicButtons)

    local buttonSize, colPadding, rowPadding, margin, columns = 20, 5, 3, 10, 7
    -- Use the passed-in offsets
    local buttonXOffset = XOffset
    local buttonYOffset = YOffset

    for i, spellData in ipairs(WORS_U_SpellBook.spells) do
        local spellID, requiredLevel = spellData.id, spellData.level
        local spellName = select(1, GetSpellInfo(spellID))

        local spellButton = CreateFrame("Button", nil, frameName, "SecureActionButtonTemplate")
        spellButton:SetSize(buttonSize, buttonSize)
        local row = floor((i - 1) / columns)
        local col = (i - 1) % columns
        spellButton:SetPoint(
            "TOPLEFT", frameName, "TOPLEFT",
            buttonXOffset + margin + (buttonSize + colPadding) * col,
            -buttonYOffset - margin - (buttonSize + rowPadding) * row
        )

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
                        -- ...
                    end)
                end
            else
                icon:SetVertexColor(0.25, 0.25, 0.25)
            end
        end

        spellButton:SetAttribute("type", "spell")
        spellButton:SetAttribute("spell", spellID)
        spellButton:RegisterForDrag("LeftButton")
        spellButton:SetScript("OnDragStart", function(self)
            if spellName then PickupSpell(spellName) end
        end)
        spellButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        spellButton:SetScript("OnLeave", GameTooltip_Hide)

        table.insert(magicButtons, spellButton)
    end
end

-- Function to set up prayer buttons dynamically, with X and Y offsets
function SetupPrayerButtons(XOffset, YOffset, frameName, prayerButtons)
    if InCombatLockdown() then return end
    -- Clear existing buttons
    for _, btn in pairs(prayerButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(prayerButtons)

    local buttonSize, colPadding, rowPadding, margin, columns = 35, 2, -5, 5, 5
    local buttonXOffset = XOffset
    local buttonYOffset = YOffset

    for i, data in ipairs(WORS_U_PrayBook.prayers) do
        local id, reqLvl = data.id, data.level
        local prayerName = select(1, GetSpellInfo(id))

        local btn = CreateFrame("Button", nil, frameName, "SecureActionButtonTemplate")
        btn:SetSize(buttonSize, buttonSize)
        local row = floor((i - 1) / columns)
        local col = (i - 1) % columns
        btn:SetPoint(
            "TOPLEFT", frameName, "TOPLEFT",
            buttonXOffset + margin + (buttonSize + colPadding) * col,
            -buttonYOffset - margin - (buttonSize + rowPadding) * row
        )

        btn:SetNormalTexture(data.icon)
        local nt = btn:GetNormalTexture()
        nt:SetVertexColor(prayerLevel < reqLvl and .2 or 1, prayerLevel < reqLvl and .2 or 1, prayerLevel < reqLvl and .2 or 1)

        btn:SetAttribute("type1", "spell")
        btn:SetAttribute("spell1", prayerName)
        btn:SetAttribute("type2", "macro")
        btn:SetAttribute("macrotext2", "/cancelaura "..prayerName)

        btn:SetScript("OnEnter", function()
            GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(id)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function(self)
            if prayerName then PickupSpell(prayerName) end
        end)

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
