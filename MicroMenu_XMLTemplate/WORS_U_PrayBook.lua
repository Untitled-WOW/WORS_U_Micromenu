-- WORS_U_PrayBook.lua
local prayerButtons = {}

-- Create the prayer book frame
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent)
WORS_U_PrayBook.frame:SetSize(180, 330)
-- WORS_U_PrayBook.frame:SetBackdrop({
    -- bgFile   = "Interface\\WORS\\OldSchoolBackground1",
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile     = false, tileSize = 32, edgeSize = 32,
    -- insets   = { left = 5, right = 5, top = 5, bottom = 5 },
-- })
WORS_U_PrayBook.frame:SetFrameStrata("HIGH")
WORS_U_PrayBookFrame:SetFrameLevel(10)
WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetClampedToScreen(true)
WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) 	
	self:StartMoving() 
end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self) 	
	self:StopMovingOrSizing() 
	SaveFramePosition(self)
end)
-- Close button
local closeButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_PrayBook.frame, "TOPRIGHT", 4, 4)
WORS_U_PrayBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	WORS_U_PrayBook.frame:Hide()
end)

-- Micro button highlight update
function UpdatePrayMicroButtonBackground()
    local prayerBookShown = WORS_U_PrayBookFrame and WORS_U_PrayBookFrame:IsShown()
    local buttonTexture = PrayerMicroButton:GetNormalTexture()
    if prayerBookShown then
		buttonTexture:SetVertexColor(1, 0, 0)  -- red 
    else
        buttonTexture:SetVertexColor(1, 1, 1)  -- normal 
    end
end
WORS_U_PrayBook.frame:SetScript("OnShow", UpdatePrayMicroButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdatePrayMicroButtonBackground)

local function setupPrayerFrame()
    SetupPrayerButtons(-8, 3, WORS_U_PrayBook.frame, prayerButtons)
end


-- PrayerMicroButton click handler
local function OnPrayerClick(self)
	MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)
end


local positioned = false
local eventFrame = CreateFrame("Frame")
-- Register the events we'll use
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if pos then
		local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_PrayBook.frame:SetPoint(
			pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs
		)
	else
		WORS_U_PrayBook.frame:SetPoint("CENTER")
	end
	setupPrayerFrame()
end)

PrayerMicroButton:SetScript("OnClick", OnPrayerClick)
PrayerMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")    -- anchor the tooltip below the button
		GameTooltip:SetText("Prayer", 1, 1, 1, 1, true) -- white text, wrap if needed
		GameTooltip:AddLine("Open Prayer menu for spells, to open WOW Prayer book ui click Spellbook & Abilities", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:Show()
    end
end)