-- -- WORS_U_MicroMenuButtons.lua
-- local MicroButtonContainer = nil
-- local microBackup = {}

-- -- 1) Create a new micro-menu-style button by inheriting WORS template
-- U_SpellMicroMenuButton = CreateFrame("Button", "U_SpellBookMicroButtonCopy", SpellbookMicroButton:GetParent(), "MicroMenuButtonTemplate", 1)
-- U_SpellMicroMenuButton:ClearAllPoints()
-- U_SpellMicroMenuButton.Icon:SetTexture("Interface\\Icons\\magicicon")
-- U_SpellMicroMenuButton.Icon:ClearAllPoints()
-- U_SpellMicroMenuButton.Icon:SetPoint("CENTER", 0, 0)
-- U_SpellMicroMenuButton.Icon:SetSize(24, 24)
-- U_SpellMicroMenuButton.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
-- U_SpellMicroMenuButton:SetFrameStrata("MEDIUM")	-- 3) (Optional) tweak strata/level so it doesn’t sit under something else
-- U_SpellMicroMenuButton:SetFrameLevel(SpellbookMicroButton:GetFrameLevel())

-- U_SpellMicroMenuButton:HookScript("OnEnter", function(self)
    -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT")    -- anchor the tooltip below the button
    -- GameTooltip:SetText("Magic", 1, 1, 1, 1, true) -- white text, wrap if needed
	-- GameTooltip:AddLine("Open Magic menu for spells, to open WOW spell book ui click Spellbook & Abilities", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
    -- GameTooltip:Show()
-- end)

-- local microButtonsRow1TOP = 	{CombatStyleMicroButton, SkillsMicroButton, QuestsMicroButton, InventoryMicroButton, CharacterMicroButton, PrayerMicroButton, U_SpellBookMicroButtonCopy}
-- local microButtonsRow2BOTTOM = 	{SocialMicroButton, SpellbookMicroButton, AchievementsMicroButton, GameMenuMicroButton, CompanionsMicroButton, EmotesMicroButton, MusicMicroButton}

-- -- function to take backup a micromenu button default location
-- local function safeBackup(btn)
    -- local point, rel, relPoint, x, y = btn:GetPoint()
    -- if point and rel then
        -- return {
            -- parent = btn:GetParent(),
            -- point = point,
            -- rel = rel,
            -- relPoint = relPoint,
            -- x = x,
            -- y = y
        -- }
    -- end
-- end

-- -- function to restore mictomenu buttons to 
-- local function safeRestore(btn, data)
    -- if data then
        -- btn:SetParent(data.parent)
        -- btn:ClearAllPoints()
        -- btn:SetPoint(data.point, data.rel, data.relPoint, data.x, data.y)
		
		-- btn:SetFrameStrata("MEDIUM")	-- 3) (Optional) tweak strata/level so it doesn’t sit under something else
    -- end
	-- IgnoreMicroButton:Hide()	
-- end

-- -- function to backup all micro menu button location
-- local function BackupOriginalMicroButtonPositions()
    -- for _, btn in ipairs(microButtonsRow1TOP) do
        -- if btn and not microBackup[tostring(btn)] then
            -- microBackup[tostring(btn)] = safeBackup(btn)
        -- end
    -- end
    -- for _, btn in ipairs(microButtonsRow2BOTTOM) do
        -- if btn and not microBackup[tostring(btn)] then
            -- microBackup[tostring(btn)] = safeBackup(btn)
        -- end
    -- end
-- end


-- -- function to attach micromenu button rows to a frame
-- local function AttachMicroRow(buttons, anchorPoint, xOffset, yOffset)
    -- local spacing = 30
    -- local validButtons = {}

    -- for _, btn in ipairs(buttons) do
        -- if btn and btn:IsObjectType("Button") then
            -- table.insert(validButtons, btn)
        -- end
    -- end

    -- local totalWidth = spacing * (#validButtons - 1)
    -- local startX = -(totalWidth / 2)

    -- for i, btn in ipairs(validButtons) do
        -- local key = tostring(btn)
        -- if not microBackup[key] or not microBackup[key].point then
            -- microBackup[key] = safeBackup(btn)
        -- end
        -- btn:SetParent(MicroButtonContainer)
        -- btn:ClearAllPoints()
        -- -- compute x including the new xOffset
        -- local x = startX + (i - 1) * spacing + (xOffset or 0)
        -- btn:SetPoint(anchorPoint, MicroButtonContainer, anchorPoint, x, yOffset or 0)

    -- end
-- end




-- -- function to attach micromenu button rows to a frame
-- function AttachMicroButtonsTo(parentFrame)
    -- if not parentFrame then return end
    -- -- determine if this is the CombatStyle panel
    -- local name = parentFrame:GetName()
    -- local isCombatStylePannel = (name == "CombatStylePanel")

    -- -- create or re-parent the container frame
    -- if not MicroButtonContainer then
        -- MicroButtonContainer = CreateFrame("Frame", "WORS_U_MicroButtonContainer", parentFrame)
        -- MicroButtonContainer:SetSize(210, 400)
        -- MicroButtonContainer:SetPoint("TOP", parentFrame, "TOP", 0, 50)
    -- else
        -- MicroButtonContainer:SetParent(parentFrame)
        -- MicroButtonContainer:ClearAllPoints()
        -- MicroButtonContainer:SetPoint("TOP", parentFrame, "TOP", 0, 40)
        
		-- MicroButtonContainer:Show()
    -- end
	
    -- -- attach each row of micro buttons
	-- -- remove -16 x offset on row 2 if going back to 7 buttons top and 7 buttons bottom
    -- AttachMicroRow(microButtonsRow1TOP, "TOP", 0, 8)
    -- --AttachMicroRow(microButtonsRow2BOTTOM, "BOTTOM", -16, -8)
	-- AttachMicroRow(microButtonsRow2BOTTOM, "BOTTOM", 0, -8)

-- end

-- -- helper: lay out a row of buttons on *any* container frame
-- local function AttachRowToContainer(buttons, container, anchorPoint, xOffset, yOffset)
    -- local spacing = 30
    -- local valid = {}
    -- for _, btn in ipairs(buttons) do
        -- if btn and btn:IsObjectType("Button") then
            -- table.insert(valid, btn)
        -- end
    -- end
    -- local totalW = spacing * (#valid - 1)
    -- local startX = -(totalW / 2)
    -- for i, btn in ipairs(valid) do
        -- btn:SetParent(container)
        -- btn:ClearAllPoints()
        -- local x = startX + (i - 1) * spacing + (xOffset or 0)
        -- btn:SetPoint(anchorPoint, container, anchorPoint, x, yOffset or 0)
		-- btn:SetFrameStrata("MEDIUM")	-- 3) (Optional) tweak strata/level so it doesn’t sit under something else
		-- btn:SetClampedToScreen(true)
    -- end
-- end


-- function RestoreMicroButtonsFromMicroMenu()
    -- local candidateFrames = {WORS_U_SpellBookFrame, WORS_U_PrayBookFrame, WORS_U_EmoteBookFrame, CombatStylePanel, Backpack}
    -- local target = nil
    -- for _, f in ipairs(candidateFrames) do
        -- if f and f:IsShown() then
            -- target = f
            -- break
        -- end
    -- end

    -- if target then
        -- -- panel is open → use your container & rows as before
        -- AttachMicroButtonsTo(target)
    -- else
        -- -- default view → hide your special container
        -- if MicroButtonContainer then
            -- MicroButtonContainer:Hide()
        -- end

        -- -- find the Blizzard‐original parent of the first top‐row button:
        -- -- (we backed that up at login)
        -- local backup = microBackup[tostring(microButtonsRow1TOP[1])]
        -- local origParent = backup and backup.parent or UIParent
		
		-- if MyViewportFrame then
			-- AttachRowToContainer(microButtonsRow1TOP,    MyViewportFrame, "BOTTOMRIGHT", -134, 35)
			-- AttachRowToContainer(microButtonsRow2BOTTOM, MyViewportFrame, "BOTTOMRIGHT", -134, 0)
		-- else
			-- AttachRowToContainer(microButtonsRow1TOP,    UIParent, "BOTTOMRIGHT", -134, 35)
			-- AttachRowToContainer(microButtonsRow2BOTTOM, UIParent, "BOTTOMRIGHT", -134, 0)
		-- end
		-- IgnoreMicroButton:Hide()
    -- end
-- end

-- -- Initialize backups after entering the world
-- local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_ENTERING_WORLD")
-- f:SetScript("OnEvent", function()
    -- C_Timer.After(1, BackupOriginalMicroButtonPositions)
-- end)

-- -- hocks into UpdateMicroButtons to ensure buttons dont get reset to default location
-- hooksecurefunc("UpdateMicroButtons", function()
    -- if MicroButtonContainer and MicroButtonContainer:IsShown() then
        -- AttachMicroButtonsTo(MicroButtonContainer:GetParent())
    -- else
        -- RestoreMicroButtonsFromMicroMenu()
    -- end
-- end)
