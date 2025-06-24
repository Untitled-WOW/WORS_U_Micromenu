-- WORS_U_MicroMenuButtons.lua

-- Holds micro button container logic shared across multiple book frames

local MicroButtonContainer = nil
local microBackup = {}

local microButtonsRow1 = {
    CombatStyleMicroButton, SkillsMicroButton, QuestsMicroButton, InventoryMicroButton,
    CharacterMicroButton, PrayerMicroButton, SpellbookMicroButton
}
local microButtonsRow2 = {
    SocialMicroButton, IgnoreMicroButton, AchievementsMicroButton, GameMenuMicroButton,
    CompanionsMicroButton, EmotesMicroButton, MusicMicroButton
}

local function safeBackup(btn)
    local point, rel, relPoint, x, y = btn:GetPoint()
    if point and rel then
        return {
            parent = btn:GetParent(),
            point = point,
            rel = rel,
            relPoint = relPoint,
            x = x,
            y = y
        }
    end
end

local function safeRestore(btn, data)
    if data then
        btn:SetParent(data.parent)
        btn:ClearAllPoints()
        btn:SetPoint(data.point, data.rel, data.relPoint, data.x, data.y)
    end
end

local function BackupOriginalMicroButtonPositions()
    for _, btn in ipairs(microButtonsRow1) do
        if btn and not microBackup[tostring(btn)] then
            microBackup[tostring(btn)] = safeBackup(btn)
        end
    end
    for _, btn in ipairs(microButtonsRow2) do
        if btn and not microBackup[tostring(btn)] then
            microBackup[tostring(btn)] = safeBackup(btn)
        end
    end
end

local function AttachMicroRow(buttons, anchorPoint, yOffset)
    local spacing = 30
    local validButtons = {}

    for _, btn in ipairs(buttons) do
        if btn and btn:IsObjectType("Button") then
            table.insert(validButtons, btn)
        end
    end

    local totalWidth = spacing * (#validButtons - 1)
    local startX = -(totalWidth / 2)

    for i, btn in ipairs(validButtons) do
        local key = tostring(btn)
        if not microBackup[key] or not microBackup[key].point then
            microBackup[key] = safeBackup(btn)
        end
        btn:SetParent(MicroButtonContainer)
        btn:ClearAllPoints()
        local x = startX + (i - 1) * spacing
        btn:SetPoint(anchorPoint, MicroButtonContainer, anchorPoint, x, yOffset)
    end
end

function AttachMicroButtonsTo(parentFrame)
    if not parentFrame then return end

    -- determine if this is the CombatStyle panel
    local name = parentFrame:GetName()
    local isStylePanel = (name == "CombatStylePannel" or name == "CombatStylePanel")

    -- create or re-parent the container frame
    if not MicroButtonContainer then
        MicroButtonContainer = CreateFrame("Frame", "WORS_U_MicroButtonContainer", parentFrame)
        MicroButtonContainer:SetSize(210, 400)
        MicroButtonContainer:SetPoint("TOP", parentFrame, "TOP", 0, 50)
        MicroButtonContainer:SetBackdrop({
			bgFile = "Interface\\AddOns\\MicroMenu\\Textures\\MenuBG_Test_256x512CROP - Copy.tga"
        })
        MicroButtonContainer:SetBackdropColor(1, 1, 1, 1)
		MicroButtonContainer:SetMovable(true)
		MicroButtonContainer:EnableMouse(true)
		MicroButtonContainer:RegisterForDrag("LeftButton")
		MicroButtonContainer:SetClampedToScreen(true)	
		MicroButtonContainer:SetScript("OnDragStart", function(self) 			
			local parent = self:GetParent()
			if parent then
				parent:StartMoving()
			end
		end)
		MicroButtonContainer:SetScript("OnDragStop", function(self)
			local parent = self:GetParent()
			if parent then
				parent:StopMovingOrSizing()		
				SaveFramePosition(parent)

			end		
		end)		
    else
        MicroButtonContainer:SetParent(parentFrame)
        MicroButtonContainer:ClearAllPoints()
        MicroButtonContainer:SetPoint("TOP", parentFrame, "TOP", 0, 40)
        MicroButtonContainer:Show()
    end

    -- attach each row of micro buttons
    AttachMicroRow(microButtonsRow1, "TOP", 0)
    AttachMicroRow(microButtonsRow2, "BOTTOM", -8)

    -- if we're on the CombatStyle panel, bump its strata/level above the background
    if isStylePanel then
        -- push the background container *down*
        MicroButtonContainer:SetFrameStrata("HIGH")
        MicroButtonContainer:SetFrameLevel(0)

        -- lift the panel itself *way* up
        parentFrame:SetFrameStrata("HIGH")
        parentFrame:SetFrameLevel(1)
        parentFrame:Raise()
    end
end

function RestoreMicroButtonsFromMicroMenu()
    -- List all frames that can use the micro buttons
    local candidateFrames = {WORS_U_SpellBookFrame, WORS_U_PrayBookFrame, WORS_U_EmoteBookFrame, WORS_U_MusicPlayerFrame, CombatStylePanel, Backpack}




    -- Find the topmost visible frame
    local targetFrame = nil
    for _, frame in ipairs(candidateFrames) do
        if frame and frame:IsShown() then
            targetFrame = frame
            --print("Debug: Frame is shown:", frame:GetName())
            break
        end
    end



    if targetFrame then
        --print("Debug: Attaching micro buttons to", targetFrame:GetName())
        AttachMicroButtonsTo(targetFrame)
    else
        -- Restore to original UI positions
        for _, btn in ipairs(microButtonsRow1) do
            safeRestore(btn, microBackup[tostring(btn)])
            --print("Debug: Restoring micro button from row 1:", btn:GetName())
        end
        for _, btn in ipairs(microButtonsRow2) do
            safeRestore(btn, microBackup[tostring(btn)])
            --print("Debug: Restoring micro button from row 2:", btn:GetName())
        end

        if MicroButtonContainer then
            MicroButtonContainer:Hide()
            --print("Debug: MicroButtonContainer hidden.")
        end
    end
end

-- Initialize backups after entering the world
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    C_Timer.After(1, BackupOriginalMicroButtonPositions)
end)

hooksecurefunc("UpdateMicroButtons", function()
    if MicroButtonContainer and MicroButtonContainer:IsShown() then
        -- Reattach to the current parent in case a layout update broke it
        AttachMicroButtonsTo(MicroButtonContainer:GetParent())
    else
        RestoreMicroButtonsFromMicroMenu()
    end
end)
