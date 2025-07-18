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
    local name = select(1, GetSpellInfo(spellData.id))
    local usable = IsUsableSpell(name)
    if not usable then
        return false
    end
    return true
end

function SetupMagicButtons(XOffset, YOffset, parentFrame, magicButtons)
    -- make sure parentFrame is a Frame object, not a string
    assert(type(parentFrame) == "table" and parentFrame.GetName, "pass the frame object, not its name")

    InitializeMagicPrayerLevels()

    -- clear old buttons
    for _, btn in ipairs(magicButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(magicButtons)

    local btnSize, colPad, rowPad, margin, cols = 20, 5, 3, 10, 7

    for i, data in ipairs(WORS_U_SpellBook.spells) do
        local spellID, reqLvl = data.id, data.level
        local row, col = floor((i-1)/cols), (i-1)%cols

        local btnName =  "SpellBtn" .. i
        local btn = CreateFrame("Button", btnName, parentFrame, "WORSSpellTemplate")
        btn:SetSize(btnSize, btnSize)
        btn:SetPoint("TOPLEFT", parentFrame, "TOPLEFT",
                     XOffset + margin + (btnSize + colPad) * col,
                     -YOffset   - margin - (btnSize + rowPad) * row)
        btn:SetID(spellID)

		local secureBtn = _G["WORS_KeyBindBtn" .. i]
		if secureBtn then
			secureBtn:SetAttribute("spell", GetSpellInfo(spellID))
		end

        -- 1) hide the XML-template icon so it never draws
        local templateIcon = _G[btnName .. "Icon"]
        if templateIcon then
            templateIcon:SetTexture(nil)
        end

        -- 2) create your own icon on ARTWORK layer (above background)
        local myIcon = btn:CreateTexture(nil, "ARTWORK")
        myIcon:SetAllPoints(btn)
        myIcon:SetTexture(data.icon)
        btn.icon = myIcon

        -- clear any leftover count text
        local cnt = _G[btnName .. "Count"]
        if cnt then cnt:SetText("") end

        -- initial coloring
        if magicLevel < reqLvl then
            myIcon:SetVertexColor(0.1,0.1,0.1)
        elseif CanCastSpell(data) then
            myIcon:SetVertexColor(1,1,1)
        else
            myIcon:SetVertexColor(0.25,0.25,0.25)
        end

        btn.spellData = data

        -- carry over your PostClick watcher for openInv spells
        if data.openInv then
            btn:SetScript("PostClick", function()
                ToggleBackpack()
                local names = {
                    "High Alchemy","Low Alchemy","Superheat",
                    "Level-1 Enchant","Level-2 Enchant","Level-3 Enchant",
                    "Level-4 Enchant","Level-5 Enchant",
                }
                local watcher = CreateFrame("Frame")
                watcher:RegisterEvent("UNIT_SPELLCAST_SENT")
                watcher:SetScript("OnEvent", function(self, _, unit, castName)
                    if unit=="player" then
                        for _, n in ipairs(names) do
                            if castName==n then
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

        -- drag-to-pickup
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function()
            PickupSpell(select(1,GetSpellInfo(spellID)))
        end)

        -- tooltip
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)

        -- throttled OnUpdate for recoloring
        btn:SetScript("OnUpdate", function(self, elapsed)
            self._throttle = (self._throttle or 0) + elapsed
            if self._throttle < 0.25 then return end
            self._throttle = 0

            if magicLevel < reqLvl then
                myIcon:SetVertexColor(0.1,0.1,0.1)
            elseif CanCastSpell(data) then
                myIcon:SetVertexColor(1,1,1)
            else
                myIcon:SetVertexColor(0.25,0.25,0.25)
            end
        end)

        tinsert(magicButtons, btn)
    end
end






function SetupPrayerButtons(XOffset, YOffset, parentFrame, prayerButtons)
    -- ensure parentFrame is an actual Frame, not a string
    assert(type(parentFrame) == "table" and parentFrame.GetName, "pass the frame object, not its name")

    InitializeMagicPrayerLevels()

    -- hide & clear out old buttons
    for _, btn in ipairs(prayerButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(prayerButtons)

    local size, padX, padY, margin, cols = 35, 2, -5, 5, 5

    for i, data in ipairs(WORS_U_PrayBook.prayers) do
        local spellID, reqLvl = data.id, data.level
        local spellName      = select(1, GetSpellInfo(spellID))
        local row, col       = floor((i-1)/cols), (i-1)%cols

        local btnName = parentFrame:GetName().."PrayerBtn"..i
        local btn = CreateFrame("Button", btnName, parentFrame, "WORSSpellTemplate")
        btn:SetSize(size, size)
        btn:SetPoint("TOPLEFT", parentFrame, "TOPLEFT",
                     XOffset + margin + (size + padX) * col,
                     -YOffset   - margin - (size + padY) * row)
        btn:SetID(spellID)



        -- 1) hide the XML template's own Icon region
        local tmplIcon = _G[btnName.."Icon"]
        if tmplIcon then tmplIcon:SetTexture(nil) end

        -- 2) create *your* icon on ARTWORK layer
        local myIcon = btn:CreateTexture(nil, "ARTWORK")
        myIcon:SetAllPoints(btn)
        myIcon:SetTexture(data.icon)
        btn.icon = myIcon

        -- clear any leftover count text
        local count = _G[btnName.."Count"]
        if count then count:SetText("") end

        -- initial color & possible buff swap
        if prayerLevel < reqLvl then
            myIcon:SetVertexColor(0.25, 0.25, 0.25)
        elseif UnitPower("player", 0) < 200 then
            myIcon:SetVertexColor(0.5, 0.5, 0.5)
        elseif UnitBuff("player", spellName) then
            myIcon:SetTexture(data.buffIcon)
            myIcon:SetVertexColor(1, 1, 1)
        else
            myIcon:SetVertexColor(1, 1, 1)
        end

        -- stash for refresh
        btn.prayerData = data

        -- drag-to-pickup
        btn:RegisterForDrag("LeftButton")
        btn:SetScript("OnDragStart", function()
            PickupSpell(spellName)
        end)

        -- tooltip
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
		
        -- throttled OnUpdate to reapply icon/color logic
        btn:SetScript("OnUpdate", function(self, elapsed)
            self._throttle = (self._throttle or 0) + elapsed
            if self._throttle < 0.25 then return end
            self._throttle = 0

            if prayerLevel < reqLvl then
                myIcon:SetTexture(data.icon)
                myIcon:SetVertexColor(0.25, 0.25, 0.25)
            elseif UnitPower("player", 0) < 200 then
                myIcon:SetTexture(data.icon)
                myIcon:SetVertexColor(0.5, 0.5, 0.5)
            elseif UnitBuff("player", spellName) then
                myIcon:SetTexture(data.buffIcon)
                myIcon:SetVertexColor(1, 1, 1)
            else
                myIcon:SetTexture(data.icon)
                myIcon:SetVertexColor(1, 1, 1)
            end
        end)

        tinsert(prayerButtons, btn)
    end
end

