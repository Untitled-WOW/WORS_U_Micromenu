-- Create the main frame for the custom emote book
WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent)
WORS_U_EmoteBook.frame:SetSize(192, 280)
WORS_U_EmoteBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    --bgFile = "Interface\\AddOns\\MicroMenu\\Textures\\tga_output\\1_Yes_emote_icon.tga"

	
	edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
WORS_U_EmoteBook.frame:Hide()
WORS_U_EmoteBook.frame:SetMovable(true)
WORS_U_EmoteBook.frame:EnableMouse(true)
WORS_U_EmoteBook.frame:RegisterForDrag("LeftButton")
WORS_U_EmoteBook.frame:SetClampedToScreen(true)
WORS_U_EmoteBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_EmoteBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

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

-- Create a scrollable frame for the buttons
local scrollFrame = CreateFrame("ScrollFrame", nil, WORS_U_EmoteBook.frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(180, 330)  -- Size of the scrollable area
scrollFrame:SetPoint("TOPLEFT", 5, 10)  -- Position it below the title
local scrollBar = scrollFrame.ScrollBar 
local scrollUpButton = _G[scrollBar:GetName() .. "ScrollUpButton"]
local scrollDownButton = _G[scrollBar:GetName() .. "ScrollDownButton"]
scrollBar:Hide(); scrollBar:SetAlpha(0); scrollUpButton:Hide(); scrollDownButton:Hide(); scrollUpButton:SetAlpha(0); scrollDownButton:SetAlpha(0)
scrollBar:EnableMouse(false)  -- Disable mouse interaction on the bar itself


-- Create a container for the buttons
local buttonContainer = CreateFrame("Frame", nil, scrollFrame)
buttonContainer:SetSize(180, 330)  -- Same size as scroll frame to avoid clipping
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

    local buttonWidth = 40
    local buttonHeight = 80
    local padding = 5
    local columns = 4
    local startX = 2
    local buttonStartY = -10

    for i, emoteData in ipairs(WORS_U_EmoteBook.emotes) do
        local btn = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
        btn:SetSize(buttonWidth, buttonHeight)
        btn:SetBackdrop({ bgFile = emoteData.icon })
        btn:SetNormalTexture(nil)
        btn:SetPushedTexture(nil)
        btn:SetHighlightTexture(nil)

        -- Position
        local row = math.floor((i - 1) / columns)
        local col = (i - 1) % columns
        btn:SetPoint("TOPLEFT", startX + (buttonWidth + padding) * col, buttonStartY - (buttonHeight + padding) * row)

        -- Text and click
        --btn:SetText(emoteData.name)
        --btn:SetNormalFontObject("GameFontNormalSmall")
        
		if not emoteData.command or emoteData.command == "" then
            --btn:SetBackdropColor(0.4, 0.4, 0.4, 1) -- Gray
			btn:SetBackdropColor(0.247, 0.220, 0.153, 1)

		else
            btn:SetBackdropColor(1, 1, 1, 1)
            btn:SetScript("OnClick", function() DoEmote(emoteData.command) end)
		        -- Tooltip on mouseover

		end
		btn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:ClearLines()
			GameTooltip:SetText(emoteData.name, 1, 1, 1)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()	GameTooltip:Hide() end)
		



        table.insert(emoteButtons, btn)
    end
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
-- local function OnEmoteClick(self)
	-- local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	-- if pos then
		-- local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
		-- WORS_U_EmoteBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	-- else
		-- WORS_U_EmoteBook.frame:SetPoint("CENTER")
	-- end	
	-- SetupEmoteButtons()  -- Ensure buttons are set up
	-- MicroMenu_ToggleFrame(WORS_U_EmoteBook.frame)--:Show()

-- end




local function OnEmoteClick(self)	
	SetupEmoteButtons()
	MicroMenu_ToggleFrame(WORS_U_EmoteBook.frame)--:Show()
	
end




EmotesMicroButton:SetScript("OnClick", OnEmoteClick)
EmotesMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:Show()
    end
end)
