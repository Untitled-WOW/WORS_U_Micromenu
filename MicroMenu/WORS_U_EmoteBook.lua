-- Create the main frame for the custom emote book
WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent)
WORS_U_EmoteBook.frame:SetSize(192, 280)
WORS_U_EmoteBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
WORS_U_EmoteBook.frame:Hide()
WORS_U_EmoteBook.frame:SetMovable(true)
WORS_U_EmoteBook.frame:EnableMouse(true)
WORS_U_EmoteBook.frame:RegisterForDrag("LeftButton")
WORS_U_EmoteBook.frame:SetClampedToScreen(true)
tinsert(UISpecialFrames, "WORS_U_EmoteBookFrame")
WORS_U_EmoteBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_EmoteBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
local closeButton = CreateFrame("Button", nil, WORS_U_EmoteBookFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_EmoteBookFrame, "TOPRIGHT", 4, 4)
WORS_U_EmoteBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	WORS_U_EmoteBook.frame:Hide()
    EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
	
end)
-- Create the title for the emote book
local title = WORS_U_EmoteBook.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetText("Emote Book")
title:SetPoint("TOP", WORS_U_EmoteBook.frame, "TOP", 0, -10)  -- Position title
title:SetTextColor(1, 1, 1)  -- Set title color to white
-- Create a scrollable frame for the buttons
local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_EmoteBook.frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(180, 210)  -- Size of the scrollable area
scrollFrame:SetPoint("TOPLEFT", 5, -40)  -- Position it below the title

-- Hiding the scroll bar
local scrollBar = scrollFrame.ScrollBar or _G[scrollFrame:GetName() .. "ScrollBar"]
if scrollBar then
    scrollBar:DisableDrawLayer("BACKGROUND")
    scrollBar:GetThumbTexture():SetAlpha(0)
    local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
    local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]
    scrollUpButton:GetNormalTexture():SetAlpha(0)
    scrollUpButton:GetPushedTexture():SetAlpha(0)
    scrollUpButton:GetDisabledTexture():SetAlpha(0)
    scrollUpButton:GetHighlightTexture():SetAlpha(0)
    scrollDownButton:GetNormalTexture():SetAlpha(0)
    scrollDownButton:GetPushedTexture():SetAlpha(0)
    scrollDownButton:GetDisabledTexture():SetAlpha(0)
    scrollDownButton:GetHighlightTexture():SetAlpha(0)
end

-- Create a container for the buttons
local buttonContainer = CreateFrame("Frame", nil, scrollFrame)
buttonContainer:SetSize(180, 220)  -- Same size as scroll frame to avoid clipping
scrollFrame:SetScrollChild(buttonContainer)

-- Initialize emote buttons
local emoteButtons = {}

local function SetupEmoteButtons()
    -- Clear existing buttons before creating new ones
    for _, button in pairs(emoteButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(emoteButtons)
    local buttonWidth = 40  -- Custom width for buttons
    local buttonHeight = 25  -- Custom height for buttons
    local padding = 5
    local columns = 4
    local startX = 2  -- Adjust this value to move buttons away from the left side
    local buttonStartY = -10  -- Starting Y position for buttons (below the title)
    local titleLabel = WORS_U_EmoteBook.frame.titleLabel or WORS_U_EmoteBook.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleLabel:SetPoint("TOP", 0, -10)  -- Position it at the top center of the frame
    titleLabel:SetText("Emote Book")
    WORS_U_EmoteBook.frame.titleLabel = titleLabel  -- Store it for later reference
    for i, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
        local emoteButton = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
        emoteButton:SetSize(buttonWidth, buttonHeight)
        -- Set up the button border
        emoteButton:SetBackdrop({
            edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border", -- Border texture
            edgeSize = 8,  -- Border thickness
            insets = { left = 2, right = 2, top = 2, bottom = 2 },  -- Insets for border
        })
        -- Hide the default textures
        emoteButton:SetNormalTexture(nil)
        emoteButton:SetPushedTexture(nil)
        emoteButton:SetHighlightTexture(nil)
        -- Calculate position
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        emoteButton:SetPoint("TOPLEFT", startX + (buttonWidth + padding) * column, buttonStartY - (buttonHeight + padding) * row)
        emoteButton:SetText(emoteData.name)
        emoteButton:SetNormalFontObject("GameFontNormalSmall")
        emoteButton:SetScript("OnClick", function()
            DoEmote(emoteData.command)  -- Use the actual command for each emote
        end)
        table.insert(emoteButtons, emoteButton)
    end
    LoadTransparency()  -- Load the saved transparency when buttons are set up
end

-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_EmoteBook.frame:IsShown() then
        EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red
    else
        EmotesMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
    end
end
WORS_U_EmoteBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_EmoteBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- Function to handle EmotesMicroButton clicks
local function OnEmoteClick(self)
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if pos then
		local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	else
		WORS_U_EmoteBook.frame:SetPoint("CENTER")
	end	
    if IsAltKeyDown() then
		WORS_U_EmoteBook.frame:Show()
        currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_EmoteBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()  -- Save transparency after change
    else
        if WORS_U_EmoteBook.frame:IsShown() then
            WORS_U_EmoteBook.frame:Hide()
        else
            SetupEmoteButtons()  -- Ensure buttons are set up
            MicroMenu_ToggleFrame(WORS_U_EmoteBook.frame)--:Show()
        end
    end
end
EmotesMicroButton:SetScript("OnClick", OnEmoteClick)
EmotesMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("ALT + Click to change transparency.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)
