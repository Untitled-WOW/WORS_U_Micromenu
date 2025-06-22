-- WORS_U_PrayBook.lua

-- Function to initialize Prayer level from rep
local factionID = 1170
local prayerLevel = 1
local function InitializePrayerLevel()
    prayerLevel = GetLevelFromFactionReputation(factionID)
end

local prayerButtons = {}

local function SetupPrayerButtons()
    if InCombatLockdown() then return end

    -- clear old buttons
    for _, btn in pairs(prayerButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(prayerButtons)

    local buttonSize, padding, margin, columns = 35, 2, 5, 5
    for i, data in ipairs(WORS_U_PrayBook.prayers) do
        local id, reqLvl = data.id, data.level
        -- Grab the localized name just once for buff checks & tooltips
        local prayerName = select(1, GetSpellInfo(id))

        -- Create the secure button
        local btn = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureActionButtonTemplate")
        btn:SetSize(buttonSize, buttonSize)
        -- Position in grid
        local row, col = math.floor((i-1)/columns), (i-1) % columns
        btn:SetPoint("TOPLEFT",
            WORS_U_PrayBook.frame,
            "TOPLEFT",
            margin + (buttonSize+padding)*col,
            -margin - (buttonSize+padding)*row
        )
        btn:SetNormalTexture(data.icon)
        --btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

        -- Gray out if not high enough level
        local nt = btn:GetNormalTexture()
        nt:SetVertexColor(prayerLevel < reqLvl and .2 or 1, prayerLevel < reqLvl and .2 or 1, prayerLevel < reqLvl and .2 or 1)

        -- PreClick: cast or remove
        btn:SetScript("PreClick", function(self)
            if UnitBuff("player", prayerName) then
                self:SetAttribute("type","macro")
                self:SetAttribute("macrotext","/cancelaura "..prayerName)
            else
                self:SetAttribute("type","spell")
                self:SetAttribute("spell", id)
            end
        end)

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

        tinsert(prayerButtons, btn)
    end

    LoadTransparency()
end

-- Create the prayer book frame
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent)
WORS_U_PrayBook.frame:SetSize(192, 280)
WORS_U_PrayBook.frame:SetBackdrop({
    bgFile   = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile     = false, tileSize = 32, edgeSize = 32,
    insets   = { left = 5, right = 5, top = 5, bottom = 5 },
})
WORS_U_PrayBook.frame:SetFrameStrata("HIGH")
WORS_U_PrayBookFrame:SetFrameLevel(10)
WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetClampedToScreen(true)
WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Close button
local closeButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_PrayBook.frame, "TOPRIGHT", 4, 4)
WORS_U_PrayBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
    if InCombatLockdown() then
        print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
    else
        WORS_U_PrayBook.frame:Hide()
        PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
    end
end)

-- Micro button highlight update
local function UpdateButtonBackground()
    if WORS_U_PrayBook.frame:IsShown() then
        PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0)
    else
        PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
    end
end
WORS_U_PrayBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- PrayerMicroButton click handler
local function OnPrayerClick(self)
    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
    if not InCombatLockdown() then
        if pos then
            local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
            WORS_U_PrayBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
        else
            WORS_U_PrayBook.frame:SetPoint("CENTER")
        end
    else
        print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
    end

    if IsAltKeyDown() and not InCombatLockdown() then
        WORS_U_PrayBook.frame:Show()
        WORS_U_PrayBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
    elseif IsShiftKeyDown() then
        ToggleSpellBook(BOOKTYPE_SPELL)
    else
        if not InCombatLockdown() then
            if WORS_U_PrayBook.frame:IsShown() then
                WORS_U_PrayBook.frame:Hide()
            else
                InitializePrayerLevel()
                SetupPrayerButtons()
                MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)
            end
        elseif WORS_U_MicroMenuSettings.AutoCloseEnabled then
            WORS_U_EmoteBookFrame:Hide()
            WORS_U_MusicPlayerFrame:Hide()
            CombatStylePanel:Hide()
            CloseBackpack()
        end
    end
end
PrayerMicroButton:SetScript("OnClick", OnPrayerClick)
PrayerMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("Shift + Click to open WOW Spellbook.", 1, 1, 0, true)
        GameTooltip:AddLine("ALT + Click to change transparency.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)
