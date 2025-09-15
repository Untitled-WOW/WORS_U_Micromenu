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
	Smithing  = 3273,
}


-- Explicit icon paths per skill
local WORS_SkillIcons = {
    ["Attack"]        = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\attack",
    ["Hitpoints"]     = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\hitpoints",
    ["Mining"]        = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\mining",
    ["Strength"]      = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\strength",
    ["Agility"]       = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\agility",
    ["Smithing"]      = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\smithing",
    ["Defence"]       = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\defence",
    ["Herblore"]      = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\herblore",
    ["Fishing"]       = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\fishing",
    ["Ranged"]        = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\ranged",
    ["Thieving"]      = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\thieving",
    ["Cooking"]       = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\cooking",
    ["Prayer"]        = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\prayer",
    ["Crafting"]      = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\crafting",
    ["Firemaking"]    = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\firemaking",
    ["Magic"]         = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\magic",
    ["Fletching"]     = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\fletching",
    ["Woodcutting"]   = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\woodcutting",
    ["Runecrafting"]  = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\runecraft",
    ["Slayer"]        = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\slayer",
    ["Farming"]       = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\farming",
    ["Construction"]  = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\construction",
    ["Hunter"]        = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\hunter",
   -- ["Dungeoneering"] = "Interface\\Icons\\dungeoneering",
    ["Dungeoneering"] = "Interface\\AddOns\\MicroMenu\\Textures\\SkillsIcon\\dungeoneering",
}
-- ===================================================================

-- WORS_U_SkillsBook = WORS_U_SkillsBook or {}
-- WORS_U_SkillsBook.frame = CreateFrame("Frame", "WORS_U_SkillsBookFrame", UIParent, "OldSchoolFrameTemplate")
WORS_U_SkillsBook.frame:SetSize(192, 304)
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

WORS_U_SkillsBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SkillsBook.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	SaveFramePosition(self) 
end)

WORS_U_SkillsBook.frame.CloseButton:ClearAllPoints()
WORS_U_SkillsBook.frame.CloseButton:SetPoint("TOPRIGHT", WORS_U_SkillsBook.frame, "TOPRIGHT", 4, 4)

-- ---------- Layout constants ----------
local CAP      = 99
local BUTTON_W = 59
local BUTTON_H = 30
local PADDING  = 0
local COLS     = 3
local START_X  = 7
local START_Y  = -10
-- --------------------------------------

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
		for _, id in pairs(Enum.WORSSkills) do table.insert(tmp, id) end
		table.sort(tmp)
		order = tmp
	end
	return order
end

-- Pick icon: override table first (by id or name), else embedded icon in faction name, else question mark
local function GetIconForSkill(factionID)
	-- direct id override
	if WORS_SkillIcons and WORS_SkillIcons[factionID] then
		return WORS_SkillIcons[factionID]
	end
	-- name override
	if type(WORS_SkillIcons) == "table" then
		for key, path in pairs(WORS_SkillIcons) do
			if type(key) == "string" then
				local id = ResolveSkillID(key)
				if id and id == factionID then return path end
			end
		end
	end
	-- embedded icon in faction name (|T...|t Name)
	local name = GetFactionInfoByID(factionID)
	if name then
		local embedded = name:match("|T([^:|]+):")
		if embedded then return embedded end
	end
	return "Interface\\Icons\\INV_Misc_QuestionMark"
end


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

    -- helper
    local function hasCats(id)
        local cats = DBCSkillGuide and DBCSkillGuide.GetCategoriesForSkill and DBCSkillGuide.GetCategoriesForSkill(id)
        return type(cats) == "table" and #cats > 0
    end

    -- candidates: factionID, then mapped skillLineID
    local candidates = { factionID }
    local map = Enum and Enum.WORSSkillToSkillLine and Enum.WORSSkillToSkillLine[factionID]
    if map then table.insert(candidates, map) end

    for _, id in ipairs(candidates) do
        if hasCats(id) then
            -- toggle logic: if guide is already showing this skill, hide it
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


-- Create/rebuild buttons in chosen order (+ inject TOTAL box after skipping 2 slots)
function WORS_U_SkillsBook:RefreshConfig()
    -- Create table on first run
    if not self._skillButtons then self._skillButtons = {} end

    local ids = BuildResolvedOrder()
    table.insert(ids, "__SKIP__")
    table.insert(ids, "__SKIP__")
    table.insert(ids, "__TOTAL__")

    local row, col = 0, 0
    local index = 1

    for _, entry in ipairs(ids) do
        if entry == "__SKIP__" then
            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end

        elseif entry == "__TOTAL__" then
            local btnData = self._skillButtons[index]
            local btn = btnData and btnData.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "OldSchoolButtonTemplate")
                btn:SetSize(BUTTON_W, BUTTON_H)

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
                    local totalLevel, totalXP = WORSSkillsUtil.GetTotalLevel()
                    GameTooltip:SetText("Total level", 1, 1, 1)
                    GameTooltip:SetText(("Total Level: |cFFFFFFFF%s|r"):format(BreakUpLargeNumbers(totalLevel or 0)), 1, 1, 1)
                    GameTooltip:AddLine(("Total XP: |cFFFFFFFF%s|r"):format(BreakUpLargeNumbers(totalXP or 0)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", GameTooltip_Hide)
            end

            self.totalBox = btn
            self._skillButtons[index] = { btn = btn, id = "__TOTAL__" }

            local ok, lvl = pcall(WORSSkillsUtil.GetTotalLevel)
            btn.Label:SetText(("Total level:\n %d"):format(ok and lvl or 0))

            col = col + 1
            if col >= COLS then col = 0; row = row + 1 end
            index = index + 1

        else
            local factionID = entry
            local btnData = self._skillButtons[index]
            local btn = btnData and btnData.btn
            if not btn then
                btn = CreateFrame("Button", nil, self.frame, "OldSchoolButtonTemplate")
                btn:SetSize(BUTTON_W, BUTTON_H)

                local icon = btn:CreateTexture(nil, "ARTWORK")
                icon:SetSize(28, 28)
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
                    local skillName = (GetFactionInfoByID(factionID) or ""):match("([^|]+)$"):match("(%S+)$")
                    if button == "LeftButton" then
                        local spellID = WORS_SkillCraftUI[skillName]
                        if spellID then
                            CastSpellByID(spellID)
                        else
                            OpenSkillGuideSafe(factionID)
                        end
                    elseif button == "RightButton" then
                        OpenSkillGuideSafe(factionID)
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
                    local cleanSkillName = (GetFactionInfoByID(factionID) or ""):match("([^|]+)$"):match("(%S+)$")
                    if cleanSkillName and WORS_SkillCraftUI[cleanSkillName] then
                        GameTooltip:AddLine("Left: Crafting UI",  0, 1, 0)
                        GameTooltip:AddLine("Right: Skill Guide", 0, 1, 0)
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
            btn.CurFS:SetText(buffedLevel or 0)
            btn.CapFS:SetText(currentLevel or 0)

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
end



function WORS_U_SkillsBook:RefreshValues()
    if not self._skillButtons then return end

    for _, e in ipairs(self._skillButtons) do
        if e.id == "__TOTAL__" then
            if self.totalBox and self.totalBox.Label then
                local totalLevel = 0
                local ok, lvl = pcall(WORSSkillsUtil.GetTotalLevel)
                if ok and lvl then totalLevel = lvl end
                self.totalBox.Label:SetText(("Total level:\n %d"):format(totalLevel or 0))
            end

        else
            -- 🩺 Hitpoints: show current / max HP
            if e.id == ResolveSkillID("Hitpoints") then
                local hp, hpMax = UnitHealth("player"), UnitHealthMax("player")
                if e.btn.CurFS then e.btn.CurFS:SetText(hp or 0) end
                if e.btn.CapFS then e.btn.CapFS:SetText(hpMax or 0) end

            -- 💙 Prayer: show current / max mana (in thousands)
            elseif e.id == ResolveSkillID("Prayer") then
                local mp, mpMax = UnitPower("player", 0), UnitPowerMax("player", 0)
                local mpK    = math.ceil((mp or 0) / 1000)
                local mpMaxK = math.ceil((mpMax or 0) / 1000)
                if e.btn.CurFS then e.btn.CurFS:SetText(mpK or 0) end
                if e.btn.CapFS then e.btn.CapFS:SetText(mpMaxK or 0) end

            -- 🟡 Default: all other skills from WORSSkillsUtil
            else
                local _, _, buffedLevel, currentLevel = WORSSkillsUtil.GetSkillInfo(e.id)
                if e.btn.CurFS then e.btn.CurFS:SetText(buffedLevel or 0) end
                if e.btn.CapFS then e.btn.CapFS:SetText(currentLevel or 0) end
                if e.btn.Icon  then e.btn.Icon:SetTexture(GetIconForSkill(e.id)) end
            end
        end
    end
end




-- Build on first open; then refresh values on every open
WORS_U_SkillsBook.frame:HookScript("OnShow", function()
	if not WORS_U_SkillsBook._skillButtons or #WORS_U_SkillsBook._skillButtons == 0 then
		WORS_U_SkillsBook:RefreshConfig()
	end
	-- ensure totals (and icons/levels) are populated on the very first open
	WORS_U_SkillsBook:RefreshValues()
end)


-- keep micro state in sync (same as your other frames)
local function UpdateSkillsMicroVisual()
	if WORS_U_SkillsBook.frame:IsShown() then
		SkillsMicroButton:SetButtonState("PUSHED", true)
	else
		SkillsMicroButton:SetButtonState("NORMAL")
	end
end
WORS_U_SkillsBook.frame:HookScript("OnShow", UpdateSkillsMicroVisual)
WORS_U_SkillsBook.frame:HookScript("OnHide", UpdateSkillsMicroVisual)


hooksecurefunc("UpdateMicroButtons", function()
	UpdateSkillsMicroVisual()
end)


-- === Live updates when reputation changes (drives skills) ===
local function RefreshSkillsAndTooltip()
	-- Update numbers/icons
	if WORS_U_SkillsBook and WORS_U_SkillsBook.RefreshValues then
		WORS_U_SkillsBook:RefreshValues()
	end

	-- If user is hovering a skill/total button, rebuild that tooltip live
	local owner = GameTooltip and GameTooltip:GetOwner()
	if owner then
		-- Try to re-fire the button's OnEnter if it has one
		local onEnter = owner:GetScript("OnEnter")
		if type(onEnter) == "function" then
			onEnter(owner)
		end
	end
end

local skillsEvt = CreateFrame("Frame")
skillsEvt:RegisterEvent("PLAYER_ENTERING_WORLD")           -- prime once
skillsEvt:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")  -- combat rep spam
skillsEvt:RegisterEvent("UNIT_HEALTH")
skillsEvt:RegisterEvent("UNIT_MANA")
skillsEvt:RegisterEvent("UNIT_AURA")
skillsEvt:SetScript("OnEvent", function()
	RefreshSkillsAndTooltip()
end)
