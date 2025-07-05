-- WORS_U_MagicPrayer.lua
magicID, prayerID = 1169, 1170
magicLevel, prayerLevel = 1, 1

-- function to initialise and update Magic Prayer Levels
function InitializeMagicPrayerLevels()
    magicLevel = GetLevelFromFactionReputation(magicID)
	prayerLevel = GetLevelFromFactionReputation(prayerID)
end


-- Returns true if the player meets all requirements to cast spell works for wors magic spell rune requirment
function CanCastSpell(spellData)
    -- 1) level check
    if magicLevel < spellData.level then
        return false
    end
    -- 2) Blizzard’s “usable?” check (cooldowns, power, known, etc)
    local name = select(1, GetSpellInfo(spellData.id))
    local usable = IsUsableSpell(name)
    if not usable then
        return false
    end
    return true
end


-- One-time creation of magic buttons (e.g. on PLAYER_LOGIN)
-- One-time creation of magic buttons (e.g. in your PLAYER_LOGIN handler)
function SetupMagicButtons(XOffset, YOffset, frameName, magicButtons)
    if InCombatLockdown() then return end
    -- refresh the current magicLevel
    InitializeMagicPrayerLevels()

    -- clear any existing buttons
    for _, btn in pairs(magicButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(magicButtons)

    local buttonSize, colPadding, rowPadding, margin, columns = 20, 5, 3, 10, 7

    for i, data in ipairs(WORS_U_SpellBook.spells) do
        local spellID   = data.id
        local reqLvl    = data.level
        local spellName = select(1, GetSpellInfo(spellID))
        local row       = floor((i-1)/columns)
        local col       = (i-1)%columns

        -- create the secure button
        local btn = CreateFrame("Button", nil, frameName, "SecureActionButtonTemplate")
        btn:SetSize(buttonSize, buttonSize)
        btn:SetPoint(
            "TOPLEFT", frameName, "TOPLEFT",
            XOffset + margin + (buttonSize + colPadding) * col,
           -YOffset   - margin - (buttonSize + rowPadding) * row
        )

        -- stash the raw data for possible refresh use
        btn.spellData = data

        -- create & cache the icon texture
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexture(data.icon)
        btn.icon = icon

        -- initial coloring
        if magicLevel < reqLvl then
            icon:SetVertexColor(0.1, 0.1, 0.1)
        else
            if CanCastSpell(data) then
                icon:SetVertexColor(1, 1, 1)
            else
                icon:SetVertexColor(0.25, 0.25, 0.25)
            end
        end

        -- secure-cast attributes
        btn:SetAttribute("type",  "spell")
        btn:SetAttribute("spell", spellID)
        btn:RegisterForClicks("AnyUp")

        -- reopen backpack & auto-close micro-menu on these spells
        if data.openInv then
            btn:SetScript("PostClick", function()
                ToggleBackpack()
                local names = {
                    "High Alchemy", "Low Alchemy", "Superheat",
                    "Level-1 Enchant", "Level-2 Enchant", "Level-3 Enchant",
                    "Level-4 Enchant", "Level-5 Enchant",
                }
                local watcher = CreateFrame("Frame")
                watcher:RegisterEvent("UNIT_SPELLCAST_SENT")
                watcher:SetScript("OnEvent", function(self, _, unit, castName)
                    if unit == "player" then
                        for _, n in ipairs(names) do
                            if castName == n then
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

        -- drag-to-pick up
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function() PickupSpell(spellName) end)

        -- tooltip
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        -- throttled OnUpdate for dynamic coloring
        btn:SetScript("OnUpdate", function(self, elapsed)
            self._throttle = (self._throttle or 0) + elapsed
            if self._throttle < 0.25 then return end
            self._throttle = 0

            if magicLevel < reqLvl then
                icon:SetVertexColor(0.1, 0.1, 0.1)
            elseif CanCastSpell(data) then
                icon:SetVertexColor(1, 1, 1)
            else
                icon:SetVertexColor(0.25, 0.25, 0.25)
            end
        end)

        table.insert(magicButtons, btn)
    end
end

-- One-time creation of prayer buttons
function SetupPrayerButtons(XOffset, YOffset, frameName, prayerButtons)
    if InCombatLockdown() then return end
    InitializeMagicPrayerLevels()
    wipe(prayerButtons)

    local size, padX, padY, margin, cols = 35, 2, -5, 5, 5

    for i, data in ipairs(WORS_U_PrayBook.prayers) do
        local id, reqLvl = data.id, data.level
        local name       = select(1, GetSpellInfo(id))
        local row, col   = floor((i-1)/cols), (i-1)%cols

        local btn = CreateFrame("Button", nil, frameName, "SecureActionButtonTemplate")
        btn:SetSize(size, size)
        btn:SetPoint(
          "TOPLEFT", frameName, "TOPLEFT",
          XOffset + margin + (size+padX)*col,
          -YOffset   - margin - (size+padY)*row
        )

        -- create & cache our icon texture **and set its initial texture**:
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexture(data.icon)      -- <<< set the base icon here
        btn.icon = icon

		if prayerLevel < reqLvl then
			icon:SetTexture(data.icon)
			icon:SetVertexColor(0.25, 0.25, 0.25)
		elseif UnitPower("player", 0) < 200 then
			icon:SetTexture(data.icon)
			icon:SetVertexColor(0.5, 0.5, 0.5)
		elseif UnitBuff("player", name) then
			icon:SetTexture(data.buffIcon)
			icon:SetVertexColor(1, 1, 1)
		else
			icon:SetTexture(data.icon) 
			icon:SetVertexColor(1, 1, 1)
		end


        -- stash the raw data table directly
        btn.prayerData = data

        -- secure-cast
        btn:SetAttribute("type",  "spell")
        btn:SetAttribute("spell", name)
        btn:RegisterForClicks("AnyUp")

        -- tooltip & drag
        btn:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
          GameTooltip:SetSpellByID(id)
          GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function() PickupSpell(name) end)

        -- throttled OnUpdate for level, mana, buff-swap
        btn:SetScript("OnUpdate", function(self, elapsed)
            self._throttle = (self._throttle or 0) + elapsed
            if self._throttle < 0.25 then return end
            self._throttle = 0

            if prayerLevel < reqLvl then
                icon:SetTexture(data.icon)
                icon:SetVertexColor(0.25, 0.25, 0.25)
            elseif UnitPower("player", 0) < 200 then
                icon:SetTexture(data.icon)
                icon:SetVertexColor(0.5, 0.5, 0.5)
            elseif UnitBuff("player", name) then
                icon:SetTexture(data.buffIcon)
                icon:SetVertexColor(1, 1, 1)
            else
                icon:SetTexture(data.icon) 
                icon:SetVertexColor(1, 1, 1)
            end
        end)

        table.insert(prayerButtons, btn)
    end
end

