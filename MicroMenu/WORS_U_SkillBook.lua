-- === Configure order and icons here (IDs or Names) ==================
local WORS_SkillOrder = {
	"Attack","Hitpoints","Mining",
	"Strength","Agility","Smithing",
	"Defence","Herblore","Fishing",
	"Ranged","Thieving","Cooking",
	"Prayer","Crafting","Firemaking",
	"Magic","Fletching","Woodcutting",
	"Runecrafting","Slayer","Farming",
	"Construction","Hunter","Dungeoneering"
}
-- skills with crafting ui reference to its spell id
local WORS_SkillCraftUI = {
	Cooking   = 2550,
	Crafting  = 2018,
	Fletching = 2259,
	Herblore  = 2108,
	Thieving  = 99266,
	Smithing  = 3273,
}

-- Explicit icon paths per skill
local WORS_SkillIcons = {
    ["Attack"]        = "Interface\\Icons\\Skills\\Attackicon",
    ["Hitpoints"]     = "Interface\\Icons\\Skills\\Hitpointsicon",
    ["Mining"]        = "Interface\\Icons\\Skills\\Miningicon",
    ["Strength"]      = "Interface\\Icons\\Skills\\Strengthicon",
    ["Agility"]       = "Interface\\Icons\\Skills\\Agilityicon",
    ["Smithing"]      = "Interface\\Icons\\Skills\\Smithingicon",
    ["Defence"]       = "Interface\\Icons\\Skills\\Defenceicon",
    ["Herblore"]      = "Interface\\Icons\\Skills\\Herbloreicon",
    ["Fishing"]       = "Interface\\Icons\\Skills\\Fishingicon",
    ["Ranged"]        = "Interface\\Icons\\Skills\\Rangedicon",
    ["Thieving"]      = "Interface\\Icons\\Skills\\Thievingicon",
    ["Cooking"]       = "Interface\\Icons\\Skills\\Cookingicon",
    ["Prayer"]        = "Interface\\Icons\\Skills\\Prayericon",
    ["Crafting"]      = "Interface\\Icons\\Skills\\Craftingicon",
    ["Firemaking"]    = "Interface\\Icons\\Skills\\Firemakingicon",
    ["Magic"]         = "Interface\\Icons\\Skills\\Magicicon",
    ["Fletching"]     = "Interface\\Icons\\Skills\\Fletchingicon",
    ["Woodcutting"]   = "Interface\\Icons\\Skills\\Woodcuttingicon",
    ["Runecrafting"]  = "Interface\\Icons\\Skills\\Runecrafticon",
    ["Slayer"]        = "Interface\\Icons\\Skills\\Slayericon",
    ["Farming"]       = "Interface\\Icons\\Skills\\Farmingicon",
    ["Construction"]  = "Interface\\Icons\\Skills\\Constructionicon",
    ["Hunter"]        = "Interface\\Icons\\Skills\\Huntericon",
    ["Dungeoneering"] = "Interface\\Icons\\Skills\\Dungeoneeringicon",
}
-- ===================================================================

-- Ensure main table exists
WORS_U_SkillsBook = WORS_U_SkillsBook or {}
WORS_U_SkillsBook.frame = WORS_U_SkillsBook.frame or CreateFrame("Frame", "WORS_U_SkillsBookFrame", UIParent, "SecureHandlerShowHideTemplate,SecureHandlerStateTemplate,OldSchoolFrameTemplate")
WORS_U_SkillsBook.frame:SetSize(192, 355)
tinsert(UISpecialFrames, "WORS_U_SkillsBookFrame")
WORS_U_SkillsBook.frame:SetFrameStrata("LOW")
WORS_U_SkillsBook.frame:SetFrameLevel(5)

local bg = WORS_U_SkillsBook.frame:CreateTexture(nil, "LOW")
WORS_U_SkillsBook.frame.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(WORS_U_SkillsBook.frame)
bg:SetHorizTile(true)
bg:SetVertTile(true)

WORS_U_SkillsBook.frame:Hide()
WORS_U_SkillsBook.frame:SetMovable(true)
WORS_U_SkillsBook.frame:EnableMouse(true)
WORS_U_SkillsBook.frame:RegisterForDrag("LeftButton")
WORS_U_SkillsBook.frame:SetClampedToScreen(true)

if WORS_U_SkillsBookFrame and WORS_U_SkillsBookFrame.CloseButton then WORS_U_SkillsBookFrame.CloseButton:ClearAllPoints() end

WORS_U_SkillsBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SkillsBook.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	if WORS_U_MicroMenuAutoClose.Skills then
		SaveMicroMenuFramePosition(self)
	else
		self:SetUserPlaced(true) 
	end
end)

if WORS_U_SkillsBook.frame.CloseButton then
    WORS_U_SkillsBook.frame.CloseButton:ClearAllPoints()
    WORS_U_SkillsBook.frame.CloseButton:SetPoint("TOPRIGHT", WORS_U_SkillsBook.frame, "TOPRIGHT", 4, 4)
end

-- ---------- Layout constants ----------
local CAP      = 99
local BUTTON_W = 59
local BUTTON_H = 30
local PADDING  = 0
local COLS     = 3
local START_X  = 7
local START_Y  = -10
-- ---- Crafting bar layout (icon-only) ----
local CRAFT_COLS = 6
local CRAFT_ICON = 26
local CRAFT_PAD  = 2
-- --------------------------------------

-- Quest Points currency id helper
function WORS_GetQuestPoints()
    return GetItemCount(201883)
end

-- Resolve a skill ID if given a name
local function ResolveSkillID(v)
	if type(v) == "number" then return v end
	if type(v) == "string" and WORSSkillsUtil and WORSSkillsUtil.GetSkillIDFromName then
		return WORSSkillsUtil.GetSkillIDFromName(v)
	end
end

-- Build display order: use WORS_SkillOrder if provided, else Enum.WORSSkills (sorted)
local function BuildResolvedOrder()
	local order = {}
	if WORS_SkillOrder and #WORS_SkillOrder > 0 then
		for _, v in ipairs(WORS_SkillOrder) do
			local id = ResolveSkillID(v)
			if id then table.insert(order, id) end
		end
	else
		local tmp = {}
		if Enum and Enum.WORSSkills then
			for _, id in pairs(Enum.WORSSkills) do table.insert(tmp, id) end
			table.sort(tmp)
			order = tmp
		end
	end
	return order
end

-- Craft bar order: alphabetical by skill name
local function BuildCraftOrder()
    local order = {}
    for name in pairs(WORS_SkillCraftUI or {}) do
        table.insert(order, name)
    end
    table.sort(order, function(a, b) return a:lower() < b:lower() end)
    return order
end

-- Pick icon: override table first (by id or name), else embedded icon, else question mark
local function GetIconForSkill(factionID)
	if WORS_SkillIcons and WORS_SkillIcons[factionID] then
		return WORS_SkillIcons[factionID]
	end
	if type(WORS_SkillIcons) == "table" then
		for key, path in pairs(WORS_SkillIcons) do
			if type(key) == "string" then
				local id = ResolveSkillID(key)
				if id and id == factionID then return path end
			end
		end
	end
	if GetFactionInfoByID then
		local name = GetFactionInfoByID(factionID)
		if name then
			local embedded = name:match("|T([^:|]+):")
			if embedded then return embedded end
		end
	end
	return "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- ===== Robust spell pickup helpers (for dragging to bars) =====
local function FindSpellbookIndexBySpell(spellID, spellName)
	local numTabs = GetNumSpellTabs and GetNumSpellTabs() or 0
	for t = 1, numTabs do
		local _, _, numSpells, off = GetSpellTabInfo(t)
		for s = 1, (numSpells or 0) do
			local idx = (off or 0) + s
			local link = GetSpellLink(idx, "spell")
			if link then
				local id = tonumber(link:match("spell:(%d+)"))
				if (spellID and id == spellID) or (spellName and GetSpellBookItemName and (GetSpellBookItemName(idx, "spell") == spellName)) then
					return idx
				end
			end
		end
	end
end

local function CursorHasAny()
	return (CursorHasSpell and CursorHasSpell())
	    or (CursorHasItem and CursorHasItem())
	    or (CursorHasMacro and CursorHasMacro())
	    or (CursorHasAction and CursorHasAction())
end

local function PickupCraftSpell(spellID)
	if not spellID then return end
	local name = GetSpellInfo(spellID)

	if C_Spell and C_Spell.PickupSpell then
		C_Spell.PickupSpell(spellID)
	end
	if not CursorHasAny() and PickupSpell then
		PickupSpell(spellID)
	end
	if not CursorHasAny() and name then
		if C_Spell and C_Spell.PickupSpell then
			C_Spell.PickupSpell(name)
		elseif PickupSpell then
			PickupSpell(name)
		end
	end
	if not CursorHasAny() then
		local idx = FindSpellbookIndexBySpell(spellID, name)
		if idx and PickupSpellBookItem then
			PickupSpellBookItem(idx, "spell")
		end
	end
end
-- ===============================================================

local function OpenSkillGuideSafe(factionID)
    if not IsAddOnLoaded("WORS_SkillGuide") then
        local ok = LoadAddOn("WORS_SkillGuide")
        if not ok then
            UIErrorsFrame:AddMessage("Cannot load WORS_SkillGuide", 1, 0, 0, 1)
            return
        end
    end

    local guide = _G.SkillGuideFrame or _G.WORS_SkillGuideFrame
    if not (guide and guide.OpenSkill) then
        UIErrorsFrame:AddMessage("SkillGuide frame not found", 1, 0, 0, 1)
        return
    end

    local function hasCats(id)
        local cats = DBCSkillGuide and DBCSkillGuide.GetCategoriesForSkill and DBCSkillGuide.GetCategoriesForSkill(id)
        return type(cats) == "table" and #cats > 0
    end

    local candidates = { factionID }
    local map = Enum and Enum.WORSSkillToSkillLine and Enum.WORSSkillToSkillLine[factionID]
    if map then table.insert(candidates, map) end

    for _, id in ipairs(candidates) do
        if hasCats(id) then
            if guide:IsShown() and guide.skillID == id then
                guide:Hide()
            else
                guide:OpenSkill(id)
            end
            return
        end
    end

    UIErrorsFrame:AddMessage("No SkillGuide data available for this skill.", 1, 0, 0, 1)
end

-- Create/rebuild buttons in chosen order (+ inject QUESTPOINTS + SLAYER + TOTAL row)
function WORS_U_SkillsBook:RefreshConfig()
    if not self._skillButtons then self._skillButtons = {} end

    local ids = BuildResolvedOrder()

    -- Inject the special row items: [QuestPoints] [Slayer] [Total]
    table.insert(ids, "__QUESTPOINTS__")
    table.insert(ids, "__SLAYER__")
    table.insert(ids, "__TOTAL__")

    local row, col = 0, 0
    local index = 1

    for _, entry in ipairs(ids) do
        if entry == "__FILLER__" then
            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end

        elseif entry == "__QUESTPOINTS__" then
            local btnData = self._skillButtons[index]
            local btn = btnData and btnData.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "OldSchoolButtonTemplate")
                btn:SetSize(BUTTON_W*0.99, BUTTON_H*0.99)

                local x = START_X + (BUTTON_W + PADDING) * col
                local y = START_Y - (BUTTON_H + PADDING) * row
                btn:SetPoint("TOPLEFT", self.frame, "TOPLEFT", x, y)

                btn:SetNormalTexture(nil)
                btn:SetPushedTexture(nil)
                btn:SetHighlightTexture(nil)
                for _, r in ipairs({ btn:GetRegions() }) do
                    if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                        r:SetTexture(nil)
                    end
                end

                local fill = btn:CreateTexture(nil, "BORDER")
                fill:SetAllPoints()
                fill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                fill:SetVertexColor(0, 0, 0, 0.95)
                btn._fill = fill

                local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                fs:SetPoint("CENTER", 0, 0)
                fs:SetTextColor(1, 1, 0)
                btn.Label = fs

                btn:SetScript("OnEnter", function(selfBtn)
                    GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
                    local qp = GetItemCount(201883) or 0
                    GameTooltip:SetText("Quest Points", 1, 1, 1)
                    GameTooltip:AddLine(("Quest Points: |cFFFFFFFF%d|r"):format(qp), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", GameTooltip_Hide)
            end

            self.questBox = btn
            self._skillButtons[index] = { btn = btn, id = "__QUESTPOINTS__" }

            local qp = GetItemCount(201883) or 0
            btn.Label:SetText(("|TInterface\\Icons\\questiconitem:16|t %d"):format(qp))

            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end
            index = index + 1

        elseif entry == "__SLAYER__" then
            local btnData = self._skillButtons[index]
            local btn = btnData and btnData.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "OldSchoolButtonTemplate")
                btn:SetSize(BUTTON_W*0.99, BUTTON_H*0.99)

                local x = START_X + (BUTTON_W + PADDING) * col
                local y = START_Y - (BUTTON_H + PADDING) * row
                btn:SetPoint("TOPLEFT", self.frame, "TOPLEFT", x, y)

                btn:SetNormalTexture(nil)
                btn:SetPushedTexture(nil)
                btn:SetHighlightTexture(nil)
                for _, r in ipairs({ btn:GetRegions() }) do
                    if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                        r:SetTexture(nil)
                    end
                end

                local fill = btn:CreateTexture(nil, "BORDER")
                fill:SetAllPoints()
                fill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                fill:SetVertexColor(0, 0, 0, 0.95)
                btn._fill = fill

                local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                fs:SetPoint("CENTER", 0, 0)
                fs:SetTextColor(1, 1, 0)
                btn.Label = fs

                btn:SetScript("OnEnter", function(selfBtn)
                    GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
                    local sp = GetItemCount(40753) or 0
                    local ss = GetItemCount(201901) or 0					
                    GameTooltip:SetText("Slayer Points", 1, 1, 1)
                    GameTooltip:AddLine(("Slayer Points: |cFFFFFFFF%d|r"):format(sp), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
					GameTooltip:AddLine(("Slayer Streak: |cFFFFFFFF%d|r"):format(ss), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", GameTooltip_Hide)
            end

            self.questBox = btn
            self._skillButtons[index] = { btn = btn, id = "__SLAYER__" }

            local sp = GetItemCount(40753) or 0
			btn.Label:SetText(("|TInterface\\Icons\\Skills\\Slayericon:16|t %d"):format(sp))

            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end
            index = index + 1

        elseif entry == "__TOTAL__" then
            local btnData = self._skillButtons[index]
            local btn = btnData and btnData.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "OldSchoolButtonTemplate")
                btn:SetSize(BUTTON_W * 0.99, BUTTON_H*0.99)

                local x = START_X + (BUTTON_W + PADDING) * col
                local y = START_Y - (BUTTON_H + PADDING) * row
                btn:SetPoint("TOPLEFT", self.frame, "TOPLEFT", x, y)

                btn:SetNormalTexture(nil)
                btn:SetPushedTexture(nil)
                btn:SetHighlightTexture(nil)
                for _, r in ipairs({ btn:GetRegions() }) do
                    if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                        r:SetTexture(nil)
                    end
                end

                local fill = btn:CreateTexture(nil, "BORDER")
                fill:SetAllPoints()
                fill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                fill:SetVertexColor(0, 0, 0, 0.95)
                btn._fill = fill

                local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                fs:SetPoint("CENTER", 0, 0)
                fs:SetTextColor(1, 1, 0)
                btn.Label = fs

                btn:SetScript("OnEnter", function(selfBtn)
                    GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
                    local ok, totalLevel, totalXP = pcall(function() return WORSSkillsUtil.GetTotalLevel() end)
                    local lvl = 0
                    local xp = 0
                    if ok and totalLevel then lvl = totalLevel end
                    if ok and totalXP then xp = totalXP end
                    GameTooltip:SetText("Total level", 1, 1, 1)
                    GameTooltip:AddLine(("Total Level: |cFFFFFFFF%s|r"):format(BreakUpLargeNumbers(lvl or 0)), 1, 1, 1)
                    if xp then
                        GameTooltip:AddLine(("Total XP: |cFFFFFFFF%s|r"):format(BreakUpLargeNumbers(xp or 0)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    end
                    GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", GameTooltip_Hide)
            end
            self.totalBox = btn
            self._skillButtons[index] = { btn = btn, id = "__TOTAL__" }
            local ok, lvl = pcall(function() return WORSSkillsUtil.GetTotalLevel() end)
            btn.Label:SetText(("Total level\n %d"):format(ok and lvl or 0))
            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end
            index = index + 1

        else
            -- regular skill button
            local factionID = entry
            local btnData = self._skillButtons[index]
            local btn = btnData and btnData.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "OldSchoolButtonTemplate")
                btn:SetSize(BUTTON_W, BUTTON_H)

                local icon = btn:CreateTexture(nil, "ARTWORK")
                icon:SetSize(25, 25)
                icon:SetPoint("LEFT", 1, 0)
                btn.Icon = icon

                local curFS = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                curFS:SetPoint("TOPRIGHT", -20, -3)
                curFS:SetTextColor(1, 1, 0)
                btn.CurFS = curFS

                local capFS = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                capFS:SetPoint("BOTTOMRIGHT", -4, 3)
                capFS:SetTextColor(1, 1, 0)
                btn.CapFS = capFS

                local slashTex = btn:CreateTexture(nil, "OVERLAY")
                slashTex:SetSize(25, 25)
                slashTex:SetPoint("CENTER", btn, "RIGHT", -18, 0)
                slashTex:SetTexture("Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\skill_slash")
                btn.SlashTex = slashTex

                btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
                btn:SetScript("OnClick", function(self, button)
                    local skillName = (GetFactionInfoByID and GetFactionInfoByID(factionID) or ""):match("([^|]+)$"):match("(%S+)$")
                    if button == "LeftButton" then
                        OpenSkillGuideSafe(factionID)
					elseif button == "RightButton" then	
						local spellID = WORS_SkillCraftUI and WORS_SkillCraftUI[skillName]
                        if spellID then
                            CastSpellByID(spellID)
                        else
                            OpenSkillGuideSafe(factionID)
                        end    
                    end
                end)

                btn:SetScript("OnEnter", function(selfBtn)
                    GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
                    local name, _, buffed, level, totalXP, nextLevelAtXP = WORSSkillsUtil.GetSkillInfo(factionID)
                    name = name or "Skill"
                    level = level or 0
                    totalXP = totalXP or 0
                    GameTooltip:SetText(("%s %d/%d"):format(name, level, CAP), 1, 1, 1)
                    GameTooltip:AddLine(("%s XP: |cFFFFFFFF%s|r"):format(name, BreakUpLargeNumbers(totalXP)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    if level < CAP and nextLevelAtXP then
                        local remaining = math.max(nextLevelAtXP - totalXP, 0)
                        GameTooltip:AddLine(("Next level at: |cFFFFFFFF%s|r"):format(BreakUpLargeNumbers(nextLevelAtXP)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                        GameTooltip:AddLine(("Remaining XP: |cFFFFFFFF%s|r"):format(BreakUpLargeNumbers(remaining)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    end
                    local cleanSkillName = (GetFactionInfoByID and GetFactionInfoByID(factionID) or ""):match("([^|]+)$"):match("(%S+)$")
                    if cleanSkillName and WORS_SkillCraftUI and WORS_SkillCraftUI[cleanSkillName] then
                        GameTooltip:AddLine("Left: Skill Guide",  0, 1, 0)
                        GameTooltip:AddLine("Right: Crafting UI", 0, 1, 0)
                    else
                        GameTooltip:AddLine("Click: Skill Guide", 0, 1, 0)
                    end
                    GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", GameTooltip_Hide)
            end

            local x = START_X + (BUTTON_W + PADDING) * col
            local y = START_Y - (BUTTON_H + PADDING) * row
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", self.frame, "TOPLEFT", x, y)

            btn.Icon:SetTexture(GetIconForSkill(factionID))

            local _, _, buffedLevel, currentLevel = WORSSkillsUtil.GetSkillInfo(factionID)
            if btn.CurFS then btn.CurFS:SetText(buffedLevel or 0) end
            if btn.CapFS then btn.CapFS:SetText(currentLevel or 0) end

            self._skillButtons[index] = { btn = btn, id = factionID }

            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end
            index = index + 1
        end
    end

    -- hide leftover buttons if the list shrank
    for i = index, #self._skillButtons do
        if self._skillButtons[i] and self._skillButtons[i].btn then
            self._skillButtons[i].btn:Hide()
        end
    end

    -- ===== Crafting bar (icon-only, alphabetical, 4 per row, draggable) =====
    if not self._craftButtons then self._craftButtons = {} end

    local craftOrder = BuildCraftOrder()
    local craftCount = #craftOrder

    -- Start position: first clean row beneath the main grid
    local mainRowsUsed = row + (col > 0 and 1 or 0)
    local baseY        = START_Y - (BUTTON_H + PADDING) * mainRowsUsed

    local craftRow, craftCol = 0, 0
    local frameW      = self.frame:GetWidth() or 192
    local innerW      = frameW - (START_X * 2)
    local rowWidth    = CRAFT_COLS * CRAFT_ICON + (CRAFT_COLS - 1) * CRAFT_PAD
    local leftover    = math.max(innerW - rowWidth, 0)
    local rowStartX   = START_X + math.floor(leftover / 2) -- centered

    local cIndex = 1
    for _, skillName in ipairs(craftOrder) do
        local spellID = WORS_SkillCraftUI and WORS_SkillCraftUI[skillName]
        if spellID then
            local cell = self._craftButtons[cIndex]
            local btn  = cell and cell.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
                btn:SetSize(CRAFT_ICON, CRAFT_ICON)
                btn:SetAttribute("type", "spell")
                btn:SetAttribute("spell", spellID)
                btn.spellID = spellID

                local icon = btn:CreateTexture(nil, "ARTWORK")
                icon:SetAllPoints()
                local iconPath = (WORS_SkillIcons and WORS_SkillIcons[skillName]) or "Interface\\Icons\\INV_Misc_QuestionMark"
                icon:SetTexture(iconPath)
                btn.Icon = icon

                btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

                -- Drag onto action bars (robust)
                btn:RegisterForDrag("LeftButton")
                btn:SetScript("OnDragStart", function(selfBtn)
                    if InCombatLockdown() then return end
                    PickupCraftSpell(selfBtn.spellID)
                end)

                -- Modified-click to pick up too
                btn:SetScript("OnClick", function(selfBtn, button)
                    if IsModifiedClick and IsModifiedClick("PICKUPACTION") then
                        if InCombatLockdown() then return end
                        PickupCraftSpell(selfBtn.spellID)
                        return
                    end
                    CastSpellByID(selfBtn.spellID)
                end)

				-- Default spell tooltip (no custom lines)
				btn:SetScript("OnEnter", function(selfBtn)
					GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
					if GameTooltip.SetSpellByID then
						GameTooltip:SetSpellByID(selfBtn.spellID)
					else
						-- Fallback for very old clients: show tooltip from spellbook slot
						local idx = FindSpellbookIndexBySpell(selfBtn.spellID, GetSpellInfo(selfBtn.spellID))
						if idx and GameTooltip.SetSpellBookItem then
							GameTooltip:SetSpellBookItem(idx, "spell")
						end
					end
					GameTooltip:Show()
				end)
				btn:SetScript("OnLeave", GameTooltip_Hide)
            end

            local x = rowStartX + (CRAFT_ICON + CRAFT_PAD) * craftCol
            local y = baseY - (CRAFT_ICON + CRAFT_PAD) * craftRow
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", self.frame, "TOPLEFT", x, y)

            self._craftButtons[cIndex] = { btn = btn, name = skillName, spellID = spellID }
            btn:Show()

            craftCol = craftCol + 1
            if craftCol >= CRAFT_COLS then craftCol = 0; craftRow = craftRow + 1 end
            cIndex = cIndex + 1
        end
    end

    -- Hide leftover craft buttons
    for i = cIndex, #self._craftButtons do
        if self._craftButtons[i] and self._craftButtons[i].btn then
            self._craftButtons[i].btn:Hide()
        end
    end

    -- Adjust frame height to fit the craft icons
    do
        local craftRowsUsed = (craftCount > 0) and math.ceil(craftCount / CRAFT_COLS) or 0
        local neededH = (-START_Y)
                      + (BUTTON_H + PADDING) * mainRowsUsed
                      + (CRAFT_ICON + CRAFT_PAD) * craftRowsUsed
                      + 16
        self.frame:SetHeight(math.max(self.frame:GetHeight() or 0, neededH))
    end
end

function WORS_U_SkillsBook:RefreshValues()
    if not self._skillButtons then return end

    for _, e in ipairs(self._skillButtons) do
        if e.id == "__TOTAL__" then
            if self.totalBox and self.totalBox.Label then
                local totalLevel = 0
                local ok, lvl = pcall(function() return WORSSkillsUtil.GetTotalLevel() end)
                if ok and lvl then totalLevel = lvl end
                self.totalBox.Label:SetText(("Total level:\n %d"):format(totalLevel or 0))
            end

        elseif e.id == "__QUESTPOINTS__" then
            if self.questBox and self.questBox.Label then
                local qp = GetItemCount(201883) or 0
                self.questBox.Label:SetText(("|TInterface\\Icons\\questiconitem:16|t %d"):format(qp))
            end
			
		elseif e.id == "__SLAYER__" then
            if self.questBox and self.questBox.Label then
                local sp = GetItemCount(40753) or 0
                self.questBox.Label:SetText(("|TInterface\\Icons\\Skills\\Slayericon:16|t %d"):format(sp))
            end

        elseif e.id == ResolveSkillID("Hitpoints") then
            local hp, hpMax = UnitHealth("player"), UnitHealthMax("player")
            if e.btn and e.btn.CurFS then e.btn.CurFS:SetText(hp or 0) end
            if e.btn and e.btn.CapFS then e.btn.CapFS:SetText(hpMax or 0) end

        elseif e.id == ResolveSkillID("Prayer") then
            local mp, mpMax = UnitPower("player", 0), UnitPowerMax("player", 0)
            local mpK    = math.ceil((mp or 0) / 1000)
            local mpMaxK = math.ceil((mpMax or 0) / 1000)
            if e.btn and e.btn.CurFS then e.btn.CurFS:SetText(mpK or 0) end
            if e.btn and e.btn.CapFS then e.btn.CapFS:SetText(mpMaxK or 0) end

        else
            local ok, info1, info2, buffedLevel, currentLevel = pcall(WORSSkillsUtil.GetSkillInfo, e.id)
            if ok then
                if e.btn and e.btn.CurFS then e.btn.CurFS:SetText(buffedLevel or 0) end
                if e.btn and e.btn.CapFS then e.btn.CapFS:SetText(currentLevel or 0) end
                if e.btn and e.btn.Icon then e.btn.Icon:SetTexture(GetIconForSkill(e.id)) end
            end
        end
    end
end

-- Build on first open; then refresh values on every open
WORS_U_SkillsBook.frame:HookScript("OnShow", function()
	if not WORS_U_SkillsBook._skillButtons or #WORS_U_SkillsBook._skillButtons == 0 then
		WORS_U_SkillsBook:RefreshConfig()
	end
	WORS_U_SkillsBook:RefreshValues()
end)

-- keep micro state in sync (same as your other frames)
local function UpdateSkillsMicroVisual()
	if WORS_U_SkillsBook.frame:IsShown() then
		if SkillsMicroButton and SkillsMicroButton.SetButtonState then SkillsMicroButton:SetButtonState("PUSHED", true) end
	else
		if SkillsMicroButton and SkillsMicroButton.SetButtonState then SkillsMicroButton:SetButtonState("NORMAL") end
	end
end
WORS_U_SkillsBook.frame:HookScript("OnShow", UpdateSkillsMicroVisual)
WORS_U_SkillsBook.frame:HookScript("OnHide", UpdateSkillsMicroVisual)

hooksecurefunc("UpdateMicroButtons", function()
	UpdateSkillsMicroVisual()
end)

-- === Live updates when reputation/health/auras/etc change (drives skills) ===
local function RefreshSkillsAndTooltip()
    if WORS_U_SkillsBook and WORS_U_SkillsBook.RefreshValues then
        WORS_U_SkillsBook:RefreshValues()
    end

    local owner = GameTooltip and GameTooltip:GetOwner()
    if owner then
        local onEnter = (owner.GetScript and owner:GetScript("OnEnter"))
        if type(onEnter) == "function" then
            onEnter(owner)
        end
    end
end

local skillsEvt = CreateFrame("Frame")
skillsEvt:RegisterEvent("PLAYER_ENTERING_WORLD")
skillsEvt:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
skillsEvt:RegisterEvent("UNIT_HEALTH")
skillsEvt:RegisterEvent("UNIT_MANA")
skillsEvt:RegisterEvent("UNIT_AURA")
skillsEvt:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
		if WORS_U_SkillsBook.frame and not WORS_U_SkillsBook.frame:IsUserPlaced() then
			if WORS_U_MicroMenuAutoClose and WORS_U_MicroMenuAutoClose.AutoClosePOS then
				ApplyMicroMenuSavedPosition()
			else
				WORS_U_SkillsBook.frame:ClearAllPoints()
				WORS_U_SkillsBook.frame:SetPoint("RIGHT", UIParent, "RIGHT", -140, 48)
				WORS_U_SkillsBook.frame:SetUserPlaced(true)
			end
		end
	else
		RefreshSkillsAndTooltip()
	end
end)

local closeButton = CreateFrame("Button", nil, WORS_U_SkillsBook.frame, "SecureHandlerClickTemplate")
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_SkillsBook.frame, "TOPRIGHT", 4, 4)
WORS_U_SkillsBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetFrameRef("uSkillsBook", WORS_U_SkillsBook.frame)
closeButton:SetAttribute("_onclick", [=[
    local uSkillsBook = self:GetFrameRef("uSkillsBook")
    uSkillsBook:Hide()
]=])

-- =========================
-- Secure Toggle
-- =========================
local SkillsMicroMenuToggle = CreateFrame("Button", "WORS_USkillsBook_Toggle", UIParent, "SecureHandlerClickTemplate")
if SkillsMicroButton then
	WORS_USkillsBook_Toggle:ClearAllPoints()
	WORS_USkillsBook_Toggle:SetParent(SkillsMicroButton)
	WORS_USkillsBook_Toggle:SetAllPoints(SkillsMicroButton)
	WORS_USkillsBook_Toggle:SetFrameStrata(SkillsMicroButton:GetFrameStrata())
	WORS_USkillsBook_Toggle:SetFrameLevel(SkillsMicroButton:GetFrameLevel() + 1)
	WORS_USkillsBook_Toggle:RegisterForClicks("AnyUp")
	if SkillsMicroButton:GetScript("OnEnter") then
		WORS_USkillsBook_Toggle:SetScript("OnEnter", function()
			SkillsMicroButton:GetScript("OnEnter")(SkillsMicroButton)
		end)
	end
	if SkillsMicroButton:GetScript("OnLeave") then
		WORS_USkillsBook_Toggle:SetScript("OnLeave", function()
			SkillsMicroButton:GetScript("OnLeave")(SkillsMicroButton)
		end)
	end
end

SkillsMicroMenuToggle:RegisterForClicks("AnyUp")
SkillsMicroMenuToggle:SetFrameRef("uSkillsBook", WORS_U_SkillsBook.frame)
SkillsMicroMenuToggle:SetAttribute("_onclick", [=[
	local f = self:GetFrameRef("uSkillsBook")
	if not f then return end
	if not f:IsShown() then
		f:Show()
	else
		f:Hide()
	end
]=])

SkillsMicroMenuToggle:SetScript("PostClick", function(self, button, down)
	if WORS_U_MicroMenuAutoClose.Skills then
		if WORS_U_MicroMenuAutoClose.Backpack and Backpack and Backpack:IsShown() then
			Backpack:Hide()
		end
		if WORS_U_MicroMenuAutoClose.CombatStyle and CombatStylePanel and CombatStylePanel:IsShown() then
			CombatStylePanel:Hide()
		end
		if WORS_U_MicroMenuAutoClose.Prayer and WORS_U_PrayBookFrame and WORS_U_PrayBookFrame:IsShown() then
			WORS_U_PrayBookFrame:Hide()
		end
		if WORS_U_MicroMenuAutoClose.Magic and WORS_U_SpellBookFrame and WORS_U_SpellBookFrame:IsShown() then
			WORS_U_SpellBookFrame:Hide()
		end
		if WORS_U_MicroMenuAutoClose.Equipment and WORS_U_EquipmentBookFrame and WORS_U_EquipmentBookFrame:IsShown() then
			WORS_U_EquipmentBookFrame:Hide()
		end
		if WORS_U_MicroMenuAutoClose.Emotes and EmoteBookFrame and EmoteBookFrame:IsShown() then
			EmoteBookFrame:Hide()
		end
	end
end)

-- =========================
-- Keybind Secure Toggle 
-- =========================
local kb = CreateFrame("Frame")
kb:RegisterEvent("PLAYER_LOGIN")
kb:RegisterEvent("UPDATE_BINDINGS")
kb:RegisterEvent("PLAYER_REGEN_ENABLED")
kb:SetScript("OnEvent", function(self, event)
	if InCombatLockdown() then
		self.need = true
		return
	end
	local k1, k2 = GetBindingKey("TOGGLESKILLS")
	if k1 then SetOverrideBindingClick(UIParent, true, k1, "WORS_USkillsBook_Toggle", "LeftButton") end
	if k2 then SetOverrideBindingClick(UIParent, true, k2, "WORS_USkillsBook_Toggle", "LeftButton") end
	if event == "PLAYER_REGEN_ENABLED" then
		self.need = nil
	end
end)
