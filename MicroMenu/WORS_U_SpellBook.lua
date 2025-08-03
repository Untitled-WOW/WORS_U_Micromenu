-- WORS_U_SpellBook.lua
local magicButtons = {}

-- Create the main frame for the custom spell book
WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent)
WORS_U_SpellBook.frame:SetSize(180, 330)
-- WORS_U_SpellBook.frame:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground1",
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile = false, tileSize = 32, edgeSize = 32,
    -- insets = { left = 5, right = 5, top = 5, bottom = 5 }
-- })
WORS_U_SpellBook.frame:SetFrameStrata("High")
WORS_U_SpellBook.frame:SetFrameLevel(10)
WORS_U_SpellBook.frame:Hide()
WORS_U_SpellBook.frame:SetMovable(true)
WORS_U_SpellBook.frame:EnableMouse(true)
WORS_U_SpellBook.frame:RegisterForDrag("LeftButton")
WORS_U_SpellBook.frame:SetClampedToScreen(true)

WORS_U_SpellBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SpellBook.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing() 
	SaveFramePosition(self)
end)

local closeButton = CreateFrame("Button", nil, WORS_U_SpellBookFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_SpellBookFrame, "TOPRIGHT", 4, 4)
WORS_U_SpellBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	WORS_U_SpellBook.frame:Hide()
end)

function UpdateSpellMicroButtonBackground()
    local spellBookShown = WORS_U_SpellBookFrame and WORS_U_SpellBookFrame:IsShown()
    -- Count how many of your custom frames are visible
    local visibleCount = 0
    for _, frame in ipairs(MicroMenu_Frames) do
        if frame and frame:IsShown() then
            visibleCount = visibleCount + 1
        end
    end
	if Backpack and Backpack:IsShown() then
		visibleCount = visibleCount + 1
	end
    local buttonTexture = U_SpellBookMicroButtonCopy:GetNormalTexture()

    if spellBookShown then
        if visibleCount == 1 then
            buttonTexture:SetVertexColor(1, 0, 0)  -- red = only frame open
        else
            buttonTexture:SetVertexColor(0, 1, 0)  -- green = stealth/preloaded
        end
    else
        buttonTexture:SetVertexColor(1, 1, 1)      -- white = hidden
    end
end

WORS_U_SpellBook.frame:SetScript("OnShow", UpdateSpellMicroButtonBackground)
WORS_U_SpellBook.frame:SetScript("OnHide", UpdateSpellMicroButtonBackground)

local function setupMagicFrame()
    SetupMagicButtons(-8, 3, WORS_U_SpellBook.frame, magicButtons)
end


-- Function to handle MagicMicroButton clicks
local function OnMagicClick(self)
	MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)
end

local positioned = false
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if pos then
		local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_SpellBook.frame:SetPoint(
			pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs
		)
	else
		WORS_U_SpellBook.frame:SetPoint("CENTER")
	end
	setupMagicFrame()
end)

U_SpellMicroMenuButton:SetScript("OnClick", OnMagicClick)